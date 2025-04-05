import 'package:call_log/call_log.dart';

Future<List<CallLogEntry>> getCallLogs() async {
  Iterable<CallLogEntry> callLogs = await CallLog.query();
  return callLogs.toList();
}
