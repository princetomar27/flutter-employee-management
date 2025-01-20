part of 'attendance_history_cubit_cubit.dart';

sealed class AttendanceHistoryCubitState extends Equatable {
  const AttendanceHistoryCubitState();

  @override
  List<Object?> get props => [];
}

final class AttendanceHistoryCubitLoading extends AttendanceHistoryCubitState {}

final class AttendanceHistoryCubitInitial extends AttendanceHistoryCubitState {}

final class AttendanceHistoryCubitFailure extends AttendanceHistoryCubitState {
  final Failure failure;

  const AttendanceHistoryCubitFailure({required this.failure});
}

final class AttendanceHistoryCubitLoaded extends AttendanceHistoryCubitState {
  final List<AttendanceHistoryRecordEntity>? attendanceHistoryList;

  const AttendanceHistoryCubitLoaded({required this.attendanceHistoryList});

  @override
  List<Object?> get props => [
        attendanceHistoryList,
      ];
}
