# Android Push Setup (FCM)

Set up FCM Android push notifications in your Flutter app with SuprSend, covering Firebase config, service files, token registration, and delivery testing.

> **Tip:** An example integration project can be found in the [example](../example) folder.

## Integration Steps

### Step 1: Create a Firebase project in the Firebase console

To start sending notifications from FCM, you'll have to first create a Firebase project. Create a Firebase project and application in the [Firebase console](https://firebase.google.com/) with your application's package name, which you can find in *`AndroidManifest.xml`*.

### Step 2: Adding google-services.json to your project

You can get your Service Account JSON from Firebase Console Project Settings. Download *google-services.json* and add the file inside your *android > app* folder.

![Download google-services.json from Firebase Console](https://mintcdn.com/suprsend/jhGzZpggWCp1KSgu/images/docs/e2d76a2-Group_6.png?fit=max&auto=format&n=jhGzZpggWCp1KSgu&q=85&s=2e85e8f3794bee2bd3e1eac2ae1e0a9f)

### Step 3: Adding Firebase dependencies and plugins

**3.1.** Add the below dependency inside the project's *`build.gradle`* inside `dependencies`:

```groovy
// Groovy (build.gradle)
dependencies {
        ...
        classpath 'com.google.gms:google-services:4.3.10' // or latest version
}
```

```kotlin
// Kotlin DSL (build.gradle.kts)
plugins {
  id("com.google.gms.google-services") version "4.3.10" // or latest version
}
```

**3.2.** Add the below plugin inside the app *`build.gradle`*:

```groovy
// Groovy (build.gradle)
apply plugin: 'com.google.gms.google-services'
```

```kotlin
// Kotlin DSL (build.gradle.kts)
plugins {
  id("com.google.gms.google-services")
}
```

**3.3.** Add the below dependency inside the app's *`build.gradle`* inside `dependencies`:

```groovy
// Groovy (build.gradle)
implementation("com.google.firebase:firebase-messaging:22.0.0") // or latest version
```

```kotlin
// Kotlin DSL (build.gradle.kts)
dependencies {
 implementation("com.google.firebase:firebase-messaging:22.0.0") // or latest version
}
```

### Step 4: Implementing push

Push can be implemented in two ways:

#### Option A: Token Generation and Notification handled by SDK [Recommended]

You may use this option if all of your Android push notifications are to be handled via the SuprSend SDK. We recommend you use this method as it is just a single-step process to register the service in your application manifest, and everything else will be ready.

```xml
<!-- AndroidManifest.xml -->
<!-- If you are targeting API 33 (Android 13) you will additionally need to add POST_NOTIFICATIONS -->
<uses-permission android:name="android.permission.POST_NOTIFICATIONS" />

<service
    android:name="app.suprsend.fcm.SSFirebaseMessagingService"
    android:enabled="true"
    android:exported="false">
    <intent-filter>
        <action android:name="com.google.firebase.MESSAGING_EVENT" />
    </intent-filter>
</service>
```

#### Option B: Token Generation and Notification handled by Your Application

Once you get a token from Firebase you can pass the token by using the below code:

```dart
// main.dart
suprsend.setAndroidFcmPush(fcm_token);
```

When you get a push notification you will get a payload, and it can be passed to the method provided by the SuprSend Flutter SDK; the notification displaying part will be handled by the SDK.

```dart
// main.dart
suprsend.showNotification(notification_payload);
```

> **How to identify if a notification is sent by SuprSend?**
>
> If the notification payload contains the key **`supr_send_n_pl`**, then simply consider this as a payload sent from SuprSend and pass the payload to the SuprSend SDK.

## Targeting Android 13 (API-33)

In Android 13 (API 33) or higher, [notification permission](https://developer.android.com/develop/ui/views/notifications/notification-permission) will be disabled by default, so permission needs to be asked to enable notifications if you are targeting Android 13 users. You can follow [this doc](https://developer.android.com/about/versions/13/setup-sdk) to update to support Android 13 (API 33), if not already supported. Please test the application as well, as upgrading to API 33 may cause breaking changes.

### 1. Add POST_NOTIFICATIONS permission in AndroidManifest.xml if not present already

```xml
<!-- AndroidManifest.xml -->
<manifest ...>
    <uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
    <application ...>
        ...
    </application>
</manifest>
```

### 2. Ask notification permission to show push notifications

You can use [permission_handler](https://pub.dev/packages/permission_handler) or any other package to ask the user for notification permission.

> **Info:** From v2.4.0, we have removed the internal method to ask notification permission (`suprsend.askNotificationPermission`). You can use an external package to ask for notification permission.

Once notification permission is granted, users will be able to see push notifications.
