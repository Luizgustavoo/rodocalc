import UIKit
import Flutter
import Firebase


@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    // Solicitar permissões para notificações
    UNUserNotificationCenter.current().delegate = self
    let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
    UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { granted, error in
      if let error = error {
        print("Erro ao solicitar permissões: \(error)")
      } else if granted {
        print("Permissões concedidas para notificações")
      }
    }

    application.registerForRemoteNotifications()


    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

}
