import '../../../../core/network/api_client.dart';

class LocationTrackEntity {
  final String userId;
  final int status;

  const LocationTrackEntity({
    required this.userId,
    required this.status,
  });

  factory LocationTrackEntity.fromJson(Map<String, dynamic> json) {
    final locationTrackList = json['locationTrack'];
    if (locationTrackList == null || locationTrackList.isEmpty) {
      throw const FormatException('Invalid or missing location data');
    }

    final locationData = locationTrackList.first;

    return LocationTrackEntity(
      userId: locationData['userId'],
      status: locationData['status'],
    );
  }
}

class LocationTrackParams implements APIRouter {
  final String userId;
  final String checkInId;
  final String latitude;
  final String longitude;
  final String locationAddress;

  LocationTrackParams({
    required this.userId,
    required this.checkInId,
    required this.latitude,
    required this.longitude,
    required this.locationAddress,
  });

  @override
  Map<String, dynamic> get body => {
        'userId': userId,
        'checkInId': checkInId,
        'latitude': latitude,
        'longitude': longitude,
        'location': locationAddress,
      };

  @override
  Map<String, String>? get headers => {
        'Content-Type': 'application/x-www-form-urlencoded',
      };

  @override
  String get path => '/locationTrack.php';

  @override
  Map<String, String>? get queryParams => null;

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'checkInId': checkInId,
      'latitude': latitude,
      'longitude': longitude,
      'location': locationAddress,
    };
  }
}
