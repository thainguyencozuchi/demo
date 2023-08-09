import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/models/posts.dart';
import 'package:firebase_storage/firebase_storage.dart';

class PostsService {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  // for accessing firebase storage
  static FirebaseStorage storage = FirebaseStorage.instance;

  Future<List<Posts>> getListPost() async {
    List<Posts> data = [];

    return data;
  }

  static Future<void> addPosts(
      {required String id,
      required String uid,
      required String title,
      required String image}) async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    final chatUser = Posts(
      id: id,
      createdAt: time,
      image: image,
      listLike: [],
      title: title,
      uid: uid,
    );
    return await firestore.collection('posts').doc(id).set(chatUser.toJson());
  }
}
