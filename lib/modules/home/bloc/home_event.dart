part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class GetPostsEvent extends HomeEvent {}

class UpPostsEvent extends HomeEvent {
  final String title;
  final String image;
  const UpPostsEvent({required this.title, required this.image});
}

class DeletePostsEvent extends HomeEvent {
  final String id;
  const DeletePostsEvent({required this.id});
}
