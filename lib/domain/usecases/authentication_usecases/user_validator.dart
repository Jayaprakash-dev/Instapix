import 'package:gallery/core/usecase/usecase.dart';
import 'package:gallery/domain/repos/local/authentication_datastore.dart';

class UserValidatorUseCase implements UseCase<bool, String> {

  final AuthenticationDatastore _authenticationDatastore;

  UserValidatorUseCase({
    required AuthenticationDatastore authenticationDatastore,
  }) : _authenticationDatastore = authenticationDatastore;

  @override
  Future<bool> call({String? param}) async {
    if (param!.contains('@')) {
      return await _authenticationDatastore.isUserMailExists(param);
    }

    return await _authenticationDatastore.isUsernameExists(param);
  }
}