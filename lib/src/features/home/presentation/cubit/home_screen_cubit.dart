import 'dart:async';
import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/storage/storage_helper.dart';
import '../../../authentication/data/entities/user_login_entity.dart';
import '../../data/entities/check_in_entity.dart';
import '../../data/entities/check_in_params.dart';
import '../../data/entities/check_out_params.dart';
import '../../data/entities/location_entity.dart';
import '../../data/entities/location_track_entity_params.dart';
import '../../data/repository/home_repository.dart';

part 'home_screen_state.dart';

class HomeScreenCubit extends Cubit<HomeScreenState> {
  final HomeRepository homeRepository;

  Timer? _timer;
  Timer? _locationTrackingTimer;

  HomeScreenCubit({
    required this.homeRepository,
  }) : super(HomeScreenInitial(
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
          failure: failure,
          isCheckedIn: state.isCheckedIn)),
      (location) {
        emit(
          HomeScreenLoaded(
            currentDateTime: DateTime.now(),
            location: location,
            userProfile: state.userProfile,
            isCheckedIn: state.isCheckedIn,
          ),
        );

        fetchUserProfile();
      },
    );
  }

  Future<void> fetchUserProfile() async {
    if (state is HomeScreenLoaded) {
      final currentState = state as HomeScreenLoaded;
      final userData = await StorageHelper.getUserData();
      if (userData != null) {
        final user = UserLoginEntity.fromJson(jsonDecode(userData));
        emit(
          currentState.copyWith(
            currentDateTime: DateTime.now(),
            isCheckedIn: currentState.isCheckedIn,
            userProfile: user,
          ),
        );
      }
    }
  }

  Future<void> checkInUser() async {
    if (state is HomeScreenLoaded) {
      final currentState = state as HomeScreenLoaded;
      CheckInParams checkInParams = CheckInParams(
        userId: '${currentState.userProfile?.userId}',
        latitude: '${currentState.location.latitude}',
        longitude: '${currentState.location.longitude}',
        locationAddress: currentState.location.address,
      );

      final result = await homeRepository.checkInUser(checkInParams);
      result.fold(
        (failure) => null,
        (checkInResult) {
          StorageHelper.saveCheckInData(checkInResult);
          if (checkInResult.status == 1) {
            emit(
              currentState.copyWith(
                currentDateTime: DateTime.now(),
                isCheckedIn: true,
                userProfile: state.userProfile,
              ),
            );
            _startLocationTracking(checkInData: checkInResult);
            debugPrint(
                "${jsonEncode(checkInParams.toJson())}\n ${jsonEncode(checkInResult)}");
          }
        },
      );
    }
  }

  Future<void> checkOutUser() async {
    if (state is HomeScreenLoaded) {
      final currentState = state as HomeScreenLoaded;

      final checkedInData = await StorageHelper.getCheckInData();
      if (checkedInData == null) {
        return;
      }

      final checkInData = await StorageHelper.getCheckInData();

      if (checkInData == null) {
        return;
      }

      final userCurrentLocation = await homeRepository.getCurrentLocation();
      double userDistance = 0;

      userCurrentLocation.fold((l) => null, (currentLocation) {
        double checkInLatitude = currentState.location.latitude;
        double checkInLongitude = currentState.location.longitude;
        double currentLatitude = currentLocation.latitude;
        double currentLongitude = currentLocation.longitude;

        double dist = Geolocator.distanceBetween(
          checkInLatitude,
          checkInLongitude,
          currentLatitude,
          currentLongitude,
        );
        userDistance = dist;
      });

      CheckOutParams checkOutParams = CheckOutParams(
        userId: '${currentState.userProfile?.userId}',
        checkInId: checkInData.checkInId,
        latitude: '${currentState.location.latitude}',
        longitude: '${currentState.location.longitude}',
        location: currentState.location.address,
        distance: userDistance,
      );

      final result = await homeRepository.checkOutUser(checkOutParams);
      result.fold(
        (failure) => null,
        (checkOutResult) {
          _locationTrackingTimer?.cancel();
          StorageHelper.clearUserCheckInData();

          emit(
            currentState.copyWith(
              currentDateTime: DateTime.now(),
              isCheckedIn: false,
              userProfile: state.userProfile,
            ),
          );
          debugPrint(
              "${jsonEncode(checkOutParams.toJson())}\n ${jsonEncode(checkOutResult)}");
        },
      );
    }
  }

  Future<void> trackUserLocation({
    required CheckInEntity checkInData,
  }) async {
    if (state is HomeScreenLoaded) {
      final currentState = state as HomeScreenLoaded;
      LocationTrackParams locationTrackParams = LocationTrackParams(
        userId: currentState.userProfile?.userId ?? '',
        checkInId: checkInData.checkInId,
        latitude: '${currentState.location.latitude}',
        longitude: '${currentState.location.longitude}',
        locationAddress: currentState.location.address,
      );

      final result =
          await homeRepository.trackUserLocation(locationTrackParams);

      result.fold(
        (failure) => null,
        (locationSuccess) => emit(currentState),
      );
    }
  }

  void _startLocationTracking({required CheckInEntity checkInData}) {
    _locationTrackingTimer?.cancel();
    _locationTrackingTimer = Timer.periodic(
      const Duration(minutes: 30),
      (timer) {
        trackUserLocation(checkInData: checkInData);
      },
    );
  }
}
