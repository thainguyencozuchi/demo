part of 'sign_bloc.dart';

abstract class SignEvent extends Equatable {
  const SignEvent();

  @override
  List<Object> get props => [];
}

class SignFireBaseEvent extends SignEvent {
  final String email;
  final String password;

  SignFireBaseEvent({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}
