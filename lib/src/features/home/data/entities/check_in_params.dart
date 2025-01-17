import '../../../../core/network/api_client.dart';

class CheckInParams implements APIRouter {
  final String userId;
  final String latitude;
  final String longitude;
  final String location;

  CheckInParams({
    required this.userId,
    required this.latitude,
    required this.longitude,
    required this.location,
  });

  @override
  Map<String, dynamic> get body => {
        'userId': userId,
        'latitude': latitude,
        'longitude': longitude,
        'location': location,
      };

  @override
  Map<String, String>? get headers => {
        'Content-Type': 'application/x-www-form-urlencoded',
      };

  @override
  String get path => '/checkIn.php';

  @override
  Map<String, String>? get queryParams => null;
}
