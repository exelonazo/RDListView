# RDListView

ListView — Soporta desde : iOS 9.0 —

Para iniciar la aplicación, debemos abrir el archivo : ListViews.xcworkspace

Es necesario tener cocoapods instalado, en caso que los pods/librerías no estén inyectados, hay que hacer un pod install en el terminal para la instalación de estos. El Podfile va incluído en el listado de archivos.



CocoaPods : Usamos cocoapods para la inyección de dependencias en iOS.

    ·  Alamofire : Alamofire es una biblioteca especifica para Swift, que nos permite realizar peticiones a un servidor web cumpliendo y explotando todas las capacidades de HTTP.

    ·  SwiftyJson : Es una librería que está creada para la facilitación en el proceso de consumir JSONs.

    ·  IJProgressView : Es una simple librería que muestra un 'Cargando'(ProgressView).



NOTA : Para el uso del WebView es necesario modificar el info.plist para permitir la conexión con protocolos HTTP los cuales son inseguros, por tanto este código es una "Mala Práctica", sólo se usará con fines de la realización de la prueba técnica.

Modificación del plist :
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
</dict>

Se adjunta la recomendación de Apple :
"Setting NSAllowsArbitraryLoads to true will allow it to work, but Apple was very clear in that they intend to reject apps who use this flag without a specific reason. The main reason to use NSAllowsArbitraryLoads I can think of would be user created content (link sharing, custom web browser, etc). And in this case, Apple still expects you to include exceptions that enforce the ATS for the URLs you are in control of.

If you do need access to specific URLs that are not served over TLS 1.2, you need to write specific exceptions for those domains, not use NSAllowsArbitraryLoads set to yes. You can find more info in the NSURLSesssion WWDC session.

Please be careful in sharing the NSAllowsArbitraryLoads solution. It is not the recommended fix from Apple."
