// If you need access to the appName or app version you must use the following
// grails.util.Metadata.current.'app.name'
// grails.util.Metadata.current.'app.version'
//
//
import java.awt.Color

//omar.serverIP=
//omar.serverURL=
//wms.referenceDataDirectory=
//wms.mapFile=
//thumbnail.cacheDir="${wms.referenceDataDirectory}/omar-cache"
//videoStreaming.flashDirRoot=
//image.download.prefix = "http://${omar.serverIP}"

wms.base.defaultOptions = [isBaseLayer: true, buffer: 0, transitionEffect: "resize"]
wms.supportIE6=true

wms.base.layers = [
        [
                url: "http://${omar.serverIP}/cgi-bin/mapserv.exe?map=${wms.mapFile}",
                params: [layers: "Reference", format: "image/jpeg"],
                name: "Reference Data",
                options: wms.base.defaultOptions
        ]

]


wms.data.raster = [
        url: "${ omar.serverURL }/wms/footprints",
        params: [styles: "byFileType", transparent:true, layers: ( wms.supportIE6) ? "Imagery" : "ImageData", format: ( wms.supportIE6) ? "image/gif" : "image/png"],
        name: "OMAR Imagery Coverage",
        options: [isBaseLayer:false, footprintLayers: "Imagery"]
]

wms.data.video = [
        url: "${ omar.serverURL }/wms/footprints",
        params: [styles: "byFileType", transparent:true, layers: ( wms.supportIE6) ? "Videos" : "VideoData", format: ( wms.supportIE6) ? "image/gif" : "image/png"],
        name: "OMAR Video Coverage",
        options: [isBaseLayer:false, footprintLayers: "Videos"]
]

styles = [
      [
          propertyName : "fileType",
          outlineLookupTable :[
                  //aaigrid: 4,
                  cadrg: new Color( 0, 255, 255, 255 ),
                  cib: new Color(0,128,128,255),
                  ccf: new Color( 128, 100, 255, 255 ),
                  adrg: new Color( 50, 111, 111, 255 ),
                  mrsid: new Color(0,188,0,255),
                  //doqq: 2,
                  dted: new Color( 0, 255, 0, 255 ), // green
                  jpeg: new Color( 255, 255, 0, 255 ), // yellow
                  jpeg2000: new Color( 255, 200, 0, 255 ), //
                  landsat7: new Color( 255, 0, 255, 255 ), // purple
                  nitf: new Color( 0, 0, 255, 255 ),  // blue
                  tiff: new Color( 255, 0, 0, 255 ),  // red
                  mpeg: new Color(164,254,255,255),
                  unspecified: new Color(255,255,255,255) // white
          ],
      ],
      [
          propertyName : "sensorId",
          defaultOutlineColor : new Color( 255, 255, 255, 255 ),
          defaultFillColor : new Color( 0, 0, 0, 0 ),

          outlineLookupTable :[
                  'ACES_YOGI-HRI1': new Color( 255, 0, 0, 255 ),
                  'ACES_YOGI-HRI2': new Color( 255, 0, 0, 255 ),
                  'ACES_YOGI-HRI3': new Color( 255, 0, 0, 255 ),
                  'ACES_YOGI-HSI': new Color( 255, 255, 0, 255 ),
                  ALPHA: new Color( 255, 0, 255, 255 ),
                  BRAVO: new Color( 0, 255, 0, 255 ),
                  CHARLIE: new Color( 0, 255, 255, 255 ),
                  DELTA: new Color( 0, 0, 255, 255 ),
                  unspecified: new Color(255,255,255,255) // white
          ]
        ]
]



login.registration.enabled=true
login.registration.userVerification="manual"
login.registration.createLdapUser=false
login.registration.useMail=(login.registration.userVerification== "email")

jabber.securityMode = "disabled"


//security {
//  level = 'UNCLASS'
//level = 'SECRET'
//level = 'TOPSECRET'
//    UNCLASS = [description: "Unclassified", color: "green"]
//    SECRET = [description: "Secret // NOFORN", color: "red"]
//    TOPSECRET = [description: "Top Secret", color: "yellow"]
//    sessionTimeout = 60
//    level = "UNCLASS"
//}

