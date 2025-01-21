import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutteremployeemanagement/src/presentation/paddings.dart';
import 'package:intl/intl.dart';

import '../../../../../core/colors/app_colors.dart';
import '../../../../../core/constants/navigation_constants.dart';
import '../../../data/entities/attendance_entity.dart';
import 'attendance_track_history_widget.dart';

class AttendanceCardWidget extends StatelessWidget {
  final AttendanceEntity attendance;

  const AttendanceCardWidget({
    super.key,
    required this.attendance,
  });

  @override
  Widget build(BuildContext context) {
    DateTime checkInDate;
    DateTime checkOutDate;
    try {
      checkInDate = DateFormat('dd-MM-yyyy HH:mm').parse(attendance.checkIn);
      checkOutDate = DateFormat('dd-MM-yyyy HH:mm').parse(attendance.checkOut);
    } catch (e) {
      checkInDate = DateTime.now();
      checkOutDate = DateTime.now();
    }

    final timeFormat = DateFormat('hh:mm a');
    final checkInFormattedTime = timeFormat.format(checkInDate);
    final checkOutFormattedTime = timeFormat.format(checkOutDate);

    final dayOfWeek =
        DateFormat('EEEE').format(checkInDate).substring(0, 3).toUpperCase();

    final dayOfMonth = checkInDate.day;

    return SizedBox(
      height: 85,
      child: Card(
        color: AppColors.attendanceTileColor,
        child: ListTile(
          contentPadding: const EdgeInsets.all(8),
          leading: Container(
            height: 45,
            width: 45,
            padding: const EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: generateRandomContainerColor(),
            ),
            child: Column(children: [
              Text(
                dayOfMonth.toString(),
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.textSecondaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                dayOfWeek,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondaryColor,
                  fontWeight: FontWeight.w500,
                ),
              )
            ]),
          ),
          title: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _AttendanceInfoWidget(
                  title: "Punch In", value: checkInFormattedTime),
              padding4,
              _AttendanceInfoWidget(
                  title: "Punched Out", value: checkOutFormattedTime),
              padding4,
              _AttendanceInfoWidget(
                  title: "Total Hours", value: attendance.duration),
              padding4,
              InkWell(
                onTap: () {
                  NavigationHelper.navigateTo(
                    context,
                    AttendanceTrackHistoryWidget(
                      attendanceId: attendance.attendeceCode,
                      checkInTime: attendance.checkIn,
                    ),
                  );
                },
                child: const _AttendanceInfoWidget(
                  title: "View Map",
                  value: "",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Color generateRandomContainerColor() {
  Random random = Random();
  List<Color> palette = const [
    Color(0xFFFFBF00),
    Color(0xFFD72638),
    Color(0xFF1B998B),
    Color(0xFF3A86FF),
    Color(0xFF8338EC),
    Color(0xFFFF006E),
    Color(0xFFFFBE0B),
    Color(0xFFFB5607),
    Color(0xFF2EC4B6),
    Color(0xFF6A0572),
  ];

  return palette[random.nextInt(palette.length)];
}

class _AttendanceInfoWidget extends StatelessWidget {
  final String title;
  final String value;
  const _AttendanceInfoWidget({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textPrimaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          title,
          style: const TextStyle(fontSize: 10, color: AppColors.greyColor),
        ),
      ],
    );
  }
}
