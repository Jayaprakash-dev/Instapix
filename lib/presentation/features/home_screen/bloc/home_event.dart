part of 'home_bloc.dart';

@immutable
sealed class HomeEvent {}

final class HomeInitialEvent extends HomeEvent {}

final class AddPost extends HomeEvent {
  final Uint8List image;
  final String title;
  final String caption;

  AddPost({
    required this.image,
    required this.title,
    required this.caption
  });
}

final class GetAllPosts extends HomeEvent {}

class HomeNavigationEvent extends HomeEvent {}

final class NavigateToHomePage extends HomeEvent {}