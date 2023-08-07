part of 'sign_bloc.dart';

abstract class SignState extends Equatable {
  const SignState();

  @override
  List<Object> get props => [];
}

class SignInitial extends SignState {}

class SignLoading extends SignState {}

class SignSuccess extends SignState {
  final String userId;

  SignSuccess({required this.userId});

  @override
  List<Object> get props => [userId];
}

class SignFailure extends SignState {
  final String error;

  SignFailure({required this.error});

  @override
  List<Object> get props => [error];
}