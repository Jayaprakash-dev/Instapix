// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:io';

import 'package:gallery/core/data_state/data_state.dart';
import 'package:gallery/data/models/image.dart';
import 'package:gallery/domain/entities/post.dart';
import 'package:gallery/domain/repos/local/local_datastore.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class LocalDatastoreImpl implements LocalDatastore {

  final Database _db;

  LocalDatastoreImpl({
    required Database db,
  }): _db = db;

  @override
  Future<DataState> addPost(Map<String, dynamic> post) async {
    try {

      final String title = post['title'];
      final String caption = post['caption'];

      final File _imgFile = post['image'] as File;
      final String _imgFileName = _imgFile.path.split('/').last;

      final Directory directory = await getApplicationDocumentsDirectory();
      final String _imagePath = '${directory.path}/$_imgFileName';

      await _imgFile.copy(_imagePath); // copying image to new path

      final Map<String, Object?> data = {
        'image': _imagePath,
        'title': title,
        'caption': caption,
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
            imagePath: post['image'] as String,
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