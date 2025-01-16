import 'dart:convert';

class LocationEntity {
  final double latitude;
  final double longitude;
  final String address;

  const LocationEntity({
    required this.latitude,
    required this.longitude,
    required this.address,
  });

  Map<String, dynamic> toMap() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
    };
  }

  String toJson() => json.encode(toMap());

  factory LocationEntity.fromMap(Map<String, dynamic> map) {
    return LocationEntity(
      latitude: map['latitude'],
      longitude: map['longitude'],
      address: map['address'],
    );
  }

  factory LocationEntity.fromJson(String source) =>
      LocationEntity.fromMap(json.decode(source));
}
