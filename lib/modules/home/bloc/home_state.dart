part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class GetPostsState extends HomeState {
  final List<Posts> listPosts;
  final ChatUser chatUser;

  const GetPostsState({required this.listPosts, required this.chatUser});

  @override
  List<Object> get props => [listPosts, chatUser];
}

class ErorrStatus extends HomeState {
  final String error;
  const ErorrStatus({required this.error});
  @override
  List<Object> get props => [error];
}

class UpPostsSucces extends HomeState {
  final List<Posts> listPosts;

  const UpPostsSucces({required this.listPosts});

  @override
  List<Object> get props => [listPosts];
}

class DelPostsSucces extends HomeState {
    final List<Posts> listPosts;

  const DelPostsSucces({required this.listPosts});

  @override
  List<Object> get props => [listPosts];
}

class UpdateLikePostsSucces extends HomeState {
    final List<Posts> listPosts;
  const UpdateLikePostsSucces({required this.listPosts});
  @override
  List<Object> get props => [listPosts];
}
