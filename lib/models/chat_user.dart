class ChatUser {
  ChatUser({required this.image, required this.about, required this.name, required this.createdAt, required this.isOnline, required this.id, required this.lastActive, required this.email, required this.phone, required this.pushToken, required this.background, required this.birth});
  late String image;
  late String about;
  late String name;
  late String createdAt;
  late bool isOnline;
  late String id;
  late String lastActive;
  late String email;
  late String birth;
  late String phone;
  late String pushToken;
  late String background;

  ChatUser.fromJson(Map<String, dynamic> json) {
    image = (json['image'] != "null") ? json['image'] ?? "" : '';
    about = json['about'] ?? '';
    name = json['name'] ?? '';
    createdAt = json['created_at'] ?? '';
    isOnline = json['is_online'] ?? '';
    id = json['id'] ?? '';
    lastActive = json['last_active'] ?? '';
    email = json['email'] ?? '';
    phone = (json['phone'] != null && json['phone'] != "null") ? json['phone'] : '';
    birth = (json['birth'] != null && json['birth'] != "null") ? json['birth'] : '';
    pushToken = json['push_token'] ?? '';
    background = json['background'] ?? '';
  }

  get uid => null;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['image'] = image;
    data['about'] = about;
    data['name'] = name;
    data['created_at'] = createdAt;
    data['is_online'] = isOnline;
    data['id'] = id;
    data['last_active'] = lastActive;
    data['email'] = email;
    data['phone'] = phone;
    data['birth'] = birth;
    data['push_token'] = pushToken;
    data['background'] = background;
    return data;
  }
}
