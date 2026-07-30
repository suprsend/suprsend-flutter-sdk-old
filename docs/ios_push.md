# iOS Push Setup

Set up APNs iOS push notifications in your Flutter app with SuprSend, covering Apple certificates, capabilities, AppDelegate hooks, and token registration.

> **Warning**
>
> Starting from iOS version v1.0.0, we have introduced explicit push notification permission and an option to add images in your notification. We have also introduced background mode for improved tracking of notification delivery.
>
> If you are using an iOS version older than v1.0.0 and upgrading to the new version, please ensure you use the latest integration steps, especially for the methods below:
>
> 1. [Adding Background mode capability](#step-1-add-capabilities-in-ios-application)
> 2. [Calling registerPush method](#step-2-register-for-push-notification-in-appdelegateswift-file)
> 3. [Tracking delivery methods](#step-4-enable-sending-and-tracking-of-push-notifications)

> **Tip:** An example Flutter app with this implementation can be found in the [example](../example) folder.

## Step 1: Add capabilities in iOS application

1. Inside Targets, select **Signing & Capabilities**.
2. Click on **+ Capability** and select **Push Notifications** and **Background Modes**.

![Signing & Capabilities in Xcode](https://mintcdn.com/suprsend/3ix_OjxB_ZGM-pa-/images/docs/29bafbe-Screenshot_2022-05-19_at_5.48.52_PM.png?fit=max&auto=format&n=3ix_OjxB_ZGM-pa-&q=85&s=6dc8960bc305b9ff439cfd265cd4f1dc)

In Background Modes, select the **Remote Notifications** option. We use background notifications to receive delivery reports when your app is in the quit and background state. Refer to this [doc](https://developer.apple.com/documentation/usernotifications/setting_up_a_remote_notification_server/pushing_background_updates_to_your_app) to know more about background notifications.

![Background Modes - Remote Notifications](https://mintcdn.com/suprsend/09Y8zJBSaqwwb23r/images/docs/75c5310-Screenshot_2022-09-27_at_1.48.11_PM.png?fit=max&auto=format&n=09Y8zJBSaqwwb23r&q=85&s=3455b9ac0218ac1621399be197c1b46a)

## Step 2: Register for push notification in AppDelegate.swift file

Call the `registerForPushNotifications` method below the SuprSend SDK initialization code, which will register the iOS device for the push service.

```swift
// AppDelegate.swift
SuprSend.shared.configureWith(configuration: suprSendConfiguration  , launchOptions: launchOptions) // init code which is already added at time of initialisation
var options: UNAuthorizationOptions = [.badge, .alert, .sound] // Add this
SuprSend.shared.registerForPushNotifications(options: options) // Add this
```

## Step 3: Asking the user to send push notifications

There are 2 ways in which your app can prompt users to allow push notifications on their devices:

### Explicit Authorization

Explicit authorization allows you to display alerts, add a badge to the app icon, or play sounds whenever a notification is delivered. In this type of authorization, the request is made the first time the user launches your app. If the user denies the request, you can't send subsequent prompts to send the notification.

![Explicit authorization permission prompt](https://mintcdn.com/suprsend/JOwfEC79k-vs3tUR/images/docs/8538f91-app_permission.png?fit=max&auto=format&n=JOwfEC79k-vs3tUR&q=85&s=3e3be8e0b3762dd835a490e6c4c1af7f)

> **Info:** Explicit authorization is the default authorization method as it automatically sets alert, sound, and badge as soon as the user allows this request.

### Provisional Authorization

Provisional Authorization (supported in iOS 12.0 and above) is sent quietly to the users — they don't interrupt the user with a sound or banner. Also, they will not be shown when your app is in the foreground. The first time this type of notification is sent, the user is asked to "Keep" or "Turn off" the notifications. Further notifications continue to be sent if they click on "Keep".

![Provisional authorization prompt](https://mintcdn.com/suprsend/ftswjUsq0JlUh-RL/images/docs/0367021-provisional.png?fit=max&auto=format&n=ftswjUsq0JlUh-RL&q=85&s=c44246faebb35ddb646e77c3ea29a522)

Add the below code in the `AppDelegate.swift` file for provisional authorization.

```swift
// AppDelegate.swift
SuprSend.shared.configureWith(configuration: suprSendConfiguration  , launchOptions: launchOptions) // init code which is already added at time of initialisation
var options: UNAuthorizationOptions = [.badge, .alert, .sound, .provisional] // Add this
SuprSend.shared.registerForPushNotifications(options: options) // Add this
```

## Step 4: Enable sending and tracking of push notifications

Receiving the iOS APNS token, sending it to the backend, listening for push notifications, and tracking user notification clicks can be done using the following snippet of code. Directly copy and paste it at the end of the `AppDelegate.swift` file inside the *AppDelegate* class.

```swift
// AppDelegate.swift
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
```

> **Warning:** iOS Push notifications only work on real devices, so while developing/testing use a real device to test it instead of simulators. From Xcode 15, push support can be tested in simulators as well.

## Step 5: Adding support for Notification Service

For better notification status (delivered, seen) tracking, this step is needed.

### 1. In Xcode go to File > New > Target

### 2. Select Notification Service Extension from the template list

### 3. Name your Notification Service

Then in the Next popup, give a suitable name to your notification service, select your team, select the Swift language, and click Finish.

![Naming the Notification Service Extension](https://mintcdn.com/suprsend/3ix_OjxB_ZGM-pa-/images/docs/2545534-Screenshot_2022-09-27_at_8.23.30_PM.png?fit=max&auto=format&n=3ix_OjxB_ZGM-pa-&q=85&s=7d5b605ac23ad4753e43f6bbfc846424)

### 4. A folder will be created with your given product name

After clicking on `Finish`, a folder will be created with your given product name. Inside that there will be a **`NotificationService.swift`** file like below.

![Generated NotificationService.swift file](https://mintcdn.com/suprsend/09Y8zJBSaqwwb23r/images/docs/507d91a-Screenshot_2022-09-27_at_8.30.25_PM.png?fit=max&auto=format&n=09Y8zJBSaqwwb23r&q=85&s=844b510f372bafdcb4ff19dc6120c314)

### 5. Rename and run pod install

In your project **`Podfile`** add the following snippet. Replace `<your notification service name>` with the name given in step 3. After that, run `pod install`.

```ruby
# Podfile
target '<your notification service name>' do
  use_frameworks!

  pod 'SuprsendCore'
  pod 'SuprSendSdk'

end
```

![Podfile with notification service target](https://mintcdn.com/suprsend/JOwfEC79k-vs3tUR/images/docs/8397e64-Screenshot_2024-08-14_at_4.34.21_PM.png?fit=max&auto=format&n=JOwfEC79k-vs3tUR&q=85&s=3e0c42ccbf163298ffb941ca71a249f2)

### 6. Replace values with your Workspace Key and Workspace Secret

Replace the content in the **`NotificationService.swift`** file with the below code. In this snippet, on lines 11 and 12, replace the values with your workspace key and workspace secret.

```swift
// NotificationService.swift
import UserNotifications
import UIKit
import SuprSendSdk

class NotificationService: UNNotificationServiceExtension {
var contentHandler: ((UNNotificationContent) -> Void)?
var modifiedNotificationContent: UNMutableNotificationContent?

private func track(request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {

        let suprSendConfiguration = SuprSendSDKConfiguration(
            withKey: "your workspace key",
            secret: "your workspace secret"
        )

        SuprSend.shared.configureWith(configuration: suprSendConfiguration , launchOptions: [:])
        SuprSend.shared.didReceive(request, withContentHandler: contentHandler)
    }

override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
    self.contentHandler = contentHandler
    modifiedNotificationContent = (request.content.mutableCopy() as? UNMutableNotificationContent)

     track(request: request, withContentHandler: contentHandler)

    if let modifiedNotificationContent = modifiedNotificationContent {
        // Modify the notification content here...
        // 1
        guard let imageURLString =
                modifiedNotificationContent.userInfo["image_url"] as? String else {
            contentHandler(modifiedNotificationContent)
            return
        }

        getMediaAttachment(for: imageURLString) { [weak self] image in
            guard let self = self, let image = image, let fileURL = self.saveImageAttachment(
                image: image,
                forIdentifier: "attachment.png")
            else {
                contentHandler(modifiedNotificationContent)
                return
            }

            let imageAttachment = try? UNNotificationAttachment(
                identifier: "image",
                url: fileURL,
                options: nil)

            if let imageAttachment = imageAttachment {
                modifiedNotificationContent.attachments = [imageAttachment]
            }

            contentHandler(modifiedNotificationContent)
        }
    }
}

override func serviceExtensionTimeWillExpire() {
    // Called just before the extension will be terminated by the system.
    // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
    if let contentHandler = contentHandler, let bestAttemptContent =  modifiedNotificationContent {
        contentHandler(bestAttemptContent)
    }

}

}

extension NotificationService {

private func saveImageAttachment(image: UIImage, forIdentifier identifier: String
) -> URL? {
  let tempDirectory = URL(fileURLWithPath: NSTemporaryDirectory())
  let directoryPath = tempDirectory.appendingPathComponent(
    ProcessInfo.processInfo.globallyUniqueString,
    isDirectory: true)

  do {
    try FileManager.default.createDirectory(
      at: directoryPath,
      withIntermediateDirectories: true,
      attributes: nil)

    let fileURL = directoryPath.appendingPathComponent(identifier)

    guard let imageData = image.pngData() else {
      return nil
    }

    try imageData.write(to: fileURL)
      return fileURL
    } catch {
      return nil
  }
}

private func getMediaAttachment(for urlString: String, completion: @escaping (UIImage?) -> Void
) {
    // 1
    guard let url = URL(string: urlString) else {
        completion(nil)
        return
    }

    let task = URLSession.shared.dataTask(with: url) { data, response, error in
        if error != nil {
            completion(nil)
            return
        }

        guard let data = data else {
            completion(nil)
            return
        }

        guard let image = UIImage(data: data) else {
            completion(nil)
            return
        }
        completion(image)
    }
    task.resume()
}
}
```

### 7. Final Step

In the Runner Target inside Build Phases, drag the **`Embedded Foundation Extensions`** section and drop it below the **`Copy Bundle Resources`** section like in the image.

![Reordering Build Phases sections](https://mintcdn.com/suprsend/jhGzZpggWCp1KSgu/images/docs/d90e08d-Screenshot_2024-08-14_at_4.47.35_PM.png?fit=max&auto=format&n=jhGzZpggWCp1KSgu&q=85&s=a88c83a7c5e276183bc4033f1fb2d235)

You are now all set to send push notifications. All you have to do is add the iOS vendor configuration on the SuprSend dashboard and your push notifications will be configured. Please refer to the [vendor integration guide](https://docs.suprsend.com/docs/ios-push-vendor-integration) to integrate your APNs push service.
