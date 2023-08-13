// ignore_for_file: must_be_immutable

part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class GetProfieEvent extends ProfileEvent {}

class UpdateProfieEvent extends ProfileEvent {
  File? avatarFile;
  File? bacnkgroundFile;
  final String name;
  final String avatarName;
  final String bacnkgroundName;
  final String phoneNumber;
  final String birth;
  final String about;
  final ChatUser chatUser;

  UpdateProfieEvent({
    this.avatarFile,
    this.bacnkgroundFile,
    required this.avatarName,
    required this.name,
    required this.bacnkgroundName,
    required this.phoneNumber,
    required this.birth,
    required this.about,
    required this.chatUser,
  });
}

class ChangePassEvent extends ProfileEvent {
  final password;
  final String rePassword;
  final ChatUser chatUser;

  const ChangePassEvent({required this.password, required this.rePassword, required this.chatUser});
  @override
  List<Object> get props => [password, rePassword];
}
