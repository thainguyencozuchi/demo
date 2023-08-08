// ignore_for_file: unused_import

import 'dart:async';
import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
// import 'package:meta/meta.dart';

import '../../../controllers/firebase.auth.service.dart';
import '../../../models/user.login.dart';
part 'profile_state.dart';
part 'profile_event.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitial()) {
    // event handler was added
    on<ProfileEvent>((event, emit) async {
      await profileUser(emit, event);
    });
  }

  profileUser(Emitter<ProfileState> emit, ProfileEvent event) async {
    emit(ProfileLoading());
    try {
      if (event is ProfileFireBaseEvent) {
        if (event.email == "" || event.password == "") {
          emit(ProfileFailure(error: "Không được để trống"));
        } else {
          User? user = await AuthService()
              .signInWithEmailAndPassword(event.email, event.password);
          if (user != null) {
            emit(ProfileSuccess(displayName: user.displayName ?? "User"));
          } else {
            emit(ProfileFailure(error: "Tài khoản mật khảu không đúng"));
          }
        }
      }
    } catch (e) {
      emit(ProfileFailure(error: "Có lỗi xảy ra"));
    }
  }
}
