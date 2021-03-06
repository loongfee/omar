class OmarOgcGrailsPlugin
{
  // the plugin version
  def version = "0.2"
  // the version or versions of Grails the plugin is designed for
  def grailsVersion = "1.3.5 > *"
  // the other plugins this plugin depends on
  def dependsOn = [
      csv: "0.3 > *"
  ]
  // resources that are excluded from plugin packaging
  def pluginExcludes = [
      "grails-app/views/error.gsp"
  ]

  // TODO Fill in these fields
  def author = "Scott Bortman"
  def authorEmail = "sbortman@radiantblue.com"
  def title = "OMAR OGC"
  def description = '''\\
Adds OGC functionality to OMAR
'''

  // URL to the plugin's documentation
  def documentation = "http://grails.org/plugin/omar-ogc"

  def doWithWebDescriptor = { xml ->
    // TODO Implement additions to web.xml (optional), this event occurs before
  }

  def doWithSpring = {
    csvResultFormat( org.ossim.omar.ogc.wfs.CsvResultFormat ) {
      grailsApplication = ref( 'grailsApplication' )
    }

    gml2ResultFormat( org.ossim.omar.ogc.wfs.Gml2ResultFormat ) {
      grailsApplication = ref( 'grailsApplication' )
      grailsLinkGenerator = ref( 'grailsLinkGenerator' )
    }

    shpResultFormat( org.ossim.omar.ogc.wfs.ShpResultFormat )

    kmlResultFormat( org.ossim.omar.ogc.wfs.KmlResultFormat ) {
      grailsApplication = ref( 'grailsApplication' )
      grailsLinkGenerator = ref( 'grailsLinkGenerator' )
    }

    kmlqueryResultFormat( org.ossim.omar.ogc.wfs.KmlQueryResultFormat ) {
      grailsApplication = ref( 'grailsApplication' )
      grailsLinkGenerator = ref( 'grailsLinkGenerator' )
    }

    geojsonResultFormat( org.ossim.omar.ogc.wfs.GeoJsonResultFormat )

    jsonResultFormat( org.ossim.omar.ogc.wfs.GeoJsonResultFormat ) {
      name = "JSON"
    }

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
