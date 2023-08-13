// ignore_for_file: unused_import

import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:demo/common/exeption/check.dart';
import 'package:demo/main.dart';
import 'package:demo/models/chat_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
// import 'package:meta/meta.dart';

import '../../../controllers/api.dart';
import '../../../controllers/firebase.auth.service.dart';
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
        ChatUser? user = await AuthService().getCurrentUser();
        if (user != null) {
          emit(GetProfieSuccess(chatUser: user));
        } else {
          emit(const GetProfieFailure(error: "User not found"));
        }
      } else if (event is UpdateProfieEvent) {
        if (event.name != "") {
          if (event.phoneNumber != "") {
            bool isphone = isPhoneNumber(event.phoneNumber);
            if (isphone) {
              if (event.avatarFile != null) {
                await FirebaseStorage.instance.ref('uploads/${event.avatarName}').putFile(event.avatarFile!);
                event.chatUser.image = getUrlImage(event.avatarName);
              }
              if (event.bacnkgroundFile != null) {
                await FirebaseStorage.instance.ref('uploads/${event.bacnkgroundName}').putFile(event.bacnkgroundFile!);
                event.chatUser.background = getUrlImage(event.bacnkgroundName);
              }
              event.chatUser.about = event.about;
              event.chatUser.name = event.name;
              event.chatUser.phone = event.phoneNumber;
              var checkUpdate = await AuthService().updateAll(event.chatUser);
              if (checkUpdate == true) {
                emit(UpdateProfieSuccess());
              } else {
                emit(const GetProfieFailure(error: "Erorr"));
              }
            } else {
              emit(const GetProfieFailure(error: "Số điện thoại không đúng định dạng"));
            }
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
          var updatePass = await AuthService().updateUserPassword(event.password);
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
