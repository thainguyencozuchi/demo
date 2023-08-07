// ignore_for_file: unused_import

import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
// import 'package:meta/meta.dart';

// import '../../../controllers/firebase.auth.service.dart';
// import '../../../models/user.login.dart';
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
        print("Đã vào đây");
        print(event.email);
        print(event.password);
      }
    await  Future.delayed(Duration(seconds: 2));
      emit(SignSuccess(userId: '123123123'));
    } catch (e) {}
  }
}




//   Stream<SignState> mapEventToState(
//     SignEvent event,
//   ) async* {
//     if (event is SignFireBaseEvent) {
     
//       yield SignLoading();

//       try {
//         // UserLogin? user =
//         //     await AuthService().registerWithEmailAndPassword(event.email, event.password);
//         // if (user != null) {
//         //   yield SignFireBaseState(user: user);
//         // }else{
//         //   print("Sai");
//         // }
//         // Demo data = Demo(id: event.id, name: event.name);

//         yield SignSuccess(userId: "userCredential.user!.uid");
//       } catch (e) {
//         yield SignFailure(error: e.toString());
//       }
//     }
//   }
// }
