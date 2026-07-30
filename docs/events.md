# Sync Events

Send custom events from your Flutter app to SuprSend to trigger workflows, track activity, and personalize notifications with event properties and payloads.

## Pre-Requisites

[Create User](manage_users.md) - Mandatory to pass in event trigger.

## Sending events to SuprSend

You can set up events on user actions in your app and configure workflows on top of them that trigger when the corresponding event is passed through the app. Variables added in the template or workflow should be passed as event `properties`.

You can send events from your app to the SuprSend platform by using the `suprsend.track()` method.

```dart
suprsend.track(event_name, property_obj);
suprsend.track("clicked", {"page":"Dashboard","city":"Bangalore"});
```

> Event Name or Property Name should not start with **`$`** or **`ss_`**. These keywords are reserved for internal events and property names.

### System events tracked by SuprSend

There are some system events tracked by the SuprSend SDK by default. These are some basic events, as well as events that are necessary for tracking notification-related activity (like delivered, clicked, etc). You are not required to do anything here.

| Event Name                | Description                                                                                                                                                                                                                                                                                                                                     |
| ------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `$app_installed`          | `$app_installed` gets tracked when a user launches the app for the first time. Cases in which it will also get called: 1. When the user launches the app for the first time. 2. When the user uninstalls the app and installs it again. 3. [Multiple device login] When the user launches the app for the first time on different devices. 4. When the user clears the app cache and relaunches the app. |
| `$app_launched`           | Gets tracked each time the user launches the app.                                                                                                                                                                                                                                                                                               |
| `$user_login`             | Gets tracked when the user logs in to the app.                                                                                                                                                                                                                                                                                                  |
| `$user_logout`            | Gets tracked when the user logs out of the app.                                                                                                                                                                                                                                                                                                 |
| `$notification_delivered` | Gets tracked when the SuprSend notification payload is received at the SDK end.                                                                                                                                                                                                                                                                 |
| `$notification_clicked`   | Gets tracked when the user either clicks the notification body or any action button in the notification.                                                                                                                                                                                                                                        |
| `$notification_dismissed` | Gets tracked when the user dismisses the notification by left-swiping it or by clicking the "Clear All" button.                                                                                                                                                                                                                                 |

## Advanced Concepts

### 1. Super Properties

Super Properties are data that are always sent with event data. These super properties will be sent in each event after calling this method. Super Properties will be stored in local storage, and will persist across invocations of the app.

#### Set Super Property

There are some super properties that the SuprSend SDK will send by default. Developers can set custom super properties as well with the `suprsend.setSuperProperties()` method.

```dart
suprsend.setSuperProperties(property_obj);

// setting single super property
suprsend.setSuperProperties({"Location": "San Francisco, CA"});

// setting multiple super properties
suprsend.setSuperProperties({"Location": "San Francisco, CA","Zipcode": 940167});
```

Default Super Properties tracked by the SuprSend SDK:

| Super Property         | Description                                  | Sample Value     |
| ---------------------- | -------------------------------------------- | ---------------- |
| `$app_version_string`  | Version of your app                          | 0.0.1            |
| `$app_build_number`    | Build number of your app                     | 2                |
| `$os`                  | Operating system of the user                 | android          |
| `$manufacturer`        | Manufacturer of the user's device            | OnePlus          |
| `$brand`               | Brand of the user's device                   | OnePlus          |
| `$model`               | Model of the user's device                   | GM1901           |
| `$deviceId`            | Device id                                    | 89eead05a0150146 |
| `$ss_sdk_version`      | SuprSend SDK version                         | 0.1.31           |
| `$network`             | Network on which the user is                 | wifi             |
| `$connected`           | Whether the user is connected to the network | true             |

#### Unset Super Property

You can unset custom super properties with the `suprsend.unSetSuperProperty()` method. This method will stop calling that property with every event trigger.

```dart
suprsend.unSetSuperProperty(key);

// unsetting single super property
suprsend.unSetSuperProperty({"Location"});

// unsetting multiple super properties
suprsend.unSetSuperProperty({"Location","Pincode"});
```

### 2. Flush events

The SuprSend SDK automatically flushes events at an interval of 5 seconds, and on certain activities like app relaunch, etc. If you wish to flush a time-sensitive event to SuprSend immediately, you can use the `suprsend.flush()` method.

All the system-tracked events are flushed immediately.

```dart
suprsend.flush();
```
