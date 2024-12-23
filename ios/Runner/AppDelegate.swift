import UIKit
import Flutter
import GoogleMaps

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    // MethodChannelの設定
    let controller = window?.rootViewController as! FlutterViewController
    let channel = FlutterMethodChannel(name: "com.example.myapp/env",
                                       binaryMessenger: controller.binaryMessenger)

    channel.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) in
      if call.method == "setApiKey" {
        if let args = call.arguments as? [String: Any],
           let apiKey = args["apiKey"] as? String {
          GMSServices.provideAPIKey(apiKey)
          print("API Key set in AppDelegate: \(apiKey)")
          result("API Key Set Successfully")
        } else {
          result(FlutterError(code: "INVALID_ARGUMENTS",
                              message: "API key not provided",
                              details: nil))
        }
      } else {
        result(FlutterMethodNotImplemented)
      }
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
