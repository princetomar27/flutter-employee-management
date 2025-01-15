part of 'authentication_cubit.dart';

abstract class AuthenticationState extends Equatable {
  final String? userName;
  final String? password;
  const AuthenticationState({
    required this.userName,
    required this.password,
  });

  @override
  List<Object?> get props => [
        userName,
        password,
      ];

  // The copyWith method to update userName and password
  AuthenticationState copyWith({
    String? userName,
    String? password,
  });
}

class AuthenticationInitial extends AuthenticationState {
  AuthenticationInitial({required super.userName, required super.password});

  @override
  AuthenticationState copyWith({
    String? userName,
    String? password,
  }) {
    return AuthenticationInitial(
      userName: userName ?? this.userName,
      password: password ?? this.password,
    );
  }
}

class AuthenticationLoading extends AuthenticationState {
  AuthenticationLoading({required super.userName, required super.password});

  @override
  AuthenticationState copyWith({
    String? userName,
    String? password,
  }) {
    return AuthenticationLoading(
      userName: userName ?? this.userName,
      password: password ?? this.password,
    );
  }
}

class AuthenticationSuccess extends AuthenticationState {
  final UserLoginEntity user;

  const AuthenticationSuccess(
      {required super.userName, required super.password, required this.user});

  @override
  List<Object?> get props => [user, userName, password];

  @override
  AuthenticationState copyWith({
    String? userName,
    String? password,
    UserLoginEntity? user,
  }) {
    return AuthenticationSuccess(
      userName: userName ?? this.userName,
      password: password ?? this.password,
      user: user ?? this.user,
    );
  }
}

class AuthenticationFailure extends AuthenticationState {
  final Failure failure;

  const AuthenticationFailure(
      {required this.failure,
      required super.userName,
      required super.password});

  @override
  List<Object?> get props => [failure, userName, password];

  @override
  AuthenticationState copyWith({
    String? userName,
    String? password,
    Failure? failure,
  }) {
    return AuthenticationFailure(
      userName: userName ?? this.userName,
      password: password ?? this.password,
      failure: failure ?? this.failure,
    );
  }
}
