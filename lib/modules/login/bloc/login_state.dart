part of 'login_bloc.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final String displayName;

  const LoginSuccess({required this.displayName});

  @override
  List<Object> get props => [displayName];
}

class LoginFailure extends LoginState {
  final String error;

  const LoginFailure({required this.error});

  @override
  List<Object> get props => [error];
}

class AutoLoginSuccess extends LoginState{}
class AutoLoginFail extends LoginState{}

