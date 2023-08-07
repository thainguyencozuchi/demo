// ignore_for_file: prefer_const_constructors_in_immutables

part of 'sign_bloc.dart';

abstract class SignState extends Equatable {
  const SignState();

  @override
  List<Object> get props => [];
}

class SignInitial extends SignState {}

class SignLoading extends SignState {}

class SignSuccess extends SignState {
  final String email;

  SignSuccess({required this.email});

  @override
  List<Object> get props => [email];
}

class SignFailure extends SignState {
  final String error;

  SignFailure({required this.error});

  @override
  List<Object> get props => [error];
}