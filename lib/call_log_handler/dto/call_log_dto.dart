import 'package:call_log/call_log.dart';

class CallLogDTO {
  final String? name;
  final String? number;
  final String? simDisplayName;
  final String? cachedMatchedNumber;
  final String? cachedNumberLabel;
  final CallType? callType;
  final int? duration;
  final int? cachedNumberType;
  final String? formattedNumber;
  final String? phoneAccountId;
  final int? timestamp;

  CallLogDTO.fromCallLogEntry(CallLogEntry call)
    : name = call.name,
      number = call.number,
      simDisplayName = call.simDisplayName,
      cachedMatchedNumber = call.cachedMatchedNumber,
      cachedNumberLabel = call.cachedNumberLabel,
      callType = call.callType,
      duration = call.duration,
      cachedNumberType = call.cachedNumberType,
      formattedNumber = call.formattedNumber,
      phoneAccountId = call.phoneAccountId,
      timestamp = call.timestamp;

  @override
  String toString() {
    return '''
    Name: $name
    Number: $number
    SIM Display Name: $simDisplayName
    Cached Matched Number: $cachedMatchedNumber
    Cached Number Label: $cachedNumberLabel
    Call Type: $callType
    Duration: $duration
    Cached Number Type: $cachedNumberType
    Formatted Number: $formattedNumber
    Phone Account ID: $phoneAccountId 
    Timestamp: $timestamp
    ''';
  }
}
