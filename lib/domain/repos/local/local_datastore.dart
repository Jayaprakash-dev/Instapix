import 'package:gallery/core/data_state/data_state.dart';
import 'package:gallery/domain/entities/post.dart';

abstract interface class LocalDatastore {
  Future<DataState<List<PostEntity>>> getAll();

  Future<DataState> addPost(Map<String, dynamic> post);

  Future<DataState> removeImage(int id);

  Future<DataState> removeAll();
}