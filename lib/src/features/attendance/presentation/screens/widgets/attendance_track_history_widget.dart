import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';

import '../../../../../core/colors/app_colors.dart';
import '../../../../../core/constants/datetime_entensions.dart';
import '../../../../../core/injector/injection_container.dart';
import '../../../../../presentation/paddings.dart';
import '../../cubits/attendance_history_cubit_cubit/attendance_history_cubit_cubit.dart';

class AttendanceTrackHistoryWidget extends StatelessWidget {
  final String attendanceId;
  final String checkInTime;

  const AttendanceTrackHistoryWidget({
    super.key,
    required this.attendanceId,
    required this.checkInTime,
  });

  void _initializeMapRenderer() {
    final GoogleMapsFlutterPlatform mapsImplementation =
        GoogleMapsFlutterPlatform.instance;
    if (mapsImplementation is GoogleMapsFlutterAndroid) {
      mapsImplementation.useAndroidViewSurface = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    _initializeMapRenderer();
    return Scaffold(
      appBar: AppBar(
        title: Text("Check In : $checkInTime"),
        centerTitle: false,
      ),
      body: BlocProvider(
        create: (context) => AttendanceHistoryCubit(
          attendanceId: attendanceId,
          attendanceRepository: sl(),
        ),
        child: BlocBuilder<AttendanceHistoryCubit, AttendanceHistoryState>(
          builder: (context, state) {
            final cubit = context.read<AttendanceHistoryCubit>();
            if (state is AttendanceHistoryLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is AttendanceHistoryFailure) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Failed to load attendance history",
                      style:
                          TextStyle(fontSize: 24, color: AppColors.errorColor),
                    ),
                    padding16,
                    Text(
                      state.failure.message,
                      style: const TextStyle(
                          fontSize: 18, color: AppColors.greyColor),
                    ),
                  ],
                ),
              );
            } else if (state is AttendanceHistoryLoaded) {
              final selectedRecord = state.selectedAttendanceHistoryRecord;
              final attendanceHistoryList = state.attendanceHistoryList ?? [];

              if (selectedRecord == null || attendanceHistoryList.isEmpty) {
                return const SizedBox.shrink();
              }

              final startLatLng = cubit.parseLatLng(
                selectedRecord.locationLatitude,
                selectedRecord.locationLongitude,
              );

              final destinationRecord = attendanceHistoryList.last;
              final destinationLatLng = cubit.parseLatLng(
                destinationRecord.locationLatitude,
                destinationRecord.locationLongitude,
              );

              return Column(
                children: [
                  Expanded(
                    flex: 7,
                    child: GoogleMap(
                      compassEnabled: false,
                      zoomControlsEnabled: false,
                      myLocationEnabled: true,
                      onMapCreated: cubit.onMapCreated,
                      initialCameraPosition: CameraPosition(
                        target: startLatLng,
                        zoom: 14.0,
                      ),
                      indoorViewEnabled: false,
                      mapType: MapType.terrain,
                      markers: {
                        Marker(
                          markerId: const MarkerId('Check-In'),
                          position: startLatLng,
                          infoWindow: InfoWindow(
                            title: 'Start Location',
                            snippet: selectedRecord.locationArea,
                          ),
                          icon: BitmapDescriptor.defaultMarkerWithHue(
                            BitmapDescriptor.hueGreen,
                          ),
                        ),
                        Marker(
                          markerId: const MarkerId('Check-Out'),
                          position: destinationLatLng,
                          infoWindow: InfoWindow(
                            title: 'Last Location',
                            snippet: destinationRecord.locationArea,
                          ),
                          icon: BitmapDescriptor.defaultMarkerWithHue(
                            BitmapDescriptor.hueRed,
                          ),
                        ),
                      },
                      polylines: {
                        Polyline(
                          polylineId: const PolylineId('route'),
                          color: Colors.blue,
                          width: 4,
                          points: [startLatLng, destinationLatLng],
                        ),
                      },
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: ListView.builder(
                      itemCount: attendanceHistoryList.length,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      itemBuilder: (context, index) {
                        final record = attendanceHistoryList[index];
                        final isFirst = index == 0;
                        final isLast =
                            index == attendanceHistoryList.length - 1;

                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                if (!isFirst)
                                  Container(
                                    width: 2,
                                    height: 16,
                                    color: AppColors.greyColor,
                                  ),
                                const CircleAvatar(
                                  backgroundColor: AppColors.successColor,
                                  child: Icon(
                                    Icons.location_on_sharp,
                                    size: 24,
                                    color: AppColors.backgroundColor,
                                  ),
                                ),
                                if (!isLast)
                                  Container(
                                    width: 2,
                                    height: 16,
                                    color: AppColors.greyColor,
                                  ),
                              ],
                            ),
                            padding8,
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (isLast) padding16,
                                  Text(
                                    record.locationArea,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.greyColor,
                                    ),
                                  ),
                                  Text(
                                    'Time: ${DateTimeFormatter.fromTimestamp(record.dataEntryDate)}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: AppColors.textPrimaryColor,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  if (isFirst) padding16,
                                ],
                              ),
                            ),
                            padding8,
                          ],
                        );
                      },
                    ),
                  )
                ],
              );
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}
