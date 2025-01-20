part of 'attendance_cubit.dart';

class AttendanceState extends Equatable {
  final List<AttendanceEntity>? attendanceList;

  const AttendanceState({required this.attendanceList});

  AttendanceState copyWith({List<AttendanceEntity>? attendaceList}) {
    return AttendanceState(
      attendanceList: attendaceList ?? this.attendanceList,
    );
  }

  @override
  List<Object?> get props => [attendanceList];
}

class AttendanceLoading extends AttendanceState {
  const AttendanceLoading({required super.attendanceList});
}

class AttendanceFailure extends AttendanceState {
  final Failure? failure;

  const AttendanceFailure(
      {required super.attendanceList, required this.failure});

  @override
  AttendanceFailure copyWith({
    Failure? failure,
    List<AttendanceEntity>? attendaceList,
  }) {
    return AttendanceFailure(
      attendanceList: attendaceList,
      failure: failure,
    );
  }

  @override
  List<Object?> get props => [attendanceList, failure];
}

class AttendanceLoaded extends AttendanceState {
  final List<AttendanceEntity>? employeeAttendanceList;
  final List<String> months;
  final int? selectedMonthIndex;

  const AttendanceLoaded({
    required super.attendanceList,
    required this.employeeAttendanceList,
    required this.months,
    required this.selectedMonthIndex,
  });

  @override
  AttendanceLoaded copyWith({
    List<AttendanceEntity>? employeeAttendanceList,
    List<AttendanceEntity>? attendaceList,
    List<String>? months,
    int? selectedMonthIndex,
  }) {
    return AttendanceLoaded(
      attendanceList: attendaceList,
      employeeAttendanceList:
          employeeAttendanceList ?? this.employeeAttendanceList,
      months: months ?? this.months,
      selectedMonthIndex: selectedMonthIndex ?? this.selectedMonthIndex,
    );
  }

  @override
  List<Object?> get props => [
        attendanceList,
        employeeAttendanceList,
        months,
        selectedMonthIndex,
      ];
}
