import Flutter
import UIKit
import GoogleMaps

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    
    // info.plistからAPI_KEYを取得して設定
    if let apiKey = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String {
      GMSServices.provideAPIKey(apiKey)
      print("API Key loaded successfully: \(apiKey)") // デバッグ用
    } else {
      print("API Key not found in Info.plist")
    }
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
