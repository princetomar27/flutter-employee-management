import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../datasource/attendance_datasource.dart';
import '../entities/attendance_entity.dart';
import '../entities/attendance_params.dart';

abstract class AttendanceRepository {
  Future<Either<Failure, List<AttendanceEntity>>> fetchAttendanceList(
      AttendanceParams params);
}

class AttendanceRepositoryImpl implements AttendanceRepository {
  final AttendanceDatasource attendanceDatasource;
  AttendanceRepositoryImpl({required this.attendanceDatasource});

  @override
  Future<Either<Failure, List<AttendanceEntity>>> fetchAttendanceList(
      AttendanceParams params) async {
    return attendanceDatasource.fetchAttendanceList(params);
  }
}
