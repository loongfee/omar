#!/usr/bin/env groovy
environmentVariables =[
   OMAR_URL:"http://localhost:8080/omar",
   OMAR_THUMBNAIL_CACHE:"/data/omar/omar-cache",
   NTHREADS: 4,
   OMARDB:"omardb-${System.env.OSSIM_RELEASE_VERSION_NUMBER?:System.env.OSSIM_VERSION}-dev",
   POSTGRES_USER:"postgres",
   POSTGRES_PASSWORD:"postgres",
   POST_COMMAND_LINE:"NO",
   LOG_FILE:"",
   PID_FILE:"",
   CLASSPATH:"${System.env.OSSIM_DIST_ROOT}/tomcat/webapps/omar/WEB-INF/lib", 
   //STAGE_FILE_FILTER:"", 
   STAGE_FILE_FILTER:"nitf,ntf",
   HISTOGRAM_OPTIONS:"--create-histogram-fast",
   OVERVIEW_OPTIONS:"--compression-type JPEG --compression-quality 75"
]


import java.lang.management.ManagementFactory
import groovy.io.FileType
import groovy.sql.Sql

if(!(environmentVariables.CLASSPATH as File).exists())
{
   File testFile = new File("${System.env.OMAR_HOME}/target/WEB-INF/lib")
   if(testFile.exists())
   {
      environmentVariables.CLASSPATH=testFile.absolutePath
   }
}
//println "*************************** ${environmentVariables.CLASSPATH}"
class OmarRunScript{
   def env
   def runScriptFile
   def runScriptDirectory
   def envVariables
   def scriptToRun
   def scriptArgs
   def args
   def outputUsage()
   {
      def runnableScripts = []
    try{
      def tempFile = runScriptDirectory as File
         tempFile.traverse( type:FileType.FILES, nameFilter:~/.*.groovy/ ) {
                 
           if(it.name != runScriptFile)
            {
                  runnableScripts << it.name.replaceFirst(~/\.[^\.]+$/, '')
            }
         }

      }
      catch(def e)
      {
         outputLog(e)
      }

      println """Supported Scripts:
${runnableScripts.join("\n")}

To run any script please use the command: 
   ${runScriptFile.name} <script>

To bring up this usage: 
   ${runScriptFile.name} --help

To bring up help on any script please use the following format: 
   ${runScriptFile.name} <script> --help

The .groovy extension is not needed and will be appended when running a script file if the extension .groovy is not present.  
To get help on any script please run:

   ${runScriptFile.name} <script> --help
   
"""
   }
   def run(args)
   {
      if(!args.length || (args[0] == "--help"))
      {
         outputUsage();
         return 0;
      }
      this.args = args
      scriptToRun  = findScriptToRun(new File(args[0]))

      if(!scriptToRun)
      {
         outputLog("Unable to find script ${args[0]}")
         return 1;
      }

     env.PID_FILE = new File(scriptToRun.toString()+".pid")
     if(checkPidRunning())
      {
         println "Process ${scriptToRun} is already running"
         return 0;
      }
      outputPid();
      loadJars();

      def shell = new GroovyShell();
      this.scriptArgs = [];
      if(args.length>1) (1..args.length-1).each{this.scriptArgs << args[it]}
      shell.setVariable("parent", this)
      return shell.evaluate(scriptToRun)
   }
   def findScriptToRun(script)
   {
      def result = script
      // test extension
      //
      result = script.name.lastIndexOf('.') >0?script:new File(script.toString()+".groovy")

      if(!result.exists())
      {
         result = new File(runScriptDirectory, result.name)
         if(!result.exists())
         {
            return "";
         }
      }

      result
   }
   def outputLog(value)
   {
       if(env.LOG_FILE)
       {
         (env.LOG_FILE as File).withWriterAppend(){it << "${value}\n"}
       }
       else
       {
         println value;
       }
   }
   def newSqlConnection()
   {
      Sql.newInstance([
       url: "jdbc:postgresql:${env.OMARDB}",
       user: "${env.POSTGRES_USER}",
       password: "${env.POSTGRES_PASSWORD}",
       driver: "org.postgresql.Driver"
    ]);
   }
   def findWar()
   {
      def version = System.env.OSSIM_RELEASE_VERSION_NUMBER
      if(!version)
      {
         version =  System.env.OSSIM_VERSION
      }
      def test = new File("${System.env.OSSIM_DIST_ROOT}/tomcat/webapps/omar.war ")
      if(!test.exists())
      {
         test = new File("${System.env.OSSIM_INSTALL_PREFIX}/omar/omar.war")
         if(!test.exists())
         {
            test = new File("")
         }
      }
      test.toString()
   }
   def loadJars()
   {
      // For now until we get local repositories setup we will try to find the extracted WAR file location
      //
      if(!env.CLASSPATH)
      {
         // try to find class path
         //
         def test = new File("${System.env.OMAR_HOME}/target/WEB-INF/lib")
         if(!test.exists())
         {
            def warFile = new File(findWar())
            if(warFile.exists())
            {
               def warFileExtractTo = new File(warFile.parent,"omar");
               if(!warFileExtractTo.exists())
               {
                  outputLog("Extracting WAR ${warFile} to location ${warFileExtractTo}")
                  def command = "unzip ${warFile} -d ${warFileExtractTo}"
                  def output  = command.execute();

                  output.consumeProcessOutput()
                  output.waitFor()
               }
               test = new File(warFileExtractTo.toString(), "WEB-INF/lib")
            }
         }
         env.CLASSPATH = test.toString();
      }
      def loader = this.class.classLoader.rootLoader
      def splitClasspath = env.CLASSPATH.split(":");
      splitClasspath.each{
         def file = new File(it)

         if(file.name.endsWith(".jar"))
         {
            jars.each { loader.addURL(file.toURI().toURL()) }
         }
         else
         {
            try{
               file.traverse( type:FileType.FILES, nameFilter:~/.*.jar/ ) {
                  loader.addURL(it.toURI().toURL())
               }

            }
            catch(def e)
            {
               outputLog(e)
            }
         }
      }
   }
   def outputPid()
   {
      def pidString = (ManagementFactory.getRuntimeMXBean().getName() as String);


      def pid = pidString?.find(/\d+/)

      (this.env.PID_FILE as File).withWriter() { it << pid }
      pid
   }

   def checkPidRunning()
   {
      def result=false
      def PID=""
      if(env.PID_FILE.exists())
      {
         PID = Integer.parseInt(env.PID_FILE.text)
         def command = "kill -s 0 ${PID}"
         def output = command.execute();

         output.waitFor()
         def text = output.err.text //output.consumeProcessOutput()

         if(!text)
         {
            result = true
         }
      }

      result;
   }

   def post(def urlParam, def urlEncodedParams)
   {
      def result
      if(env.POST_COMMAND_LINE == "YES")
      {
         def command = "curl"

         if(urlEncodedParams)
         {
           command += " --data ${urlEncodedParams} ${urlParam}"
         }
         else
         {
           command += " ${urlParam}"
         }
         def output = command.execute();

         result = output.text //output.consumeProcessOutput()
         output.waitFor()
      }
      else
      {
         def wr;
         def url = new URL(urlParam);
         try{
            def connection = url.openConnection(); 
            connection.setDoOutput(true); 
            connection.setRequestMethod("POST"); 
            connection.setRequestProperty("Content-Type", "application/x-www-form-urlencoded"); 
            connection.setRequestProperty("charset", "utf-8");

            if(urlEncodedParams)
            {
               wr = new OutputStreamWriter(connection.getOutputStream()); 
               wr.write(urlEncodedParams); 
               wr.flush(); 
            }
            result = connection.getInputStream().getText("utf-8"); 
         }
         catch(def e)
         {
            result = e
         }
         wr?.close(); 
      }

      result
   }
   def postDataManager(filename, command)
   {

      this.post("${env.OMAR_URL}/dataManager/${command}",
            URLEncoder.encode("filename", "UTF-8") + "=" + URLEncoder.encode(filename as String, "UTF-8"))
   }
   def postRunning()
   {
      this.post("${env.OMAR_URL}/running", null)
   }
}
def runScript = new OmarRunScript();


runScript.runScriptFile  = new File(getClass().protectionDomain.codeSource.location.path)
runScript.runScriptDirectory = runScript.runScriptFile.parent
runScript.env = environmentVariables
runScript.run(args);

