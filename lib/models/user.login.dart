import 'package:firebase_auth/firebase_auth.dart';

class UserLogin {
  String? uid;
  String? email;
  String? displayName;
  String? photoURL;

  UserLogin({this.uid, this.email, this.displayName, this.photoURL});

  UserLogin.convertUserAuth(User user) {
    uid = user.uid;
    email = user.email ?? "";
    displayName = user.displayName ?? "";
    photoURL = user.photoURL ?? "";
  }
}
