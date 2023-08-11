import 'package:demo/models/chat_user.dart';

class Posts {
  Posts({
    required this.id,
    required this.uid,
    required this.createdAt,
    required this.title,
    required this.image,
    required this.listLike,
    this.userUp,
  });
  late String id;
  late String uid;
  late String createdAt;
  late String title;
  late String image;
  ChatUser? userUp;
  late List<String> listLike;

  Posts.fromJson(Map<String, dynamic> json) {
    image = (json['image'] != "null") ? json['image'] ?? "" : '';
    uid = json['uid'] ?? '';
    createdAt = json['created_at'] ?? '';
    title = json['title'] ?? '';
    id = json['id'] ?? '';
    listLike = [];
    if (json['list_like'] != null && json['list_like'].length > 0) {
      for (var element in json['list_like']) {
        listLike.add(element.toString());
      }
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['image'] = image;
    data['uid'] = uid;
    data['title'] = title;
    data['created_at'] = createdAt;
    data['list_like'] = listLike;
    data['id'] = id;
    return data;
  }
}
