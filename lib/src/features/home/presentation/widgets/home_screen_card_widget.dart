import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/colors/app_colors.dart';
import '../../../../core/constants/datetime_entensions.dart';
import '../../../../presentation/paddings.dart';
import '../cubit/home_screen_cubit.dart';

class HomeScreenCardWidget extends StatefulWidget {
  const HomeScreenCardWidget({super.key});

  @override
  State<HomeScreenCardWidget> createState() => _HomeScreenCardWidgetState();
}

class _HomeScreenCardWidgetState extends State<HomeScreenCardWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeScreenCubit, HomeScreenState>(
      builder: (context, state) {
        final adress = state is HomeScreenLoaded
            ? state.location.address
            : "Fetching Address";

        switch (state) {
          case HomeScreenLoading():
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.backgroundColor,
              ),
            );

          case HomeScreenLoaded():
            return Container(
              height: 200,
              width: double.maxFinite,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Welcome to MIS"),
                      padding8,
                      Text(
                        state.currentDateTime.toTimeFormat(),
                        style: const TextStyle(fontSize: 28),
                      ),
                      padding20,
                      Row(
                        children: [
                          const Icon(
                            Icons.access_time_sharp,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${state.currentDateTime.toDayOfWeek()}, ',
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            state.currentDateTime.toFullDate(),
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      padding8,
                      _HomeScreenCardSubDetailsWidget(
                        icon: Icons.location_on_rounded,
                        title: "Location",
                        value: adress,
                      ),
                      padding8,
                      const _HomeScreenCardSubDetailsWidget(
                        icon: Icons.login,
                        title: "Check-In",
                        value: "",
                      )
                    ],
                  ),
                  Column(
                    children: [
                      padding48,
                      state.userProfile != null &&
                              state.userProfile?.profileImage.isNotEmpty == true
                          ? Image.network(state.userProfile!.profileImage)
                          : const Icon(
                              Icons.account_circle,
                              size: 50,
                              color: AppColors.backgroundColor,
                            ),
                      padding20,
                      BlocBuilder<HomeScreenCubit, HomeScreenState>(
                        builder: (context, crntState) {
                          final cubit = context.read<HomeScreenCubit>();
                          return GestureDetector(
                            onTap: () {
                              final currentValue = crntState is HomeScreenLoaded
                                  ? state.isCheckedIn
                                  : false;
                              if (currentValue == false) {
                                cubit.checkInUser();
                              } else {
                                cubit.checkOutUser();
                              }
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.easeInOut,
                              width: 50.0,
                              height: 30.0,
                              padding: const EdgeInsets.all(4.0),
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: AppColors.borderColor),
                                borderRadius: BorderRadius.circular(15),
                                color: crntState is HomeScreenLoaded &&
                                        state.isCheckedIn
                                    ? Colors.green
                                    : Colors.red.shade800,
                              ),
                              child: Align(
                                alignment: crntState is HomeScreenLoaded &&
                                        state.isCheckedIn
                                    ? Alignment.centerRight
                                    : Alignment.centerLeft,
                                child: Container(
                                  width: 16.0,
                                  height: 16.0,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: crntState is HomeScreenLoaded &&
                                            state.isCheckedIn
                                        ? Colors.greenAccent
                                        : Colors.redAccent,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    ],
                  ),
                ],
              ),
            );

          default:
        }

        return const SizedBox.shrink();
      },
    );
  }
}

class _HomeScreenCardSubDetailsWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  const _HomeScreenCardSubDetailsWidget({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 18,
        ),
        const SizedBox(width: 8),
        Text(
          "$title : ",
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
        SizedBox(
          width: 150,
          child: Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
