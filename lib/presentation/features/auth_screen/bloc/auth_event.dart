part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent extends Equatable {
  final String? username;
  final String? mailId;
  final String? password;

  const AuthEvent({
    this.username,
    this.mailId,
    this.password
  });

  @override
  List<Object> get props => [];
}

final class AppStarted extends AuthEvent {}

final class AuthRegistrationRequest extends AuthEvent {

  const AuthRegistrationRequest({
    String? username,
    String? mailId,
    String? password,
  }) : super(
    username: username,
    mailId: mailId,
    password: password
  );
}

final class AuthLogInRequest extends AuthEvent {

  const AuthLogInRequest({
    String? username,
    String? mailId,
    String? password,
  }) : super(
    username: username,
    mailId: mailId,
    password: password
  );
}

final class UserLogOutRequest extends AuthEvent {}

final class AuthSuccessEvent extends AuthEvent {}


// navigation event
class AuthNavigationEvent extends AuthEvent {}

class AuthNavigateToSignUpEvent extends AuthNavigationEvent {}

class AuthNavigateToLogInEvent extends AuthNavigationEvent {}