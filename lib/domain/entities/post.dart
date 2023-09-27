import 'package:flutter/services.dart';

class PostEntity {

  final int _id;

  final Uint8List _imageBytesData;
  final String _title;
  final String _caption;

  PostEntity({
    required int id,
    required Uint8List imageBytesData,
    required String title,
    required String caption,
  }): _id = id, _imageBytesData = imageBytesData, _title = title, _caption = caption;

  int get id => _id;

  String get title => _title;

  String get caption => _caption;

  Uint8List get imageBytesData => _imageBytesData;
}