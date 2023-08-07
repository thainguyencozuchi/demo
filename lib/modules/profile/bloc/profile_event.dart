part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class ProfileFireBaseEvent extends ProfileEvent {
  final String email;
  final String password;

  const ProfileFireBaseEvent(
      {required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}
