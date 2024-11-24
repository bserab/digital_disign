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
    GMSServices.provideAPIKey(FlutterConfigPlugin.env(for: "AIzaSyAZce-0fGnUlE5lgAUysm8p4vUSpE1aqrM"))
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
