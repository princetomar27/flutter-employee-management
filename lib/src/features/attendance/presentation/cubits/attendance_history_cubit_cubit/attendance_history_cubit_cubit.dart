import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/errors/failures.dart';
import '../../../data/entities/attendance_history_record_entity.dart';
import '../../../data/entities/attendance_history_record_params.dart';
import '../../../data/repository/attendance_repository.dart';

part 'attendance_history_cubit_state.dart';

class AttendanceHistoryCubitCubit extends Cubit<AttendanceHistoryCubitState> {
  final String userId;
  final String attendanceId;
  final AttendanceRepository attendanceRepository;
  AttendanceHistoryCubitCubit({
    required this.userId,
    required this.attendanceId,
    required this.attendanceRepository,
  }) : super(AttendanceHistoryCubitInitial());

  Future<void> fetchAttendanceHistoryList() async {
    emit(AttendanceHistoryCubitLoading());
    final result = await attendanceRepository.fetchAttendanceHistoryList(
      AttendanceHistoryRecordParams(
        userId: userId,
        attendanceId: attendanceId,
      ),
    );

    result.fold(
      (failure) => emit(
        AttendanceHistoryCubitFailure(failure: failure),
      ),
      (attendanceHistoryList) => emit(
        AttendanceHistoryCubitLoaded(
          attendanceHistoryList: attendanceHistoryList,
        ),
      ),
    );
  }
}
