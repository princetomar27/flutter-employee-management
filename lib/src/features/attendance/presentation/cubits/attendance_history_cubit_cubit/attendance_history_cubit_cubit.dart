import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/errors/failures.dart';
import '../../../data/entities/attendance_history_record_entity.dart';
import '../../../data/entities/attendance_history_record_params.dart';
import '../../../data/repository/attendance_repository.dart';

part 'attendance_history_cubit_state.dart';

class AttendanceHistoryCubit extends Cubit<AttendanceHistoryState> {
  final String userId;
  final String attendanceId;
  final AttendanceRepository attendanceRepository;
  AttendanceHistoryCubit({
    required this.userId,
    required this.attendanceId,
    required this.attendanceRepository,
  }) : super(
          const AttendanceHistoryInitial(
            selectedAttendanceHistoryRecord: null,
          ),
        );

  Future<void> fetchAttendanceHistoryList() async {
    emit(
      AttendanceHistoryLoading(
        selectedAttendanceHistoryRecord: state.selectedAttendanceHistoryRecord,
      ),
    );
    final result = await attendanceRepository.fetchAttendanceHistoryList(
      AttendanceHistoryRecordParams(
        userId: userId,
        attendanceId: attendanceId,
      ),
    );

    result.fold(
      (failure) => emit(
        AttendanceHistoryFailure(
          failure: failure,
          selectedAttendanceHistoryRecord:
              state.selectedAttendanceHistoryRecord,
        ),
      ),
      (attendanceHistoryList) => emit(
        AttendanceHistoryLoaded(
          attendanceHistoryList: attendanceHistoryList,
          selectedAttendanceHistoryRecord: attendanceHistoryList.first,
        ),
      ),
    );
  }
}
