import 'package:equatable/equatable.dart';

class CheckOutEntity extends Equatable {
  final String userId;
  final String checkOutDate;
  final String checkOutTime;
  final int status;

  const CheckOutEntity({
    required this.userId,
    required this.checkOutDate,
    required this.checkOutTime,
    required this.status,
  });

  @override
  List<Object?> get props => [
        userId,
        checkOutDate,
        checkOutTime,
        status,
      ];

  factory CheckOutEntity.fromJson(Map<String, dynamic> json) {
    final checkOutData = json['checkOut'];

    if (checkOutData == null || checkOutData.isEmpty) {
      throw const FormatException('Invalid or missing check-out data');
    }

    final checkOut = checkOutData.isNotEmpty ? checkOutData[0] : {};

    return CheckOutEntity(
      userId: checkOut['userId'],
      checkOutDate: checkOut['checkOutDate'],
      checkOutTime: checkOut['checkOutTime'],
      status: checkOut['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'checkOut': [
        {
          'userId': userId,
          'checkOutDate': checkOutDate,
          'checkOutTime': checkOutTime,
          'status': status,
        }
      ],
    };
  }
}
