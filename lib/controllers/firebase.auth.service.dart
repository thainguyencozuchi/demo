import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/chat_user.dart';
import 'api.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  //Lưu token
  Future<void> saveAccessTokenToPrefs(String email, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('email', email);
    prefs.setString('password', password);
  }

  //Tự động đăng nhập
  Future<bool> autoSignIn() async {
    bool result = false;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('email');
    String? password = prefs.getString('password');
    if (password != null && email != null) {
      try {
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        User? user = userCredential.user;
        if (user != null) {
          result = true;
        }
      } catch (e) {
        print("Erorr: ${e}");
      }
    }
    return result;
  }

  // Tạo đối tượng User từ UserCredential
  User? _userFromFirebaseUser(UserCredential userCredential) {
    return userCredential.user;
  }

  // Đăng ký người dùng với email và mật khẩu
  Future<ChatUser?> registerWithEmailAndPassword(String email, String password, String fullName) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = _userFromFirebaseUser(userCredential);
      if (user != null) {
        final time = DateTime.now().millisecondsSinceEpoch.toString();
        final chatUser = ChatUser(id: user.uid, name: user.displayName.toString(), email: user.email.toString(), about: "Hey, QH12", image: user.photoURL.toString(), createdAt: time, isOnline: false, lastActive: time, pushToken: '', background: '', phone: '', birth: '');
        await firestore.collection('users').doc(user.uid).set(chatUser.toJson());
        return chatUser;
      }
      return null;
    } catch (e) {
      print("Error during registration: $e");
      return null;
    }
  }

  // Đăng nhập với email và mật khẩu
  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user != null) {
        String? accessToken = await userCredential.user!.getIdToken(); // Lấy token truy cập
        if (accessToken != null) {
          await saveAccessTokenToPrefs(email, password); // Lưu vào SharedPreferences
        }
      }
      return _userFromFirebaseUser(userCredential);
    } catch (e) {
      print("Error during login: $e");
      return null;
    }
  }

  // Đăng xuất người dùng
  Future<void> signOut() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('email');
      await prefs.remove('password');
      await _auth.signOut();
    } catch (e) {
      print("Error during sign out: $e");
    }
  }

  // Kiểm tra trạng thái đăng nhập hiện tại
  Future<ChatUser?> getCurrentUser() async {
    try {
      if (_auth.currentUser != null) {
        var result = await firestore.collection('users').doc(_auth.currentUser!.uid).get();
        if (result.exists) {
          ChatUser chatUser = ChatUser.fromJson(result.data()!);
          APIs.updateActiveStatus(true);
          return chatUser;
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  // Stream để theo dõi trạng thái đăng nhập của người dùng
  Stream<User?> authStateChanges() {
    return _auth.authStateChanges();
  }

  // Cập nhật thông tin người dùng (ví dụ: email)
  Future<bool> updateUserEmail(String newEmail, ChatUser chatUser) async {
    try {
      if (_auth.currentUser != null) {
        await _auth.currentUser!.updateEmail(newEmail);
        await firestore.collection('users').doc(chatUser.id).update({'email': newEmail});
        return true;
      }
      return false;
    } catch (e) {
      print("Error updating user email: $e");
      return false;
    }
  }

  // Cập nhật mật khẩu người dùng
  Future<bool> updateUserPassword(String newPassword) async {
    try {
      if (_auth.currentUser != null) {
        await _auth.currentUser!.updatePassword(newPassword);
        return true;
      }
      return false;
    } catch (e) {
      print("Error updating user password: $e");
      return false;
    }
  }

  // Cập nhật thông tin người dùng (ví dụ: tên)
  Future<bool> updateUserName(String newName, ChatUser chatUser) async {
    try {
      if (_auth.currentUser != null) {
        await _auth.currentUser!.updateDisplayName(newName);
        await firestore.collection('users').doc(chatUser.id).update({'name': newName});
        return true;
      }
      return false;
    } catch (e) {
      print("Error updating user name: $e");
      return false;
    }
  }

  Future<bool> updatePhotoUrl(String url, ChatUser chatUser) async {
    try {
      if (_auth.currentUser != null) {
        await _auth.currentUser!.updatePhotoURL(url);
        await firestore.collection('users').doc(chatUser.id).update({'image': url});
        return true;
      }
      return false;
    } catch (e) {
      print("Error updating photo url: $e");
      return false;
    }
  }

  Future<bool> updateAll(ChatUser chatUser) async {
    try {
      if (_auth.currentUser != null) {
        await _auth.currentUser!.updatePhotoURL(chatUser.image);
        await _auth.currentUser!.updateDisplayName(chatUser.name);
        await firestore.collection('users').doc(chatUser.id).update(chatUser.toJson());
        return true;
      }
      return false;
    } catch (e) {
      print("Error updating photo url: $e");
      return false;
    }
  }
}
