import 'package:equatable/equatable.dart';

class CheckInEntity extends Equatable {
  final String userId;
  final String checkInId;
  final String checkInDate;
  final String checkInTime;
  final int status;

  const CheckInEntity({
    required this.userId,
    required this.checkInId,
    required this.checkInDate,
    required this.checkInTime,
    required this.status,
  });

  @override
  List<Object?> get props => [
        userId,
        checkInId,
        checkInDate,
        checkInTime,
        status,
      ];

  factory CheckInEntity.fromJson(Map<String, dynamic> json) {
    final checkInList = json['checkIn'];
    if (checkInList == null || checkInList.isEmpty) {
      throw const FormatException('Invalid or missing check-in data');
    }

    final checkIn = checkInList.first;
    return CheckInEntity(
      userId: checkIn['userId'],
      checkInId: checkIn['checkInId'],
      checkInDate: checkIn['checkInDate'],
      checkInTime: checkIn['checkInTime'],
      status: checkIn['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'checkIn': [
        {
          'userId': userId,
          'checkInId': checkInId,
          'checkInDate': checkInDate,
          'checkInTime': checkInTime,
          'status': status,
        }
      ],
    };
  }
}
