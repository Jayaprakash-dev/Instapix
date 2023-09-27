class PostEntity {

  final int _id;

  final String _imagePath;
  final String _title;
  final String _caption;

  PostEntity({
    required int id,
    required String imagePath,
    required String title,
    required String caption,
  }): _id = id, _imagePath = imagePath, _title = title, _caption = caption;

  int get id => _id;

  String get title => _title;

  String get caption => _caption;

  String get imagePath => _imagePath;
}