part of 'auth_bloc.dart';

@immutable
sealed class AuthState extends Equatable {
  @override
  List<Object> get props => [];
}

final class AppInitialState extends AuthState {}

final class UnAuthenticatedLogIn extends AuthState {}

final class UnAuthenticatedSignUp extends AuthState {}

final class RegisteringUser extends AuthState {
  final bool status;

  RegisteringUser({
    required this.status,
  });

  @override
  List<Object> get props => [ status ];
}

final class UserAuthenticated extends AuthState {}

final class UserLoggedOut extends AuthState {}

// exceptions
final class AuthException extends AuthState {
  final Exception? exception;

  AuthException(this.exception);
}

final class UserRegistrationException extends AuthException {
  UserRegistrationException(Exception? exception) : super(exception);
}

final class UserLogInException extends AuthException {
  final StringBuffer errorMsg;

  UserLogInException({
    required this.errorMsg,
    Exception? exception,
  }) : super(exception) ;

  @override
  List<Object> get props => [ errorMsg ];
}