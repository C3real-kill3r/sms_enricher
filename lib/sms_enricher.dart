import 'sms_enricher_platform_interface.dart';
import 'package:telephony/telephony.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'services/api_calls.dart';

class SmsEnricher {
  static final SmsEnricher _instance = SmsEnricher._internal();
  final Telephony telephony = Telephony.instance;
  static late SharedPreferences _prefs;
  static bool _prefsInitialized = false;

  String endpointUrl = "";
  String userEmail = "";
  String organizationName = "";
  String userName = "";

  factory SmsEnricher() {
    return _instance;
  }

  SmsEnricher._internal();

  static Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
    _prefsInitialized = true;
    _instance.loadPreferences();
  }

  void loadPreferences() {
    try {
      endpointUrl = _prefs.getString('endpointUrl') ?? "";
      userEmail = _prefs.getString('userEmail') ?? "";
      organizationName = _prefs.getString('organizationName') ?? "";
      userName = _prefs.getString('userName') ?? "";
    } catch (e) {
      print("Failed to load preferences: $e");
    }
  }

  void savePreferences() {
    _prefs.setString('endpointUrl', endpointUrl);
    _prefs.setString('userEmail', userEmail);
    _prefs.setString('organizationName', organizationName);
    _prefs.setString('userName', userName);
  }

  void startListening() {
    telephony.listenIncomingSms(
        onNewMessage: handleNewMessage,
        onBackgroundMessage: backgroundMessageHandler);
  }

  void handleNewMessage(SmsMessage message) {
    if (message.address == "MPESA") {
      sendUpdateToBackend(message.body ?? "");
    }
  }

  static void backgroundMessageHandler(SmsMessage message) {
    if (!_prefsInitialized) {
      // Check if the _prefs has been initialized
      initialize().then((_) {
        _instance.handleNewMessage(message);
      });
    } else {
      _instance.handleNewMessage(message);
    }
  }

  Future<bool> sendUpdateToBackend(String body) async {
    try {
      if (_instance.endpointUrl.isEmpty ||
          _instance.userEmail.isEmpty ||
          _instance.organizationName.isEmpty ||
          _instance.userName.isEmpty) {
        // return false;
        _instance.loadPreferences();
      }
      if (endpointUrl.isEmpty) {
        // Check again to ensure loading was successful
        return false;
      }
      return APICalls().sendToBackend(
        [body],
        _instance.endpointUrl,
        _instance.userEmail,
        _instance.organizationName,
        _instance.userName,
      );
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

  Future<bool> requestSmsPermissions() async {
    return SmsEnricherPlatform.instance.requestSmsPermissions();
  }

  Future<List<dynamic>> retrieveSmsMessages(
      {String targetName = "MPESA"}) async {
    return SmsEnricherPlatform.instance
        .retrieveSmsMessages(targetName: targetName);
  }

  Future<List<dynamic>> enrichSmsMessages(List<dynamic> messages) async {
    return messages.toList();
  }

  Future<bool> sendToBackend(List<dynamic> enrichedMessages, String endpointUrl,
      String userEmail, String organizationName, String userName) async {
    this.endpointUrl = endpointUrl;
    this.userEmail = userEmail;
    this.organizationName = organizationName;
    this.userName = userName;
    if (endpointUrl.isEmpty ||
        userEmail.isEmpty ||
        organizationName.isEmpty ||
        userName.isEmpty) {
      return false;
    }
    _prefs.setString('endpointUrl', endpointUrl);
    _prefs.setString('userEmail', userEmail);
    _prefs.setString('organizationName', organizationName);
    _prefs.setString('userName', userName);
    savePreferences();
    startListening();
    return APICalls().sendToBackend(
        enrichedMessages, endpointUrl, userEmail, organizationName, userName);
  }
}
