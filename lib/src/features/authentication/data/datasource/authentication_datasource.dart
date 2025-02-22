import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter/widgets.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/network/api_client.dart';
import '../entities/user_login_entity.dart';
import '../entities/user_login_params.dart';

abstract class AuthenticationDatasource {
  Future<Either<Failure, UserLoginEntity>> loginUser(UserLoginParams params);
}

class AuthenticationDatasourceImpl implements AuthenticationDatasource {
  final ApiClient apiClient;

  AuthenticationDatasourceImpl({required this.apiClient});

  @override
  Future<Either<Failure, UserLoginEntity>> loginUser(
      UserLoginParams params) async {
    try {
      final response = await apiClient.postRequest(params);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 1) {
          return right(UserLoginEntity.fromJson(data));
        } else {
          return left(UserNotExistFailure(message: data['message']));
        }
      } else {
        return Left(ServerFailure(
            message: 'Login failed with status code: ${response.statusCode}'));
      }
    } catch (e) {
      debugPrint("Error: $e");
      return Left(ServerFailure(message: 'Login request failed: $e'));
    }
  }
}
