import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gallery/core/data_state/data_state.dart';
import 'package:gallery/domain/entities/post.dart';
import 'package:gallery/domain/usecases/data_usecases/add_post.dart';
import 'package:gallery/domain/usecases/data_usecases/get_all_post.dart';
import 'package:meta/meta.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {

  final AddPostUseCase _addPostUseCase;
  final GetAllPostsUseCase _getAllPostssUseCase;

  HomeBloc({
    required AddPostUseCase addPostUseCase,
    required GetAllPostsUseCase getAllPostsUseCase
  }) : _addPostUseCase = addPostUseCase, _getAllPostssUseCase = getAllPostsUseCase,
  super(HomeInitial()) {
    on<HomeInitialEvent>(homeInitialEventHandler);
    on<GetAllPosts>(homeInitialEventHandler);
    on<AddPost>(addPostEventHandler);

    // navigation event handlers
    on<NavigateToHomePage>(navigateToHomePageEventHandler);
  }

  FutureOr<void> homeInitialEventHandler(HomeEvent event, Emitter<HomeState> emit) async {
    emit(HomeInitial());

    final DataState<List<PostEntity>> res = await _getAllPostssUseCase();


    if (res is DataSuccessState && res.data!.isNotEmpty) {
      emit(HomeSuccessState(posts: res.data));
    } else if (res is DataSuccessState && res.data!.isEmpty) {
      emit(HomeNoDataFound());
    } else {
      emit(HomeExceptionState(res.exception!));
    }
  }

  FutureOr<void> addPostEventHandler(AddPost event, Emitter<HomeState> emit) async {
    final Map<String, dynamic> data = {
      'image': event.image,
      'title': event.title,
      'caption': event.caption
    };

    final DataState res = await _addPostUseCase(param: data);

    if (res is DataExceptionState) {
      // ignore: avoid_print
      print(res.exception);
    }

    add(GetAllPosts());
  }

  FutureOr<void> navigateToHomePageEventHandler(NavigateToHomePage event, Emitter<HomeState> emit) {
    emit(HomeSuccessState(posts: state.posts ?? []));
  }
}
