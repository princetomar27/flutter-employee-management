class AttendanceEntity {
  final String attendeceCode;
  final String checkIn;
  final String checkOut;
  final String duration;
  final String distance;

  AttendanceEntity({
    required this.attendeceCode,
    required this.checkIn,
    required this.checkOut,
    required this.duration,
    required this.distance,
  });

  factory AttendanceEntity.fromJson(Map<String, dynamic> json) {
    return AttendanceEntity(
      attendeceCode: json['attendeceCode'],
      checkIn: json['checkIn'],
      checkOut: json['checkOut'],
      duration: json['duration'],
      distance: json['distance'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'attendeceCode': attendeceCode,
      'checkIn': checkIn,
      'checkOut': checkOut,
      'duration': duration,
      'distance': distance,
    };
  }
}
