import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gallery/domain/usecases/authentication_usecases/login_user.dart';
import 'package:gallery/domain/usecases/authentication_usecases/logout_user.dart';
import 'package:gallery/domain/usecases/authentication_usecases/register_user.dart';
import 'package:gallery/service_locator.dart';
import 'package:meta/meta.dart';
import 'package:gallery/core/data_state/auth_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {

  final RegisterUserUseCase _registerUserUseCase;
  final LoginUserUseCase _loginUserUseCase;
  final LogoutUserUseCase _logoutUserUseCase;

  AuthBloc({
    required RegisterUserUseCase registerUserUseCase,
    required LoginUserUseCase loginUserUseCase,
    required LogoutUserUseCase logoutUserUseCase,
  }) : _registerUserUseCase = registerUserUseCase,
  _loginUserUseCase = loginUserUseCase,
  _logoutUserUseCase = logoutUserUseCase,
  super(AppInitialState()) {
    on<AppStarted>(appStartedEventHandler);
    on<AuthRegistrationRequest>(authRegistrationRequestHandler);
    on<AuthLogInRequest>(authLogInRequestHandler);
    on<AuthSuccessEvent>(authSuccessEventHandler);
    on<UserLogOutRequest>(userLogOutRequestHandler);

    // navigation event handlers
    on<AuthNavigateToSignUpEvent>(authNavigateToSignUpEventHandler);
    on<AuthNavigateToLogInEvent>(authNavigateToLogInEventHandler);
  }

  FutureOr<void> appStartedEventHandler(AppStarted event, Emitter<AuthState> emit) {
    
    final bool? userLogInStatus = services<SharedPreferences>().getBool('userLoginStatus');

    if (userLogInStatus != null && userLogInStatus) {
      emit(UserAuthenticated());
    } else {
      emit(UnAuthenticatedSignUp());
    }
  }

  FutureOr<void> authRegistrationRequestHandler(AuthRegistrationRequest event, Emitter<AuthState> emit) async {
    emit(RegisteringUser(status: false));

    final Map<String, String> data = {
      'name': event.username!,
      'emailId': event.mailId!,
      'password': event.password!,
    };

    final AuthDataState res = await _registerUserUseCase(param: data);

    await Future.delayed(const Duration(seconds: 1));
    
    if (res is AuthDataSuccessState) {
      emit(RegisteringUser(status: true));
    } else {
      emit(UserRegistrationException((res as AuthDataExceptionState).exception));
    }
  }

  FutureOr<void> authLogInRequestHandler(AuthLogInRequest event, Emitter<AuthState> emit) async {
    final Map<String, String?> data = {
      'name': event.username,
      'emailId': event.mailId,
      'password': event.password!,
    };

    final AuthDataState res = await _loginUserUseCase(param: data);

    if (res is AuthDataSuccessState) {
      emit(UserAuthenticated());
    } else if (res is UserNotFoundException) {
      emit(UserLogInException(
        errorMsg: StringBuffer('The credentials you entered doesn\'t appear to belong to an account. Please check your username and try again.'),
        exception: res.exception
      ));
    } else if (res is UserCredentialsException) {
      emit(UserLogInException(errorMsg: StringBuffer('Incorrect credentials'), exception: res.exception));
    } else {
      emit(UserLogInException(errorMsg: StringBuffer('Something went wrong. Please, Try again'), exception: (res as AuthDataExceptionState).exception));
    }
  }

  FutureOr<void> authSuccessEventHandler(AuthSuccessEvent event, Emitter<AuthState> emit) {
    emit(UserAuthenticated());
  }

  FutureOr<void> userLogOutRequestHandler(UserLogOutRequest event, Emitter<AuthState> emit) async {
    await _logoutUserUseCase();
    emit(UserLoggedOut());
  }

  FutureOr<void> authNavigateToSignUpEventHandler(AuthNavigateToSignUpEvent event, Emitter<AuthState> emit) {
    emit(UnAuthenticatedSignUp());
  }

  FutureOr<void> authNavigateToLogInEventHandler(AuthNavigateToLogInEvent event, Emitter<AuthState> emit) {
    emit(UnAuthenticatedLogIn());
  }
}
