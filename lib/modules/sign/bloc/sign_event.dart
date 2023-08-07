part of 'sign_bloc.dart';

@immutable
abstract class SignEvent extends Equatable {
  const SignEvent();

  @override
  List<Object> get props => [];
}

class SignFireBaseEvent extends SignEvent {
  final String email;
  final String password;
  const SignFireBaseEvent({required this.email,required this.password});
}