import 'dart:async';
import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/storage/storage_helper.dart';
import '../../../authentication/data/entities/user_login_entity.dart';
import '../../data/entities/location_entity.dart';
import '../../data/repository/home_repository.dart';

part 'home_screen_state.dart';

class HomeScreenCubit extends Cubit<HomeScreenState> {
  final HomeRepository homeRepository;

  Timer? _timer;

  HomeScreenCubit({
    required this.homeRepository,
  }) : super(HomeScreenState(
          currentDateTime: DateTime.now(),
          userProfile: null,
          isCheckedIn: false,
        )) {
    _initialize();
  }

  void _startDateTimeUpdater() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      emit(state.copyWith(currentDateTime: DateTime.now()));
    });
  }

  void _initialize() {
    _startDateTimeUpdater();
    fetchUserProfile();
    loadHomeScreenData();
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }

  Future<void> loadHomeScreenData() async {
    emit(HomeScreenLoading(
      DateTime.now(),
    ));
    final locationResult = await homeRepository.getCurrentLocation();

    locationResult.fold(
      (failure) => emit(HomeScreenFailure(
          currentDateTime: DateTime.now(),
          message: failure.message,
          isCheckedIn: state.isCheckedIn)),
      (location) => emit(
        HomeScreenLoaded(
          currentDateTime: DateTime.now(),
          location: location,
          userProfile: state.userProfile,
          isCheckedIn: state.isCheckedIn,
        ),
      ),
    );
  }

  void toggleCheckIn(bool value) {
    print("API called: Check-In status is now $value");

    emit(
      state.copyWith(
        currentDateTime: DateTime.now(),
        isCheckedIn: value,
        userProfile: state.userProfile,
      ),
    );
  }

  Future<void> fetchUserProfile() async {
    final userData = await StorageHelper.getUserData();
    if (userData != null) {
      final user = UserLoginEntity.fromJson(jsonDecode(userData));
      print(user);
      emit(
        HomeScreenState(
          currentDateTime: DateTime.now(),
          isCheckedIn: state.isCheckedIn,
          userProfile: user,
        ),
      );
    } else {
      emit(
        HomeScreenState(
          currentDateTime: DateTime.now(),
          isCheckedIn: state.isCheckedIn,
          userProfile: state.userProfile,
        ),
      );
    }
  }
}
