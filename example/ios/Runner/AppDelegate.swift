import UIKit
import Flutter
import SuprSendSdk // Add this
import UserNotifications
import app_links

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)

//    // Retrieve the link from parameters
//    if let url = AppLinks.shared.getLink(launchOptions: launchOptions) {
//      // We have a link, propagate it to your Flutter app or not
//        print("app delegate link", url)
//      AppLinks.shared.handleLink(url: url)
//      return true // Returning true will stop the propagation to other packages
//    }

        //  suprsend initialization code
        let suprSendConfiguration = SuprSendSDKConfiguration(withKey: "<your_ws_key>", secret:"<your_ws_secret>")
        SuprSend.shared.configureWith(configuration: suprSendConfiguration  , launchOptions: launchOptions)
        SuprSend.shared.setDeepLinkDelegate(self)
        SuprSend.shared.enableLogging()
        var options: UNAuthorizationOptions = [.badge, .alert, .sound]
        UNUserNotificationCenter.current().delegate = self
        SuprSend.shared.registerForPushNotifications(options: options)
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    
    //    suprsend code block from below for iOS push related events
    
    override func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let  token = tokenParts.joined()
        SuprSend.shared.setPushNotificationToken(token: token)  // Send APNS Token to SuprSend
    }
    
    @available(iOS 10.0, *)
    override func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        if response.isSuprSendNotification() {
            SuprSend.shared.userNotificationCenter(center, didReceive: response)
        }
        completionHandler()
    }
    
    override func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]){
        SuprSend.shared.application(application, didReceiveRemoteNotification: userInfo)
    }
    
    @available(iOS 10.0, *)
    override func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        if #available(iOS 14.0, *) {
            completionHandler([.banner, .badge, .sound])
        } else {
            completionHandler([.alert, .badge, .sound])
        }
    }
    
//    override func application(_ app: UIApplication, open url: URL,
//                         options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
//        print("deeplink url", url)
//            return true
//        }
}


extension AppDelegate: SuprSendDeepLinkDelegate {
    func shouldHandleSuprSendDeepLink(_ url: URL) -> Bool {
        print("executing the deeplink delegate", url);
        
        if url.absoluteString.hasPrefix("https://web-inbox-assets.suprsend.com/") {
            let deeplink = url.absoluteString.replacingOccurrences(of: "https://web-inbox-assets.suprsend.com/", with: "com.suprsend://")
            UIApplication.shared.open(URL(string: deeplink)!)
            return false
        }
        
        return true
    }
}
