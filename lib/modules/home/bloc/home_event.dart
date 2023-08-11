part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class GetPostsEvent extends HomeEvent {}

class UpPostsEvent extends HomeEvent {
  final String title;
  final String imageName;
  final File? imageFile;
  const UpPostsEvent({required this.title, required this.imageName, this.imageFile});
}

class DeletePostsEvent extends HomeEvent {
  final String id;
  const DeletePostsEvent({required this.id});
}

class UpdateLikePostsEvent extends HomeEvent {
  final String id;
  final List<String> listLike;
  const UpdateLikePostsEvent({required this.id, required this.listLike});
}

