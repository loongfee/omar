import org.ossim.omar.oms.InfoGetterPool

class OmarOmsGrailsPlugin
{
  // the plugin version
  def version = "0.1"
  // the version or versions of Grails the plugin is designed for
  def grailsVersion = "1.2.2 > *"
  // the other plugins this plugin depends on
  def dependsOn = [:]
  // resources that are excluded from plugin packaging
  def pluginExcludes = [
          "grails-app/views/error.gsp"
  ]

  // TODO Fill in these fields
  def author = "Scott Bortman"
  def authorEmail = "sbortman@radiantblue.com"
  def title = "OMAR OMS"
  def description = '''\\
Add the JNI bindings from OMS to the grails environment. 
'''

  // URL to the plugin's documentation
  def documentation = "http://grails.org/plugin/omar-oms"

  def doWithWebDescriptor = { xml ->
    // TODO Implement additions to web.xml (optional), this event occurs before
  }

  def doWithSpring = {
    // TODO Implement runtime spring config (optional)
    infoGetterPool(InfoGetterPool, 8)

  }

  def doWithDynamicMethods = { ctx ->
    // TODO Implement registering dynamic methods to classes (optional)
  }

  def doWithApplicationContext = { applicationContext ->
    // TODO Implement post initialization spring config (optional)
  }

  def onChange = { event ->
    // TODO Implement code that is executed when any artefact that this plugin is
    // watching is modified and reloaded. The event contains: event.source,
    // event.application, event.manager, event.ctx, and event.plugin.
  }

  def onConfigChange = { event ->
    // TODO Implement code that is executed when the project configuration changes.
    // The event is the same as for 'onChange'.
  }
}
