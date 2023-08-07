part of 'sign_bloc.dart';

@immutable


abstract class SignState extends Equatable {
   const SignState();

  @override
   List<Object> get props => [];
}

class SignInitial extends SignState {}

class SignLoadingState extends SignState {}

class SignFireBaseState extends SignState {
  final UserLogin user;
  const SignFireBaseState({required this.user});
}