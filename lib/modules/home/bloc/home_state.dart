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

  const GetPostsState({required this.listPosts});

  @override
  List<Object> get props => [listPosts];
}
class ErorrStatus extends HomeState {
  final String error;
  const ErorrStatus({required this.error});
  @override
  List<Object> get props => [error];
}

