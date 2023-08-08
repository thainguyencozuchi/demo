part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class GetProfieEvent extends ProfileEvent {}

class UpdateProfieEvent extends ProfileEvent {
  final String fileName;
  final String displayName;

  const UpdateProfieEvent({required this.fileName, required this.displayName});
  @override
  List<Object> get props => [fileName, displayName];
}

class ChangePassEvent extends ProfileEvent {
  final String password;
  final String rePassword;

  const ChangePassEvent({required this.password, required this.rePassword});
  @override
  List<Object> get props => [password, rePassword];
}
