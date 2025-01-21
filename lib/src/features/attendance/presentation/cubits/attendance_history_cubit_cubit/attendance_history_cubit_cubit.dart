import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../../core/errors/failures.dart';
import '../../../../../core/storage/storage_helper.dart';
import '../../../../authentication/data/entities/user_login_entity.dart';
import '../../../data/entities/attendance_history_record_entity.dart';
import '../../../data/entities/attendance_history_record_params.dart';
import '../../../data/repository/attendance_repository.dart';

part 'attendance_history_cubit_state.dart';

class AttendanceHistoryCubit extends Cubit<AttendanceHistoryState> {
  final String attendanceId;
  final AttendanceRepository attendanceRepository;
  AttendanceHistoryCubit({
    required this.attendanceId,
    required this.attendanceRepository,
  }) : super(
          const AttendanceHistoryInitial(
            selectedAttendanceHistoryRecord: null,
          ),
        ) {
    fetchAttendanceHistoryList();
  }

  GoogleMapController? googleMapController;

  void onMapCreated(GoogleMapController controller) {
    googleMapController = controller;
    forceReRender();
  }

  Future<void> fetchAttendanceHistoryList() async {
    emit(
      AttendanceHistoryLoading(
        selectedAttendanceHistoryRecord: state.selectedAttendanceHistoryRecord,
      ),
    );

    final userData = await StorageHelper.getUserData();
    if (userData != null) {
      final user = UserLoginEntity.fromJson(jsonDecode(userData));
      final result = await attendanceRepository.fetchAttendanceHistoryList(
        AttendanceHistoryRecordParams(
          userId: user.userId,
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

  void updateAttendanceHistoryMap(AttendanceHistoryRecordEntity value) {
    emit(state.copyWith(selectedAttendanceHistoryRecord: value));

    if (googleMapController != null) {
      final position = CameraPosition(
        target: LatLng(
          double.parse(value.locationLatitude),
          double.parse(value.locationLongitude),
        ),
        zoom: 14.0,
      );
      googleMapController!
          .animateCamera(CameraUpdate.newCameraPosition(position));
    }
  }

  Future<void> forceReRender() async {
    await googleMapController?.setMapStyle('[]');
  }

  LatLng parseLatLng(String latitude, String longitude) {
    if (latitude.isNotEmpty && longitude.isNotEmpty) {
      try {
        return LatLng(double.parse(latitude), double.parse(longitude));
      } catch (e) {}
    }
    return const LatLng(0, 0);
  }

  @override
  Future<void> close() {
    googleMapController?.dispose();
    return super.close();
  }
}
