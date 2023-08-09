// ignore_for_file: must_be_immutable, deprecated_member_use, prefer_const_literals_to_create_immutables, prefer_const_constructors
import 'package:demo/controllers/firebase.auth.service.dart';
import 'package:demo/models/chat_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../common/theme/color.dart';
import '../../../common/widget/toast.dart';
import '../../login/bloc/login_bloc.dart';
import '../../login/ui/login.screen.dart';
import '../bloc/profile_bloc.dart';
import 'profile.change.password.dart';
import 'profile.edit.screen.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _State();
}

class _State extends State<ProfileScreen> {
  ChatUser userLogin = ChatUser(
      id: '',
      name: '',
      about: '',
      createdAt: '',
      email: '',
      image: '',
      isOnline: false,
      pushToken: '',
      lastActive: '');
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Text(""),
        title: const Text("Thông tin"),
      ),
      resizeToAvoidBottomInset: false,
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileLoading) {
            onLoading(context);
            return;
          } else if (state is GetProfieSuccess) {
            Navigator.pop(context);
            userLogin = state.chatUser;
          } else if (state is GetProfieFailure) {
            Navigator.pop(context);
            showToast(
                context: context,
                msg: state.error,
                color: colorErorr,
                icon: const Icon(Icons.warning));
          }
        },
        builder: (context, state) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: const BoxDecoration(color: colorSuccesc),
                    child: (userLogin.image != "")
                        ? Image.network(
                            userLogin.image,
                            fit: BoxFit.fill,
                          )
                        : const Text(""),
                  ),
                  Text("Tên: ${userLogin.name}"),
                  const SizedBox(height: 15),
                  Text("Email: ${userLogin.email}"),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      TextButton(
                          onPressed: () {
                            Navigator.push<void>(
                              context,
                              MaterialPageRoute<void>(
                                builder: (BuildContext context) => BlocProvider(
                                  create: (context) => ProfileBloc(),
                                  child: ProfileEditScreen(
                                    userLogin: userLogin, chatUser: userLogin,
                                  ),
                                ),
                              ),
                            );
                          },
                          child: const Text("Cập nhật")),
                      const SizedBox(height: 20),
                      TextButton(
                          onPressed: () {
                            Navigator.push<void>(
                              context,
                              MaterialPageRoute<void>(
                                builder: (BuildContext context) => BlocProvider(
                                  create: (context) => ProfileBloc(),
                                  child: ProfileChangePasswordScreen(chatUser: userLogin,),
                                ),
                              ),
                            );
                          },
                          child: const Text("Đổi mật khẩu")),
                      const SizedBox(height: 20),
                      TextButton(
                          onPressed: () {
                            AuthService().signOut();
                            Navigator.push<void>(
                              context,
                              MaterialPageRoute<void>(
                                builder: (BuildContext context) => BlocProvider(
                                  create: (context) => LoginBloc(),
                                  child: LoginScreen(),
                                ),
                              ),
                            );
                          },
                          child: const Text("Đăng xuất")),
                    ],
                  )
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
