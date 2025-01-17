part of 'home_screen_cubit.dart';

class HomeScreenState extends Equatable {
  final DateTime currentDateTime;
  final UserLoginEntity? userProfile;
  final bool isCheckedIn;

  const HomeScreenState({
    required this.currentDateTime,
    required this.userProfile,
    required this.isCheckedIn,
  });

  HomeScreenState copyWith({
    DateTime? currentDateTime,
    UserLoginEntity? userProfile,
    bool? isCheckedIn,
  }) {
    return HomeScreenState(
      currentDateTime: currentDateTime ?? this.currentDateTime,
      userProfile: userProfile ?? this.userProfile,
      isCheckedIn: isCheckedIn ?? this.isCheckedIn,
    );
  }

  @override
  List<Object?> get props => [
        currentDateTime,
        userProfile,
        isCheckedIn,
      ];
}

class HomeScreenInitial extends HomeScreenState {
  HomeScreenInitial({
    required UserLoginEntity? userProfile,
    required bool isCheckedIn,
  }) : super(
          currentDateTime: DateTime.now(),
          userProfile: userProfile,
          isCheckedIn: false,
        );
}

class HomeScreenLoading extends HomeScreenState {
  final DateTime timestamp;

  HomeScreenLoading(this.timestamp)
      : super(
          currentDateTime: DateTime.now(),
          userProfile: null,
          isCheckedIn: false,
        );
}

class HomeScreenLoaded extends HomeScreenState {
  final LocationEntity location;

  HomeScreenLoaded({
    required DateTime currentDateTime,
    required UserLoginEntity? userProfile,
    required bool isCheckedIn,
    required this.location,
  }) : super(
          currentDateTime: currentDateTime,
          userProfile: userProfile,
          isCheckedIn: isCheckedIn,
        );

  @override
  List<Object?> get props => [
        location,
        userProfile,
        isCheckedIn,
        currentDateTime,
      ];

  @override
  HomeScreenLoaded copyWith({
    DateTime? currentDateTime,
    LocationEntity? location,
    UserLoginEntity? userProfile,
    bool? isCheckedIn,
  }) {
    return HomeScreenLoaded(
      currentDateTime: currentDateTime ?? this.currentDateTime,
      location: location ?? this.location,
      userProfile: userProfile ?? this.userProfile,
      isCheckedIn: isCheckedIn ?? this.isCheckedIn,
    );
  }
}

class HomeScreenFailure extends HomeScreenState {
  final Failure failure;

  const HomeScreenFailure({
    required DateTime currentDateTime,
    UserLoginEntity? userProfile,
    required this.failure,
    required bool isCheckedIn,
  }) : super(
          currentDateTime: currentDateTime,
          userProfile: userProfile,
          isCheckedIn: isCheckedIn,
        );

  @override
  List<Object?> get props => [
        failure,
        userProfile,
        isCheckedIn,
        currentDateTime,
      ];

  @override
  HomeScreenFailure copyWith({
    DateTime? currentDateTime,
    Failure? failure,
    UserLoginEntity? userProfile,
    bool? isCheckedIn,
  }) {
    return HomeScreenFailure(
      currentDateTime: currentDateTime ?? this.currentDateTime,
      userProfile: userProfile,
      failure: failure ?? this.failure,
      isCheckedIn: isCheckedIn ?? this.isCheckedIn,
    );
  }
}
