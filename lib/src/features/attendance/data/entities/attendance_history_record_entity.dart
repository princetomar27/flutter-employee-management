class AttendanceHistoryRecordEntity {
  final String employeeIdTrackingId;
  final String employeeIdFk;
  final String clientIdFk;
  final String attendanceId;
  final String locationLatitude;
  final String locationLongitude;
  final String locationArea;
  final String trackingComment;
  final int dataEntryDate;
  final String status;

  AttendanceHistoryRecordEntity({
    required this.employeeIdTrackingId,
    required this.employeeIdFk,
    required this.clientIdFk,
    required this.attendanceId,
    required this.locationLatitude,
    required this.locationLongitude,
    required this.locationArea,
    required this.trackingComment,
    required this.dataEntryDate,
    required this.status,
  });

  factory AttendanceHistoryRecordEntity.fromJson(Map<String, dynamic> json) {
    return AttendanceHistoryRecordEntity(
      employeeIdTrackingId: json['employeeIdTrckingId'],
      employeeIdFk: json['employeeId_fk'],
      clientIdFk: json['clientId_fk'],
      attendanceId: json['attendanceId'],
      locationLatitude: json['locationLatitude'],
      locationLongitude: json['locationLongitude'],
      locationArea: json['locationArea'],
      trackingComment: json['trackingComment'],
      dataEntryDate: int.parse(json['dataEntryDate']),
      status: json['status'],
    );
  }
}
