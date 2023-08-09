// ignore_for_file: unused_import

import 'dart:async';
import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
// import 'package:meta/meta.dart';

import '../../../controllers/firebase.auth.service.dart';
part 'sign_state.dart';
part 'sign_event.dart';

class SignBloc extends Bloc<SignEvent, SignState> {
  SignBloc() : super(SignInitial()) {
    // event handler was added
    on<SignEvent>((event, emit) async {
      await signUser(emit, event);
    });
  }

  signUser(Emitter<SignState> emit, SignEvent event) async {
    emit(SignLoading());
    try {
      if (event is SignFireBaseEvent) {
        if (event.displayName == "" ||
            event.email == "" ||
            event.password == "") {
          emit(SignFailure(error: "Không được để trống"));
        } else if (event.password.length < 6) {
          emit(SignFailure(error: "Mật khẩu ít nhất 6 ký tự"));
        } else {
          var chatUserSign = await AuthService().registerWithEmailAndPassword(
              event.email, event.password, event.displayName);
          if (chatUserSign != null) {
            await AuthService().updateUserName(event.displayName, chatUserSign);
            emit(SignSuccess(email: event.email));
          } else {
            emit(SignFailure(error: "Erorr"));
          }
        }
      }
    } catch (e) {
      emit(SignFailure(error: "Có lỗi xảy ra"));
    }
  }
}
