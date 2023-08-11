// ignore_for_file: unused_import
import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:demo/controllers/api.post.dart';
import 'package:demo/main.dart';
import 'package:demo/models/chat_user.dart';
import 'package:demo/models/posts.dart';
import 'package:demo/modules/chat/chat.card/chat.screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../controllers/firebase.auth.service.dart';
part 'home_state.dart';
part 'home_event.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    // event handler was added
    on<HomeEvent>((event, emit) async {
      await homeEventSelect(emit, event);
    });
  }

  homeEventSelect(Emitter<HomeState> emit, HomeEvent event) async {
    emit(HomeLoading());
    try {
      if (event is GetPostsEvent) {
        List<Posts> getDataPosts = await PostsService().getListPost();
        ChatUser? user = await AuthService().getCurrentUser();
        emit(GetPostsState(listPosts: getDataPosts, chatUser: user!));
      } else if (event is UpPostsEvent) {
        if (event.imageFile != null) {
          await FirebaseStorage.instance
              .ref('uploads/${event.imageName}')
              .putFile(event.imageFile!);
        }
        await PostsService()
            .addPosts(title: event.title, image: getUrlImage(event.imageName));
        List<Posts> getDataUp = await PostsService().getListPost();
        emit(UpPostsSucces(listPosts: getDataUp));
      } else if (event is DeletePostsEvent) {
        await PostsService().deletePosts(id: event.id);
        List<Posts> getData = await PostsService().getListPost();
        emit(DelPostsSucces(listPosts: getData));
      } 
    } catch (e) {
      emit(ErorrStatus(error: "Có lỗi xảy ra"));
    }
  }
}
