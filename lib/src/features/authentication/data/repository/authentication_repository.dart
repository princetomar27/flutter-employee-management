import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/storage/storage_helper.dart';
import '../datasource/authentication_datasource.dart';
import '../entities/user_login_entity.dart';
import '../entities/user_login_params.dart';

abstract class AuthenticationRepository {
  Future<Either<Failure, UserLoginEntity>> loginUser(UserLoginParams params);
}

class AuthenticationRepositoryImpl implements AuthenticationRepository {
  final AuthenticationDatasource datasource;

  AuthenticationRepositoryImpl({
    required this.datasource,
  });

  @override
  Future<Either<Failure, UserLoginEntity>> loginUser(
      UserLoginParams params) async {
    final result = await datasource.loginUser(params);
    result.fold(
      (failure) => debugPrint("Failed to login: ${failure.message}"),
      (user) async {
        final userData = jsonEncode(user.toJson());
        await StorageHelper.saveUserData(userData);
      },
    );
    return result;
  }
}
