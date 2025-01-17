import '../../../../core/network/api_client.dart';

class AttendanceParams implements APIRouter {
  final String userId;

  AttendanceParams({
    required this.userId,
  });

  @override
  Map<String, dynamic> get body => {
        'userId': userId,
      };

  @override
  Map<String, String>? get headers => {
        'Content-Type': 'application/x-www-form-urlencoded',
      };

  @override
  String get path => '/empAttendanceList.php';

  @override
  Map<String, String>? get queryParams => null;
}
