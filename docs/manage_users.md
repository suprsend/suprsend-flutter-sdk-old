# Manage Users

Create, identify, update, and reset users from your Flutter app using SuprSend SDK methods to manage profiles, channels, and subscriber properties.

## How SuprSend identifies a user

SuprSend identifies users with an immutable `distinct_id`. It's best to map the same identifier in your DB with `distinct_id` in SuprSend. Do not use identifiers that can be changed like email or phone number. You can view synced users by searching `distinct_id` on the [Users page](https://app.suprsend.com/en/production/users).

## Identify user and set Push token

### 1. Create / Identify a new user

You can identify a user via the `suprsend.identify()` method. Call this method as soon as you know the identity of the user, that is after login authentication. If you don't call this method, the user will be identified using the `distinct_id` (uuid) that the SDK generates internally.

When you call this method, we internally create an event called **`$user_login`**. You can use this event to trigger a workflow on user login.

```dart
suprsend.identify(_distinct_id_);

// Sample
suprsend.identify("291eaa13-62f5-4d52-b2dd");
suprsend.identify(10005);
```

| Parameter        | Type                      | Description                                                                          |
| ---------------- | ------------------------- | ----------------------------------------------------------------------------------- |
| **distinct_id**  | int, bigint, string, UUID | *mandatory* Unique identifier for a user across devices or between multiple logins.  |

### 2. Call reset to clear user data on log out

As soon as the user logs out, call the `suprsend.reset()` method to clear data attributed to a user. This allows you to handle multiple user logins on a single device and keep their data isolated from each other.

When you call this method, we internally create an event called **`$user_logout`**. You can see this event on the SuprSend workflows event list and you can configure a workflow on it.

```dart
suprsend.reset();
```

> **Mandatory to call reset on logout:**
>
> Don't forget to call reset on user logout. If not called, the user's `distinct_id` will not reset and multiple tokens and channels will get added to the `distinct_id` who logged in first on the device.

## Set communication channels

Mobile Push tokens automatically get updated in the user profile on the `suprsend.identify()` call. All you have to do is integrate the [push notification](/docs/flutter-androidpush-integration) service in your application to start sending mobile push notifications. To set other communication channels, use the methods below.

### Add User Channels

Add user channels on signup, or whenever a user updates their communication channels in the application flow.

```dart
suprsend.user.setEmail("abc@example.com");  // To add Email

suprsend.user.setSms("+91XXXXXXXXXX");  // To add SMS, mandatory to pass country code

suprsend.user.setWhatsApp("+91XXXXXXXXXX"); // To add Whatsapp, mandatory to pass country code
```

Android Push token will automatically be set at the time of user login. All you have to do is integrate the push notification service in your application. Here's the [Android Push Integration guide](https://docs.suprsend.com/docs/flutter-androidpush-integration).

> **Country Code Mandatory:**
>
> Make sure you are sending the country code when you are calling communication methods for SMS and Whatsapp.

### Remove User Channels

```dart
suprsend.user.unSetEmail("abc@example.com");  // To remove Email

suprsend.user.unSetSms("+91XXXXXXXXXX");  // To remove SMS, mandatory to pass country code

suprsend.user.unSetWhatsApp("+91XXXXXXXXXX"); // To remove Whatsapp, mandatory to pass country code
```

## Set user properties

You can sync other user properties in SuprSend and use them to pass dynamic content in a template or add in workflow conditions.

### Set

Set is used to add a property. Set is an upsert function and will override existing values corresponding to a key.

```dart
suprsend.user.set(property_obj);

// Example for setting single property
suprsend.user.set({"prime_member_group" : "super"});

// Example for setting multiple properties
suprsend.user.set({"prime_member_group" : "super"},{"name" : "john doe"});
```

> Property key can't start with **`$`** or **`ss_`**, as this is reserved for our internal events and property names.

| Parameters     | Type   | Description                                                                                        |
| -------------- | ------ | ------------------------------------------------------------------------------------------------- |
| key            | string | *Mandatory.* This is the property key that will be attached to the user. Should not start with `$` or `ss_`. |
| value          | any    | *Optional.* This will be the value that will be attached to the key property.                      |
| **JSONObject** | object | *Optional.* This is used in case of setting multiple user properties.                              |

### Unset

This will delete the property key.

```dart
suprsend.user.unSet(property_list);

suprsend.user.unSet(["wishlist"]);
suprsend.user.unSet(["wishlist", "cart"]);
```

### Append

This method will append a value to an array.

```dart
Suprsend.user.append(key, value);
Suprsend.user.append(propertyObj);  // for multiple properties

// Sample values for appending a single property:
Suprsend.user.append("wishlist", "iphone12");

// Sample values for appending multiple properties:
Suprsend.user.append({
  "wishlist": ["iphone12", "Apple airpods"]
});
```

### Remove

Removes the property value but doesn't unset the property key. If you want to remove the property key, use the unset method.

```dart
// remove single property
suprsend.user.remove(key, value);
suprsend.user.remove("wishlist", "iphone12");

// remove multiple properties
suprsend.user.remove(property_obj);
suprsend.user.remove({"wishlist" : "iphone12", "wishlist": "Apple airpods"});
```

### Set Once

Works just like `user.set`, except it will not overwrite existing property values. This is useful for properties like *First login date*.

```dart
import 'package:suprsend_flutter/suprsend_flutter.dart';

void main() {
  // Initialize SuprSend instance
  final Suprsend suprsend = Suprsend();

  // Set a single property once
  suprsend.user.setOnce("first_login", "2021-11-02");

  // Set multiple properties once
  suprsend.user.setOnce({
    "first_login": "2021-11-02",
    "DOB": "1991-10-02",
  });
}
```

### Increment

Increase or decrease integer values on consecutive actions, like login count. To reduce a property, provide a negative number for the value.

```dart
// For single property
Suprsend.user.increment(key, value);
Suprsend.user.increment("login_count", 1);

// For multiple properties
Suprsend.user.increment(propertyObj);
Suprsend.user.increment({
  "login_count": 1,
  "order_count": 1
});
```
