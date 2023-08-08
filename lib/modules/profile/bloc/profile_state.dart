part of 'profile_bloc.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class GetProfieSuccess extends ProfileState {
  final UserLogin userLogin;

  const GetProfieSuccess({required this.userLogin});

  @override
  List<Object> get props => [userLogin];
}

class GetProfieFailure extends ProfileState {
  final String error;

  const GetProfieFailure({required this.error});

  @override
  List<Object> get props => [error];
}

class UpdateProfieSuccess extends ProfileState {}

class ChangePasswordSuccess extends ProfileState {}
