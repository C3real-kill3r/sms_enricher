import 'package:flutter/material.dart';
import 'package:sms_enricher/sms_enricher.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SmsEnricher.initialize();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final SmsEnricher _smsEnricher = SmsEnricher();
  bool _permissionsGranted = false;
  List<dynamic> _enrichedMessages = [];
  String _filterText = ''; // State variable for filter text

  @override
  void initState() {
    super.initState();
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    bool permissionsGranted = await _smsEnricher.requestSmsPermissions();
    setState(() {
      _permissionsGranted = permissionsGranted;
    });

    if (_permissionsGranted) {
      _retrieveAndEnrichMessages();
    } else {
      // Handle permission denial here
      // log the error
      print('Error: SMS permission denied.');
    }
  }

  Future<void> _retrieveAndEnrichMessages() async {
    try {
      List<dynamic> messages =
          await _smsEnricher.retrieveSmsMessages(targetName: 'Test Target');
      List<dynamic> enrichedMessages =
          await _smsEnricher.enrichSmsMessages(messages);
      setState(() {
        _enrichedMessages = enrichedMessages;
      });
      _sendToBackend(enrichedMessages);
    } catch (e) {
      // Handle errors here
    }
  }

  Future<void> _sendToBackend(List<dynamic> enrichedMessages) async {
    bool success = await _smsEnricher.sendToBackend(
        enrichedMessages.take(100).toList(),
        'https://example.com',
        'john.doe@test.com',
        'Company Name',
        'John Doe');
    if (!success) {
      // Handle transmission error
      print('Error: Failed to send messages to backend.');
    }
    // Success handling
  }

  List<dynamic> _filteredMessages() {
    if (_filterText.isEmpty) {
      return _enrichedMessages;
    } else {
      return _enrichedMessages
          .where((message) => message
              .toString()
              .toLowerCase()
              .contains(_filterText.toLowerCase()))
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(),
        body: Column(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: TextField(
                decoration: const InputDecoration(
                  hintText: 'Search...',
                  icon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
                onChanged: (text) {
                  setState(() {
                    _filterText = text;
                  });
                },
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.6,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: _permissionsGranted
                      ? ListView.builder(
                          itemCount: _filteredMessages().length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.white,
                                  width: 1.0,
                                ),
                                color: const Color.fromARGB(255, 219, 244, 251),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: ListTile(
                                title: Text('Message ${index + 1}'),
                                subtitle: Text('${_filteredMessages()[index]}'),
                              ),
                            );
                          },
                        )
                      : const Text('Requesting Permissions...'),
                ),
              ),
            ),
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: () async {
                  _requestPermissions();
                },
                child: const Text('Request SMS Permissions'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
