import 'package:call_log/call_log.dart';
import 'package:call_organizer/call_logs/call_log.dart';
import 'package:call_organizer/call_logs/dto/call_log_dto.dart';
import 'package:call_organizer/contacts/contact_handler.dart';
import 'package:call_organizer/permissions/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Call Logs',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontFamily: 'Roboto', fontSize: 16),
          bodyMedium: TextStyle(fontFamily: 'Roboto', fontSize: 14),
          titleLarge: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: const MyHomePage(title: 'Flutter Call Log Viewer'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<CallLogDTO> _callLogDTOs = [];

  @override
  void initState() {
    super.initState();
    _checkPermissionAndPrintCallLogs();
  }

  Future<void> _checkPermissionAndPrintCallLogs() async {
    bool isAllPermissionAllowed = await checkAndRequestPermissions(context);
    if (isAllPermissionAllowed) {
      List<CallLogEntry> callLogs = await getCallLogs();
      List<CallLogDTO> callLogDTOs =
          callLogs.map((call) => CallLogDTO.fromCallLogEntry(call)).toList();
      List<Contact> contacts = await getContacts();
      contacts.forEach((c) async {
        print("Name: ${c.displayName}");
      });
      await insertContact();
      setState(() {
        _callLogDTOs = callLogDTOs; // Update the list of DTOs
      });
    }
  }

  String _formatTimestamp(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return '${date.hour}:${date.minute} - ${date.day}/${date.month}/${date.year}';
  }

  Icon _getCallTypeIcon(CallType callType) {
    switch (callType) {
      case CallType.incoming:
        return const Icon(Icons.call_received, color: Colors.green);
      case CallType.outgoing:
        return const Icon(Icons.call_made, color: Colors.blue);
      case CallType.missed:
        return const Icon(Icons.call_missed, color: Colors.red);
      case CallType.voiceMail:
        return const Icon(Icons.voicemail, color: Colors.purple);
      case CallType.rejected:
        return const Icon(Icons.call_end, color: Colors.orange);
      case CallType.blocked:
        return const Icon(Icons.block, color: Colors.grey);
      case CallType.answeredExternally:
        return const Icon(Icons.phone_forwarded, color: Colors.cyan);
      case CallType.unknown:
      default:
        return const Icon(Icons.help, color: Colors.black);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (_callLogDTOs.isEmpty)
              const CircularProgressIndicator() // Show a loading indicator until data is available
            else
              Expanded(
                child: ListView.builder(
                  itemCount: _callLogDTOs.length,
                  itemBuilder: (context, index) {
                    final CallLogDTO call = _callLogDTOs[index];
                    return Card(
                      elevation: 5,
                      margin: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: <Widget>[
                            _getCallTypeIcon(call.callType),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    call.name ?? 'Unknown',
                                    style:
                                        Theme.of(context).textTheme.titleLarge,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    call.number ?? 'Unknown',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(color: Colors.grey),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    _formatTimestamp(call.timestamp ?? 0),
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            ),
                            const Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
