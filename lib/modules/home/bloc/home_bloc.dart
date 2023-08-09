// ignore_for_file: unused_import
import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:demo/models/posts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../controllers/firebase.auth.service.dart';
part 'home_state.dart';
part 'home_event.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    // event handler was added
    on<HomeEvent>((event, emit) async {
      await homeUser(emit, event);
    });
  }

  homeUser(Emitter<HomeState> emit, HomeEvent event) async {
    emit(HomeLoading());
    try {
      if (event is GetPostsEvent) {
        await Future.delayed(Duration(seconds: 1));
        emit(GetPostsState(listPosts: [
          Posts(
              id: "1",
              uid: "uid1",
              createdAt: "createdAt",
              title: "title",
              image: "",
              listLike: []),
          Posts(
              id: "2",
              uid: "uid2",
              createdAt: "createdAt",
              title: "title",
              image: "",
              listLike: []),
          Posts(
              id: "3",
              uid: "uid3",
              createdAt: "createdAt",
              title: "title",
              image: "",
              listLike: []),
          Posts(
              id: "4",
              uid: "uid4",
              createdAt: "createdAt",
              title: "title",
              image: "",
              listLike: []),
          Posts(
              id: "5",
              uid: "uid5",
              createdAt: "createdAt",
              title: "title",
              image: "",
              listLike: []),
          Posts(
              id: "5",
              uid: "uid6",
              createdAt: "createdAt",
              title: "title",
              image: "",
              listLike: []),
        ]));
      }
    } catch (e) {
      emit(ErorrStatus(error: "Có lỗi xảy ra"));
    }
  }
}
