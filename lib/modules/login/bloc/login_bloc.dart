// ignore_for_file: unused_import

import 'dart:async';
import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
// import 'package:meta/meta.dart';

import '../../../controllers/firebase.auth.service.dart';
part 'login_state.dart';
part 'login_event.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    // event handler was added
    on<LoginEvent>((event, emit) async {
      await loginUser(emit, event);
    });
  }

  loginUser(Emitter<LoginState> emit, LoginEvent event) async {
    emit(LoginLoading());
    try {
      if (event is LoginFireBaseEvent) {
        if (event.email == "" || event.password == "") {
          emit(LoginFailure(error: "Không được để trống"));
        } else {
          User? user = await AuthService()
              .signInWithEmailAndPassword(event.email, event.password);
          if (user != null) {
            emit(LoginSuccess(displayName: user.displayName ?? "User"));
          } else {
            emit(LoginFailure(error: "Tài khoản mật khảu không đúng"));
          }
        }
      } else if (event is AutoLogin) {
        var resultAutoLogin = await AuthService().autoSignIn();
        if (resultAutoLogin == true) {
          emit(AutoLoginSuccess());
        }else{
          emit(AutoLoginFail());
        }
      }
    } catch (e) {
      emit(LoginFailure(error: "Có lỗi xảy ra"));
    }
  }
}
