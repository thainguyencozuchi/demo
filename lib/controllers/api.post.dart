import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/models/chat_user.dart';
import 'package:demo/models/posts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class PostsService {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static FirebaseAuth _auth = FirebaseAuth.instance;

  // for accessing firebase storage
  static FirebaseStorage storage = FirebaseStorage.instance;

  static User get user => _auth.currentUser!;

  Future<List<Posts>> getListPost() async {
    List<Posts> data = [];
    var result = await firestore.collection('posts').get();
    for (var element in result.docs) {
      var resultElement =
          await firestore.collection("posts").doc(element.id).get();
      Posts dataConvert = Posts.fromJson(resultElement.data()!);

      var userUp =
          await firestore.collection('users').doc(dataConvert.uid).get();
      ChatUser userUpConvert = ChatUser.fromJson(userUp.data()!);
      dataConvert.userUp = userUpConvert;
      data.insert(0, dataConvert);
    }
    return data;
  }

  Future<void> addPosts({required String title, required String image}) async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    final putPost = Posts(
        id: time,
        createdAt: time,
        image: image,
        listLike: [],
        title: title,
        uid: user.uid);
    return await firestore.collection('posts').doc(time).set(putPost.toJson());
  }

  Future<void> deletePosts({required String id}) async {
    return await firestore.collection('posts').doc(id).delete();
  }

  Future<void> updateLikePosts({required Posts post}) async {
    print("${{'list_like': post.listLike}}");
    return await firestore
        .collection('posts')
        .doc(post.id)
        .update({'list_like': post.listLike});
  }
}
