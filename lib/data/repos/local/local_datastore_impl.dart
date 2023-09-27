import 'dart:typed_data';

import 'package:gallery/core/data_state/data_state.dart';
import 'package:gallery/data/models/image.dart';
import 'package:gallery/domain/entities/post.dart';
import 'package:gallery/domain/repos/local/local_datastore.dart';
import 'package:sqflite/sqflite.dart';

class LocalDatastoreImpl implements LocalDatastore {

  final Database _db;

  LocalDatastoreImpl({
    required Database db,
  }): _db = db;

  @override
  Future<DataState> addPost(Map<String, dynamic> post) async {
    try {
      final Map<String, Object?> data = {
        'photo': post['image'],
        'title': post['title'],
        'caption': post['caption'],
      };

      await _db.insert(
        'posts',
        data,
        conflictAlgorithm: ConflictAlgorithm.abort
      );

      return DataSuccessState();
      
    } on DatabaseException catch (e) {
      return DataExceptionState(exception: e);
    } on Exception catch (e) {
      return DataExceptionState(exception: e);
    } 
  }

  @override
  Future<DataState<List<PostEntity>>> getAll() async {
    try {

      final List<Map<String, Object?>> res = await _db.query('posts');

      final List<PostEntity> posts = [];
      for (Map<String, Object?> post in res) {
        posts.add(
          PostModel(
            id: post['image_id'] as int,
            imageBytesData: post['photo'] as Uint8List,
            title: post['title'] as String,
            caption: post['caption'] as String
          )
        );
      }

      return DataSuccessState(data: posts);

    } on DatabaseException catch (e) {
      print(e);
      return DataExceptionState(exception: e);
    } on Exception catch (e) {
      return DataExceptionState(exception: e);
    } 
  }

  @override
  Future<DataState> removeAll() {
    throw UnimplementedError();
  }

  @override
  Future<DataState> removeImage(int id) {
    throw UnimplementedError();
  }
}