import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/colors/app_colors.dart';
import '../../../../core/injector/injection_container.dart';
import '../../../../presentation/paddings.dart';
import '../cubit/home_screen_cubit.dart';
import '../widgets/home_screen_card_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            const SizedBox(
              width: 20,
            ),
          ],
        ),
        body: BlocProvider(
          create: (_) => HomeScreenCubit(
            homeRepository: sl(),
          ),
          child: BlocBuilder<HomeScreenCubit, HomeScreenState>(
            builder: (context, state) {
              switch (state) {
                case HomeScreenLoading():
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryColor,
                    ),
                  );

                case HomeScreenInitial():
                  return const Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 4.0, horizontal: 16),
                    child: Column(
                      children: [
                        padding14,
                        HomeScreenCardWidget(),
                      ],
                    ),
                  );

                case HomeScreenLoaded():
                  return const Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 4.0, horizontal: 16),
                    child: Column(
                      children: [
                        padding14,
                        HomeScreenCardWidget(),
                      ],
                    ),
                  );

                case HomeScreenFailure():
                  return Center(
                    child: Text("Failure : \n${state.failure.message}"),
                  );

                default:
                  return const SizedBox.shrink();
              }
            },
          ),
        ));
  }
}
