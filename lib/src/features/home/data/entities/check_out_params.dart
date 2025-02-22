import '../../../../core/network/api_client.dart';

class CheckOutParams implements APIRouter {
  final String userId;
  final String checkInId;
  final String latitude;
  final String longitude;
  final String location;
  final double distance;

  CheckOutParams({
    required this.userId,
    required this.checkInId,
    required this.latitude,
    required this.longitude,
    required this.location,
    required this.distance,
  });

  @override
  get body => {
        'userId': userId,
        'checkInId': checkInId,
        'latitude': latitude,
        'longitude': longitude,
        'location': location,
        'distance': distance.toString()
      };

  @override
  Map<String, String>? get headers => {
        'Content-Type': 'application/x-www-form-urlencoded',
      };

  @override
  String get path => '/checkOut.php';

  @override
  Map<String, String>? get queryParams => null;

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'checkInId': checkInId,
      'latitude': latitude,
      'longitude': longitude,
      'location': location,
      'distance': distance,
    };
  }
}
