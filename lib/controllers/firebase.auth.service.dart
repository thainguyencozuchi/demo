import 'package:firebase_auth/firebase_auth.dart';

import '../models/user.login.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Tạo đối tượng User từ UserCredential
  User? _userFromFirebaseUser(UserCredential userCredential) {
    return userCredential.user;
  }

  // Đăng ký người dùng với email và mật khẩu
  Future<UserLogin?> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      UserLogin userLogin =
          UserLogin(uid: '', email: '', displayName: '', photoURL: '');
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = _userFromFirebaseUser(userCredential);
      if (user != null) {
        userLogin.uid = user.uid;
        userLogin.email = user.email!;
        userLogin.displayName =  "";
        userLogin.photoURL = "";
      }
      return userLogin;
    } catch (e) {
      print("Error during registration: $e");
      return null;
    }
  }

  // Đăng nhập với email và mật khẩu
  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return _userFromFirebaseUser(userCredential);
    } catch (e) {
      print("Error during login: $e");
      return null;
    }
  }

  // Đăng xuất người dùng
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print("Error during sign out: $e");
    }
  }

  // Kiểm tra trạng thái đăng nhập hiện tại
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Stream để theo dõi trạng thái đăng nhập của người dùng
  Stream<User?> authStateChanges() {
    return _auth.authStateChanges();
  }

  // Cập nhật thông tin người dùng (ví dụ: email)
  Future<bool> updateUserEmail(String newEmail) async {
    try {
      if (_auth.currentUser != null) {
        await _auth.currentUser!.updateEmail(newEmail);
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
  Future<bool> updateUserName(String newName) async {
    try {
      if (_auth.currentUser != null) {
        await _auth.currentUser!.updateDisplayName(newName);
        return true;
      }
      return false;
    } catch (e) {
      print("Error updating user name: $e");
      return false;
    }
  }
}