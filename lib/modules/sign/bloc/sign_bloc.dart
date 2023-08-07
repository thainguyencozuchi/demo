import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../controllers/firebase.auth.service.dart';
import '../../../models/user.login.dart';
part 'sign_state.dart';
part 'sign_event.dart';

class SignBloc extends Bloc<SignEvent, SignState> {
  SignBloc() : super(SignInitial());
  @override
  Stream<SignState> mapEventToState(
    SignEvent event,
  ) async* {
    if (event is SignFireBaseEvent) {
      yield SignLoadingState();
      UserLogin? user =
          await AuthService().registerWithEmailAndPassword(event.email, event.password);
      if (user != null) {
        yield SignFireBaseState(user: user);
      }else{
        print("SAi");
      }
      // Demo data = Demo(id: event.id, name: event.name);

    }
  }
}