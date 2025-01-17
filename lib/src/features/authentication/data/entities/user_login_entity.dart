import 'package:equatable/equatable.dart';

class UserLoginEntity extends Equatable {
  final String userId;
  final String roleId;
  final String userName;
  final String empCode;
  final String profileImage;
  final String message;
  final int status;

  const UserLoginEntity({
    required this.userId,
    required this.roleId,
    required this.userName,
    required this.empCode,
    required this.profileImage,
    required this.message,
    required this.status,
  });

  @override
  List<Object?> get props => [
        userId,
        roleId,
        userName,
        empCode,
        profileImage,
        message,
        status,
      ];

  factory UserLoginEntity.fromJson(Map<String, dynamic> json) {
    final loginData = json['login'] as List?;
    final message = json['message'] ?? 'Invalid Username & Password';
    final status = json['status'] ?? 0;

    if (loginData == null || loginData.isEmpty) {
      return UserLoginEntity(
        userId: '',
        roleId: '',
        userName: '',
        empCode: '',
        profileImage: '',
        message: message,
        status: status,
      );
    }

    final login = loginData.isNotEmpty ? loginData[0] : {};

    return UserLoginEntity(
      userId: login['userId'] ?? '',
      roleId: login['roleId'] ?? '',
      userName: login['userName'] ?? '',
      empCode: login['empCode'] ?? '',
      profileImage: login['profileImage'] ?? '',
      message: message,
      status: status,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'login': [
        {
          'userId': userId,
          'roleId': roleId,
          'userName': userName,
          'empCode': empCode,
          'profileImage': profileImage,
        }
      ],
      'message': message,
      'status': status,
    };
  }
}
