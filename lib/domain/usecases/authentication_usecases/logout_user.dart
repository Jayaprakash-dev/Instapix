import 'package:gallery/core/usecase/usecase.dart';
import 'package:gallery/domain/repos/local/authentication_datastore.dart';

class LogoutUserUseCase implements UseCase<bool, void> {

  final AuthenticationDatastore _authenticationDatastore;

  LogoutUserUseCase({
    required AuthenticationDatastore authenticationDatastore,
  }) : _authenticationDatastore = authenticationDatastore;

  @override
  Future<bool> call({void param}) async {
    return await _authenticationDatastore.logOut();
  }
}