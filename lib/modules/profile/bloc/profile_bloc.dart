// ignore_for_file: unused_import

import 'dart:async';
import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:demo/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
// import 'package:meta/meta.dart';

import '../../../controllers/firebase.auth.service.dart';
import '../../../models/user.login.dart';
part 'profile_event.dart';
part 'profile_state.dart';

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
      if (event is GetProfieEvent) {
        User? user = AuthService().getCurrentUser();
        if (user != null) {
          UserLogin userLogin = UserLogin.convertUserAuth(user);
          emit(GetProfieSuccess(userLogin: userLogin));
        } else {
          emit(const GetProfieFailure(error: "User not found"));
        }
      } else if (event is UpdateProfieEvent) {
        if (event.displayName != "") {
          var updateName =
              await AuthService().updateUserName(event.displayName);
          var updateUrl = true;
          if (event.fileName != "") {
            updateUrl =
                await AuthService().updatePhotoUrl(getUrlImage(event.fileName));
          }
          if (updateUrl == true && updateName == true) {
            emit(UpdateProfieSuccess());
          } else {
            emit(const GetProfieFailure(error: "Erorr"));
          }
        } else {
          emit(const GetProfieFailure(error: "Ko được để trống"));
        }
      } else if (event is ChangePassEvent) {
        if (event.password == "" || event.rePassword == "") {
          emit(const GetProfieFailure(error: "Ko được để trống"));
        } else if (event.password.length < 6 || event.rePassword.length < 6) {
          emit(const GetProfieFailure(error: "Mật khẩu lớn hơn 6 ký tự"));
        } else if (event.password != event.rePassword) {
          emit(const GetProfieFailure(error: "Nhập lại không khớp"));
        } else {
          var updatePass =await AuthService().updateUserPassword(event.password);
          if (updatePass == true) {
            emit(ChangePasswordSuccess());
          } else {
            emit(const GetProfieFailure(error: "Đăng nhập lại để thực hiện"));
          }
        }
      }
    } catch (e) {
      emit(GetProfieFailure(error: e.toString()));
    }
  }
}
