import 'package:gallery/core/data_state/data_state.dart';
import 'package:gallery/core/usecase/usecase.dart';
import 'package:gallery/domain/repos/local/local_datastore.dart';

class AddPostUseCase implements UseCase<DataState, Map<String, dynamic>> {

  final LocalDatastore _localDatastore;

  AddPostUseCase({
    required LocalDatastore localDatastore,
  }) : _localDatastore = localDatastore;

  @override
  Future<DataState> call({Map<String, dynamic>? param}) async {
    return await _localDatastore.addPost(param!);
  }
}