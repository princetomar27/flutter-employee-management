import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter/widgets.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/storage/storage_helper.dart';
import '../entities/check_in_entity.dart';
import '../entities/check_in_params.dart';
import '../entities/check_out_entity.dart';
import '../entities/check_out_params.dart';
import '../entities/location_entity.dart';

abstract class HomeDatasource {
  Future<Either<Failure, LocationEntity>> getCurrentLocation();

  Future<Either<Failure, CheckInEntity>> checkInUser(CheckInParams params);

  Future<Either<Failure, CheckOutEntity>> checkOutUser(CheckOutParams params);
}

class HomeDatasourceImpl implements HomeDatasource {
  final ApiClient apiClient;
  HomeDatasourceImpl({required this.apiClient});

  @override
  Future<Either<Failure, LocationEntity>> getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return const Left(
              PermissionFailure(message: 'Location permission denied'));
        }
      }

      Position position = await Geolocator.getCurrentPosition();

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      String address = placemarks.isNotEmpty
          ? '${placemarks.first.street}, ${placemarks.first.locality}, ${placemarks.first.country}'
          : 'Address not available';

      final location = LocationEntity(
        latitude: position.latitude,
        longitude: position.longitude,
        address: address,
      );

      await StorageHelper.saveUserLocationDataToLocal(location);

      return Right(location);
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to fetch location: $e'));
    }
  }

  @override
  Future<Either<Failure, CheckInEntity>> checkInUser(
      CheckInParams params) async {
    try {
      final response = await apiClient.postRequest(params);

      debugPrint("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final data = _parseJson(response.body);

        if (data != null) {
          return Right(CheckInEntity.fromJson(data));
        } else {
          return Left(UserNotExistFailure(
              message: data?['message'] ?? 'Unknown error'));
        }
      } else {
        return Left(ServerFailure(
            message:
                'Check-In failed with status code: ${response.statusCode}'));
      }
    } catch (e) {
      debugPrint("Error: $e");
      return Left(ServerFailure(message: 'Check-In request failed: $e'));
    }
  }

  Map<String, dynamic>? _parseJson(String responseBody) {
    try {
      return jsonDecode(responseBody);
    } catch (e) {
      debugPrint("Failed to parse response body as JSON: $e");
      return null;
    }
  }

  @override
  Future<Either<Failure, CheckOutEntity>> checkOutUser(
      CheckOutParams params) async {
    try {
      final response = await apiClient.postRequest(params);

      debugPrint("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final data = _parseJson(response.body);

        if (data != null) {
          return Right(CheckOutEntity.fromJson(data));
        } else {
          return Left(UserNotExistFailure(
              message: data?['message'] ?? 'Unknown error'));
        }
      } else {
        return Left(ServerFailure(
            message:
                'Check-In failed with status code: ${response.statusCode}'));
      }
    } catch (e) {
      debugPrint("Error: $e");
      return Left(ServerFailure(message: 'Check-In request failed: $e'));
    }
  }
}
