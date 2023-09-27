import 'package:gallery/core/data_state/auth_state.dart';

abstract interface class AuthenticationDatastore {

  Future<AuthDataState> register({required String name, required String emailId, required String password});

  Future<AuthDataState> logIn({String? name, String? emailId, required String password});

  Future<bool> logOut();

  Future<bool> isUsernameExists(String name);

  Future<bool> isUserMailExists(String mailId);
}