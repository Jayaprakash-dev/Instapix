base class AuthDataState {}

final class AuthDataSuccessState extends AuthDataState {}

final class AuthDataExceptionState extends AuthDataState {
  final Exception? exception;
  AuthDataExceptionState(this.exception);
}

final class UserCredentialsException extends AuthDataExceptionState {
  UserCredentialsException(Exception? exception) : super(exception);
}

final class UserNameAlreadyExistsException extends AuthDataExceptionState {
  UserNameAlreadyExistsException(Exception? exception) : super(exception);
}

final class UserMailAlreadyExistsException extends AuthDataExceptionState {
  UserMailAlreadyExistsException(Exception? exception) : super(exception);
}

final class UserNotFoundException extends AuthDataExceptionState {
  UserNotFoundException(Exception? exception): super(exception);
}