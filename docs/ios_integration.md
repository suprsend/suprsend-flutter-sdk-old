# iOS Integration

Configure the iOS side of your Flutter app for SuprSend, covering Xcode setup, APNs certificates, capabilities, and push notification entitlements.

## Installation

### 1. Open your Flutter project's `pubspec.yaml` file

Add the following line of code inside `dependencies` in the `pubspec.yaml` file:

```yaml
# pubspec.yaml
dependencies:
  flutter:
    sdk: flutter
  suprsend_flutter_sdk: "^2.4.0"
```

### 2. Run `flutter pub get` in the terminal

```shell
flutter pub get
```

### 3. Changes in Podfile and run pod

The SuprSend SDK can be installed on iOS platform version >= 13. Check the version in the `Podfile` and upgrade it by running **`pod install`** inside the iOS folder.

```ruby
# Podfile
platform :ios, '13.0' # this version has to be >= 13
```

### 4. Change iOS Deployment Target

The SuprSend SDK needs an iOS deployment target >= 11. Open your project in Xcode (*project > ios > project.xcworkspace*) and update the target.

![iOS Deployment Target setting in Xcode](https://mintcdn.com/suprsend/3ix_OjxB_ZGM-pa-/images/docs/18650ad-Screenshot_2022-07-27_at_12.36.03_PM.png?fit=max&auto=format&n=3ix_OjxB_ZGM-pa-&q=85&s=4dd9f96245ceb0f9a11881fdd90cc925)

## Initialization

Import the SuprSend iOS SDK into your application. In `AppDelegate`, add the below code inside the `didFinishLaunchingWithOptions` method, just before returning.

```swift
// AppDelegate.swift
import UIKit
import Flutter
import SuprSendSdk // Add this

...

override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
  GeneratedPluginRegistrant.register(with: self)

    // Add below 2 lines
    let suprSendConfiguration = SuprSendSDKConfiguration(withKey: "your workspace key", secret:"your workspace secret", baseUrl:nil)
    SuprSend.shared.configureWith(configuration: suprSendConfiguration  , launchOptions: launchOptions)

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
}
```

Replace **`WORKSPACE KEY`** and **`WORKSPACE SECRET`** with values linked to your account. You'll find this on the SuprSend dashboard (**Developers -> API Keys**) page.

## Logging

By default the logs of the SuprSend SDK are disabled. We recommend you enable the SDK logs by setting its value to `VERBOSE`. You can enable the logs just in debug mode while in development by the below condition.

```javascript
suprsend.setLogLevel(level) // level is optional for iOS

suprsend.setLogLevel("VERBOSE")
suprsend.setLogLevel("DEBUG")
suprsend.setLogLevel("INFO")
suprsend.setLogLevel("ERROR")
suprsend.setLogLevel("OFF")
```
