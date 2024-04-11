import 'sms_enricher_platform_interface.dart';

class SmsEnricher {
  Future<bool> requestSmsPermissions() async {
    return SmsEnricherPlatform.instance.requestSmsPermissions();
  }

  Future<List<dynamic>> retrieveSmsMessages(
      {String targetName = "MPESA"}) async {
    return SmsEnricherPlatform.instance
        .retrieveSmsMessages(targetName: targetName);
  }

  // Assuming enrichment happens on the Flutter side for simplicity
  Future<List<dynamic>> enrichSmsMessages(List<dynamic> messages) async {
    // This will be your logic for enrichment
    return messages.map((message) {
      return {
        ...message,
        'enriched': true,
      };
    }).toList();
  }

  Future<bool> sendToBackend(List<dynamic> enrichedMessages, String endpointUrl,
      String userEmail) async {
    return SmsEnricherPlatform.instance
        .sendToBackend(enrichedMessages, endpointUrl, userEmail);
  }
}
