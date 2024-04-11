# SMS Enricher Flutter Plugin

The SMS Enricher Flutter Plugin is a comprehensive solution for accessing and processing SMS messages on Android devices. It allows Flutter apps to request user permissions for SMS access, retrieve SMS messages based on specific filters, enrich SMS data on the device, and securely send the processed data to a designated backend server.

## Features

- **User Permissions:** Request user consent to access SMS messages.
- **Data Retrieval:** Retrieve SMS messages filtered by sender or content.
- **Data Enrichment:** Perform on-device data enrichment, such as sentiment analysis and named entity recognition.
- **Secure Transmission:** Securely send enriched data to a backend endpoint via HTTPS.

## Getting Started

To use the SMS Enricher plugin in your Flutter app, follow these steps:

### Installation

1. Add `sms_enricher` to your `pubspec.yaml` under the dependencies section:

```yaml
dependencies:
  flutter:
    sdk: flutter
  sms_enricher: ^1.0.0
```

2. Run `flutter pub get` to install the plugin.

```bash
flutter pub get
```

### Usage

1. Import the `sms_enricher` package in your Dart code:

```dart
import 'package:sms_enricher/sms_enricher.dart';
```

2. Request SMS permissions from the user:

```dart
bool isPermissionGranted = await SmsEnricher.requestSmsPermission();
```

3. Retrieve and enrich SMS messages:

```dart
List<dynamic> messages = await SmsEnricher.retrieveSmsMessages(targetName: 'Bank');
List<dynamic> enrichedMessages = await SmsEnricher.enrichSmsMessages(messages);
```

4. Send the enriched data to a backend server:

```dart
bool success = await SmsEnricher.sendToBackend(enrichedMessages, 'https://yourbackend.endpoint/api/messages');
if (!success) {
  // Handle transmission error
}
```

### Security

Ensure your app complies with the latest privacy regulations. Always request user consent before accessing SMS messages and securely handle the data.

### License

This plugin is released under the MIT License. See the [LICENSE](https://github.com/git/git-scm.com/blob/main/MIT-LICENSE.txt) file for more details.
