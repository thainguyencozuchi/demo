class Posts {
  Posts({
    required this.id,
    required this.uid,
    required this.createdAt,
    required this.title,
    required this.image,
    required this.listLike,
  });
  late String id;
  late String uid;
  late String createdAt;
  late String title;
  late String image;
  late List<String> listLike;

  Posts.fromJson(Map<String, dynamic> json) {
    image = (json['image'] != "null") ? json['image'] ?? "" : '';
    uid = json['uid'] ?? '';
    createdAt = json['created_at'] ?? '';
    title = json['title'] ?? '';
    id = json['id'] ?? '';
    listLike = json['last_active'] ?? [];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['image'] = image;
    data['uid'] = uid;
    data['title'] = title;
    data['created_at'] = createdAt;
    data['listLike'] = listLike;
    data['id'] = id;
    return data;
  }
}
