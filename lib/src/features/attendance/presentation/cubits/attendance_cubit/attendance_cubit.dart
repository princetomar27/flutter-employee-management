import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../../core/errors/failures.dart';
import '../../../../../core/storage/storage_helper.dart';
import '../../../../authentication/data/entities/user_login_entity.dart';
import '../../../data/entities/attendance_entity.dart';
import '../../../data/entities/attendance_params.dart';
import '../../../data/repository/attendance_repository.dart';

part 'attendance_state.dart';

class AttendanceCubit extends Cubit<AttendanceState> {
  final AttendanceRepository attendanceRepository;

  AttendanceCubit({required this.attendanceRepository})
      : super(
          const AttendanceState(
            attendanceList: null,
          ),
        ) {
    fetchAttendanceList();
  }

  Future<void> fetchAttendanceList() async {
    emit(AttendanceLoading(attendanceList: []));
    final userData = await StorageHelper.getUserData();
    if (userData != null) {
      final user = UserLoginEntity.fromJson(jsonDecode(userData));
      final AttendanceParams attendanceParams = AttendanceParams(
        userId: user.userId,
      );

      final result =
          await attendanceRepository.fetchAttendanceList(attendanceParams);

      result.fold(
        (failure) => emit(
          AttendanceFailure(
            failure: failure,
            attendanceList: [],
          ),
        ),
        (attendanceList) {
          final months = [
            'January',
            'February',
            'March',
            'April',
            'May',
            'June',
            'July',
            'August',
            'September',
            'October',
            'November',
            'December',
          ];
          emit(
            AttendanceLoaded(
              attendanceList: attendanceList,
              employeeAttendanceList: attendanceList,
              months: months,
              selectedMonthIndex: null,
            ),
          );
        },
      );
    }
  }

  void filterAttendanceByMonth(int month) {
    if (state is AttendanceLoaded) {
      final loadedState = state as AttendanceLoaded;
      final filteredAttendance =
          loadedState.attendanceList?.where((attendance) {
        try {
          final checkInDate =
              DateFormat('dd-MM-yyyy HH:mm').parse(attendance.checkIn);
          return checkInDate.month == month;
        } catch (e) {
          return false;
        }
      }).toList();

      emit(
        AttendanceLoaded(
          employeeAttendanceList: filteredAttendance,
          attendanceList: loadedState.attendanceList,
          months: loadedState.months,
          selectedMonthIndex: month,
        ),
      );
    }
  }
}
