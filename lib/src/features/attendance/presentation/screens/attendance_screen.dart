import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/colors/app_colors.dart';
import '../../../../core/injector/injection_container.dart';
import '../../../../presentation/paddings.dart';
import '../cubits/attendance_cubit/attendance_cubit.dart';
import 'widgets/attendance_card_widget.dart';

class AttendanceScreen extends StatelessWidget {
  const AttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: const Text("Attendance"),
        centerTitle: false,
      ),
      body: BlocProvider(
        create: (context) => AttendanceCubit(
          attendanceRepository: sl(),
        ),
        child: BlocBuilder<AttendanceCubit, AttendanceState>(
          builder: (context, state) {
            final cubit = context.read<AttendanceCubit>();

            if (state is AttendanceLoaded) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    padding12,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          color: AppColors.primaryColor,
                          size: 32,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppColors.buttonColor,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          width: 160,
                          child: DropdownButton<String>(
                            items: state.months
                                .map((month) => DropdownMenuItem<String>(
                                      value: month,
                                      child: Text(month),
                                    ))
                                .toList(),
                            onChanged: (newValue) {
                              final monthIndex =
                                  state.months.indexOf(newValue!);
                              cubit.filterAttendanceByMonth(monthIndex);
                            },
                            value: state.selectedMonthIndex != null
                                ? state.months[state.selectedMonthIndex!]
                                : null,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            borderRadius: BorderRadius.circular(5),
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                            underline: const SizedBox(),
                            hint: const Text('Select Month'),
                          ),
                        )
                      ],
                    ),
                    padding12,
                    BlocBuilder<AttendanceCubit, AttendanceState>(
                      builder: (context, state) {
                        if (state is AttendanceLoading) {
                          return const CircularProgressIndicator();
                        } else if (state is AttendanceFailure) {
                          return Text('Error: ${state.failure}');
                        } else if (state is AttendanceLoaded) {
                          if (state.employeeAttendanceList != null &&
                              state.employeeAttendanceList!.isEmpty) {
                            return Center(
                              child: Text(
                                'No attendance data found\nFor ${state.months[state.selectedMonthIndex!]} month',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimaryColor,
                                ),
                              ),
                            );
                          }
                          return Expanded(
                            child: ListView.builder(
                              itemCount:
                                  state.employeeAttendanceList?.length ?? 0,
                              itemBuilder: (context, index) {
                                final attendance =
                                    state.employeeAttendanceList![index];
                                return AttendanceCardWidget(
                                    attendance: attendance);
                              },
                            ),
                          );
                        }
                        return Container();
                      },
                    ),
                  ],
                ),
              );
            } else if (state is AttendanceLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: AppColors.primaryColor,
                ),
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
