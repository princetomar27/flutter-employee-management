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
      currentDateTime: DateTime.now(),
      userProfile: null,
      isCheckedIn: false,
    );
  }

  @override
  List<Object?> get props => [currentDateTime];
}

class HomeScreenInitial extends HomeScreenState {
  HomeScreenInitial()
      : super(
          currentDateTime: DateTime.now(),
          userProfile: null,
          isCheckedIn: false,
        );

  @override
  HomeScreenState copyWith({
    DateTime? currentDateTime,
    UserLoginEntity? userProfile,
    bool? isCheckedIn,
  }) {
    return HomeScreenInitial();
  }
}

class HomeScreenLoading extends HomeScreenState {
  final DateTime timestamp;

  HomeScreenLoading(this.timestamp)
      : super(
          currentDateTime: DateTime.now(),
          userProfile: null,
          isCheckedIn: false,
        );

  @override
  HomeScreenState copyWith({
    DateTime? currentDateTime,
    UserLoginEntity? userProfile,
    bool? isCheckedIn,
  }) {
    return HomeScreenLoading(
      timestamp,
    );
  }
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
  List<Object?> get props => super.props..add(location);

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
  final String message;

  const HomeScreenFailure({
    required DateTime currentDateTime,
    UserLoginEntity? userProfile,
    required this.message,
    required bool isCheckedIn,
  }) : super(
          currentDateTime: currentDateTime,
          userProfile: userProfile,
          isCheckedIn: isCheckedIn,
        );

  @override
  List<Object?> get props => super.props..add(message);

  @override
  HomeScreenFailure copyWith({
    DateTime? currentDateTime,
    String? message,
    UserLoginEntity? userProfile,
    bool? isCheckedIn,
  }) {
    return HomeScreenFailure(
      currentDateTime: currentDateTime ?? this.currentDateTime,
      userProfile: userProfile,
      message: message ?? this.message,
      isCheckedIn: isCheckedIn ?? this.isCheckedIn,
    );
  }
}
