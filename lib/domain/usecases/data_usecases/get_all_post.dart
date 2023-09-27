import 'package:gallery/core/data_state/data_state.dart';
import 'package:gallery/core/usecase/usecase.dart';
import 'package:gallery/domain/entities/post.dart';
import 'package:gallery/domain/repos/local/local_datastore.dart';

class GetAllPostsUseCase implements UseCase<DataState<List<PostEntity>>, void> {

  final LocalDatastore _localDatastore;

  GetAllPostsUseCase({
    required localDatastore
  }): _localDatastore = localDatastore;
  
  @override
  Future<DataState<List<PostEntity>>> call({void param}) async {
    return await _localDatastore.getAll();
  }
}