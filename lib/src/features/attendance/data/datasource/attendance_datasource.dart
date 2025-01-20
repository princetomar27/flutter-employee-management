import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter/widgets.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/network/api_client.dart';
import '../entities/attendance_entity.dart';
import '../entities/attendance_history_record_entity.dart';
import '../entities/attendance_history_record_params.dart';
import '../entities/attendance_params.dart';

abstract class AttendanceDatasource {
  Future<Either<Failure, List<AttendanceEntity>>> fetchAttendanceList(
      AttendanceParams params);

  Future<Either<Failure, List<AttendanceHistoryRecordEntity>>>
      fetchAttendanceHistoryList(AttendanceHistoryRecordParams params);
}

class AttendanceDatasourceImpl implements AttendanceDatasource {
  final ApiClient apiClient;
  AttendanceDatasourceImpl({required this.apiClient});

  @override
  Future<Either<Failure, List<AttendanceEntity>>> fetchAttendanceList(
      AttendanceParams params) async {
    try {
      final response = await apiClient.postRequest(params);

      if (response.statusCode == 200) {
        final data = _parseJson(response.body);

        if (data != null && data['AttendanceList'] != null) {
          List<AttendanceEntity> attendanceList =
              List.from(data['AttendanceList'])
                  .map((attendance) => AttendanceEntity.fromJson(attendance))
                  .toList();

          return Right(attendanceList);
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
  Future<Either<Failure, List<AttendanceHistoryRecordEntity>>>
      fetchAttendanceHistoryList(AttendanceHistoryRecordParams params) async {
    try {
      final response = await apiClient.postRequest(params);

      if (response.statusCode == 200) {
        final data = _parseJson(response.body);

        if (data != null && data['attendanceHistory'] != null) {
          List<AttendanceHistoryRecordEntity> attendanceList =
              List.from(data['attendanceHistory'])
                  .map((attendance) =>
                      AttendanceHistoryRecordEntity.fromJson(attendance))
                  .toList();

          return Right(attendanceList);
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
