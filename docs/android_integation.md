# Android Integration

Configure the Android side of your Flutter app for SuprSend, covering Gradle setup, FCM credentials, manifest changes, and push notification handling.

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

> **Troubleshooting notes**
>
> In case you face compilation errors or warnings, please perform the following troubleshooting steps:
>
> - Ensure `mavenCentral` is present under `repositories` in the project's `build.gradle`.
> - Perform a Gradle sync.

## Initialization

### 1. Initialize the SuprSend Flutter SDK

To integrate SuprSend in your Android app, you will need to initialize the SuprSend Flutter SDK in your `MainApplication` class.

> **Note:** `SSApi.init` should only be called in the Application class, not inside the Activity class (`MainActivity.kt`). If your project does not have an Application class, create it manually and register it in the `AndroidManifest`.

Example: If you create a new Application class named [MainApplication.kt](https://github.com/suprsend/suprsend-flutter-sdk/blob/main/example/android/app/src/main/kotlin/com/suprsend/suprsend_flutter_sdk_example/SuprsendFlutterPluginTestApplication.kt) in your source package, go to your `AndroidManifest` file and enter the path of the class in the `<application>` tag like this:

```xml
<!-- AndroidManifest.xml -->
<application
   ...
   android:name=".MainApplication"
   ...
   >
```

```kotlin
// MainApplication.kt
package <your-package-name>

import android.app.Application
import app.suprsend.SSApi; // import sdk

class MainApplication : Application(){

  override fun onCreate() {

   SSApi.init(this, WORKSPACE KEY, WORKSPACE SECRET) // Important! without this, SDK will not work
   SSApi.initXiaomi(this, xiaomi_app_id, xiaomi_api_key) // Optional. Add this if you want to support Xiaomi notifications framework

   super.onCreate()
  }
}
```

Replace **`WORKSPACE KEY`** and **`WORKSPACE SECRET`** with values linked to your account. You'll find them on the SuprSend dashboard (**Developers -> API Keys**) page.

### 2. Import the SuprSend SDK in your client-side code

Import the SuprSend SDK in your Dart file. Go back to the flutter folder and follow the steps below:

```dart
// Main.dart
import 'package:suprsend_flutter_sdk/suprsend.dart';
```

## Logging

By default the logs of the SuprSend SDK are disabled. We recommend you enable the SDK logs by setting its value to `VERBOSE`. You can enable the logs just in debug mode while in development by the below condition.

```dart
suprsend.setLogLevel(level);

suprsend.setLogLevel(LogLevels.VERBOSE);
suprsend.setLogLevel(LogLevels.DEBUG);
suprsend.setLogLevel(LogLevels.INFO);
suprsend.setLogLevel(LogLevels.ERROR);
suprsend.setLogLevel(LogLevels.OFF);
```
