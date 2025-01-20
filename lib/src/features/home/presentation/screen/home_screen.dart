import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/colors/app_colors.dart';
import '../../../../core/constants/navigation_constants.dart';
import '../../../../core/injector/injection_container.dart';
import '../../../../presentation/paddings.dart';
import '../../../attendance/presentation/screens/attendance_screen.dart';
import '../cubit/home_screen_cubit.dart';
import '../widgets/home_screen_card_widget.dart';
import '../widgets/home_screen_menu_card_item_widget.dart';
import '../widgets/home_screen_menu_grid_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<HomeScreenMenuCardItem> homeScreenMenuItems;

  @override
  void initState() {
    super.initState();
    homeScreenMenuItems = _createHomeScreenMenuItems();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeScreenCubit(homeRepository: sl()),
      child: BlocBuilder<HomeScreenCubit, HomeScreenState>(
        builder: (context, state) {
          return Scaffold(
              backgroundColor: AppColors.backgroundColor,
              appBar: AppBar(
                backgroundColor: AppColors.backgroundColor,
                actions: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.notifications_active_outlined,
                          size: 36,
                          color: AppColors.textPrimaryColor,
                        ),
                        onPressed: () {},
                      ),
                      Positioned(
                        right: -4,
                        top: 2,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: AppColors.errorColor,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            '1',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  padding20,
                  if (state is HomeScreenLoaded &&
                      state.userProfile != null &&
                      state.userProfile?.profileImage.isNotEmpty == true)
                    Image.network(state.userProfile!.profileImage)
                  else
                    Icon(
                      Icons.account_circle,
                      size: 44,
                      color: AppColors.homeAppBarProfileIconColor,
                    ),
                  padding20,
                ],
              ),
              body: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16),
                child: Column(
                  children: [
                    padding14,
                    const HomeScreenCardWidget(),
                    padding20,
                    Flexible(
                      child: HomeScreenMenuGridWidget(
                        cardItems: homeScreenMenuItems,
                      ),
                    ),
                  ],
                ),
              ));
        },
      ),
    );
  }

  List<HomeScreenMenuCardItem> _createHomeScreenMenuItems() {
    return [
      const HomeScreenMenuCardItem(
        iconPath: Icons.edit_calendar_outlined,
        title: 'Leave Management',
      ),
      HomeScreenMenuCardItem(
        iconPath: Icons.calendar_month_outlined,
        onTap: () =>
            NavigationHelper.navigateTo(context, const AttendanceScreen()),
        title: 'Attendance Management',
      ),
      const HomeScreenMenuCardItem(
        iconPath: Icons.home_outlined,
        title: 'Work from Home',
      ),
      const HomeScreenMenuCardItem(
        iconPath: Icons.view_list_sharp,
        title: 'Project Task',
      ),
      const HomeScreenMenuCardItem(
        iconPath: Icons.percent,
        title: 'Performance',
      ),
      const HomeScreenMenuCardItem(
        iconPath: Icons.people_alt_outlined,
        title: 'Shift Roster',
      ),
      const HomeScreenMenuCardItem(
        iconPath: Icons.person_4_outlined,
        title: 'Employee Onboarding',
      ),
      const HomeScreenMenuCardItem(
        iconPath: Icons.settings_accessibility_rounded,
        title: 'Recruitment & Hiring',
      ),
      const HomeScreenMenuCardItem(
        iconPath: Icons.travel_explore_outlined,
        title: 'Travel & Expense',
      ),
    ];
  }
}
