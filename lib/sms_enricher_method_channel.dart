import 'package:flutter/services.dart';
import 'sms_enricher_platform_interface.dart';

class MethodChannelSmsEnricher extends SmsEnricherPlatform {
  final methodChannel = const MethodChannel('sms_enricher');

  @override
  Future<bool> requestSmsPermissions() async {
    final bool permissionsGranted =
        await methodChannel.invokeMethod('requestSmsPermissions');
    return permissionsGranted;
  }

  @override
  Future<List<dynamic>> retrieveSmsMessages(
      {String targetName = "MPESA"}) async {
    final List<dynamic> messages = await methodChannel
        .invokeMethod('retrieveSmsMessages', {'targetName': targetName});
    return messages;
  }

  @override
  Future<bool> sendToBackend(List<dynamic> enrichedMessages, String endpointUrl,
      String userEmail, String organizationName) async {
    final bool success = await methodChannel.invokeMethod('sendToBackend', {
      'enrichedMessages': enrichedMessages,
      'endpointUrl': endpointUrl,
      'userEmail': userEmail,
      'organizationName': organizationName,
    });
    return success;
  }
}
