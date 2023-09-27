import 'package:gallery/core/data_state/auth_state.dart';
import 'package:gallery/core/usecase/usecase.dart';
import 'package:gallery/domain/repos/local/authentication_datastore.dart';

class RegisterUserUseCase implements UseCase<AuthDataState, Map<String, String>> {

  final AuthenticationDatastore _authenticationDatastore;

  RegisterUserUseCase({
    required AuthenticationDatastore authenticationDatastore,
  }) : _authenticationDatastore = authenticationDatastore;

  @override
  Future<AuthDataState> call({Map<String, String>? param}) async {
    return await _authenticationDatastore.register(
      name: param!['name']!, emailId: param['emailId']!, password: param['password']!);
  }
}