part of 'attendance_history_cubit_cubit.dart';

sealed class AttendanceHistoryState extends Equatable {
  final AttendanceHistoryRecordEntity? selectedAttendanceHistoryRecord;
  const AttendanceHistoryState({
    required this.selectedAttendanceHistoryRecord,
  });

  @override
  List<Object?> get props => [
        selectedAttendanceHistoryRecord,
      ];

  // copyWith method
  AttendanceHistoryState copyWith({
    AttendanceHistoryRecordEntity? selectedAttendanceHistoryRecord,
  });
}

final class AttendanceHistoryLoading extends AttendanceHistoryState {
  const AttendanceHistoryLoading(
      {required super.selectedAttendanceHistoryRecord});

  @override
  AttendanceHistoryState copyWith(
      {AttendanceHistoryRecordEntity? selectedAttendanceHistoryRecord}) {
    return AttendanceHistoryLoading(
      selectedAttendanceHistoryRecord: selectedAttendanceHistoryRecord,
    );
  }
}

final class AttendanceHistoryInitial extends AttendanceHistoryState {
  const AttendanceHistoryInitial(
      {required super.selectedAttendanceHistoryRecord});

  @override
  AttendanceHistoryState copyWith(
      {AttendanceHistoryRecordEntity? selectedAttendanceHistoryRecord}) {
    return AttendanceHistoryInitial(
      selectedAttendanceHistoryRecord: selectedAttendanceHistoryRecord,
    );
  }
}

final class AttendanceHistoryFailure extends AttendanceHistoryState {
  final Failure failure;

  const AttendanceHistoryFailure(
      {required this.failure, required super.selectedAttendanceHistoryRecord});

  @override
  AttendanceHistoryState copyWith(
      {AttendanceHistoryRecordEntity? selectedAttendanceHistoryRecord}) {
    return AttendanceHistoryFailure(
      failure: failure,
      selectedAttendanceHistoryRecord: selectedAttendanceHistoryRecord,
    );
  }
}

final class AttendanceHistoryLoaded extends AttendanceHistoryState {
  final List<AttendanceHistoryRecordEntity>? attendanceHistoryList;

  const AttendanceHistoryLoaded({
    required this.attendanceHistoryList,
    required super.selectedAttendanceHistoryRecord,
  });

  @override
  List<Object?> get props => [
        attendanceHistoryList,
        selectedAttendanceHistoryRecord,
      ];

  @override
  AttendanceHistoryState copyWith(
      {AttendanceHistoryRecordEntity? selectedAttendanceHistoryRecord}) {
    return AttendanceHistoryLoaded(
      attendanceHistoryList: attendanceHistoryList,
      selectedAttendanceHistoryRecord: selectedAttendanceHistoryRecord ??
          this.selectedAttendanceHistoryRecord,
    );
  }
}
