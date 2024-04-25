import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'sms_enricher_method_channel.dart';

abstract class SmsEnricherPlatform extends PlatformInterface {
  SmsEnricherPlatform() : super(token: _token);

  static final Object _token = Object();
  static SmsEnricherPlatform _instance = MethodChannelSmsEnricher();

  static SmsEnricherPlatform get instance => _instance;

  static set instance(SmsEnricherPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<bool> requestSmsPermissions();
  Future<List<dynamic>> retrieveSmsMessages({String targetName});
  Future<bool> sendToBackend(List<dynamic> enrichedMessages, String endpointUrl,
      String userEmail, String organizationName);
}
