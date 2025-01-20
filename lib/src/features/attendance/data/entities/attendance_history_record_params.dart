import '../../../../core/network/api_client.dart';

class AttendanceHistoryRecordParams implements APIRouter {
  final String userId;
  final String attendanceId;

  AttendanceHistoryRecordParams({
    required this.userId,
    required this.attendanceId,
  });

  @override
  Map<String, dynamic> get body => {
        'userId': userId,
        'attendanceId': attendanceId,
      };

  @override
  Map<String, String>? get headers => {
        'Content-Type': 'application/x-www-form-urlencoded',
      };

  @override
  String get path => '/trackHistory.php';

  @override
  Map<String, String>? get queryParams => null;
}
