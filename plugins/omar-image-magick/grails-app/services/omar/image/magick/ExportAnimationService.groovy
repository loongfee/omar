package omar.image.magick
import org.ossim.omar.core.Utility

class ExportAnimationService 
{
	def grailsApplication

	def export(def imageFileNames, def format) 
	{
		def date = new Date().getTime()
		def tempFilesLocation = grailsApplication.config.export.workDir + "/"

		def command = []
		command[0] = "convert"
		for (item in imageFileNames) { command += item }
		command += "${tempFilesLocation}${date}timeLapse.${format}"
		executeCommand(command)

		def file
		for (item in imageFileNames)
		{
			file = new File( "${item}" )
			if ( file.exists() )
			{
				command = "rm ${file}"
				executeCommand(command) 
			}
		}

                return "${tempFilesLocation}${date}timeLapse.${format}"
	}

	def executeCommand(def executableCommand)
	{
        return Utility.executeCommand(executableCommand, true).text
	}
}
