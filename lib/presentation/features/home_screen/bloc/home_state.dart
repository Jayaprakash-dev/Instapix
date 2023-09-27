part of 'home_bloc.dart';

@immutable
sealed class HomeState extends Equatable {
  final List<PostEntity>? posts;

  const HomeState({
    this.posts
  });

  @override
  List<Object?> get props => [ posts ];
}

final class HomeInitial extends HomeState {}

final class HomeSuccessState extends HomeState {
  const HomeSuccessState({
    List<PostEntity>? posts,
  }) : super(posts: posts);
}

final class HomeNoDataFound extends HomeState {}

final class HomeExceptionState extends HomeState {
  final Exception exception;

  const HomeExceptionState(this.exception);
}