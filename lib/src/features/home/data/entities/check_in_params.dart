import '../../../../core/network/api_client.dart';

class CheckInParams implements APIRouter {
  final String userId;
  final String latitude;
  final String longitude;
  final String locationAddress;

  CheckInParams({
    required this.userId,
    required this.latitude,
    required this.longitude,
    required this.locationAddress,
  });

  @override
  Map<String, dynamic> get body => {
        'userId': userId,
        'latitude': latitude,
        'longitude': longitude,
        'location': locationAddress,
      };

  @override
  Map<String, String>? get headers => {
        'Content-Type': 'application/x-www-form-urlencoded',
      };

  @override
  String get path => '/checkIn.php';

  @override
  Map<String, String>? get queryParams => null;

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'latitude': latitude,
      'longitude': longitude,
      'location': locationAddress,
    };
  }
}
