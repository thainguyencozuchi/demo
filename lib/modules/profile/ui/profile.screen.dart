// ignore_for_file: must_be_immutable, deprecated_member_use, prefer_const_literals_to_create_immutables, prefer_const_constructors, unused_import
import 'package:demo/common/theme/app_theme.dart';
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
import 'package:intl/intl.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _State();
}

class _State extends State<ProfileScreen> {
  ChatUser userLogin = ChatUser(id: '', name: '', about: '', createdAt: '', email: '', image: '', isOnline: false, pushToken: '', lastActive: '', background: '', phone: '', birth: '');
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            showToast(context: context, msg: state.error, color: colorErorr, icon: const Icon(Icons.warning));
          }
        },
        builder: (context, state) {
          return Stack(
            alignment: AlignmentDirectional.bottomCenter,
            children: [
              _buildBackgroundImage(),
              Container(
                height: MediaQuery.of(context).size.height * 0.7,
                decoration: BoxDecoration(
                  color: AppTheme.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  image: DecorationImage(
                    image: AssetImage('assets/background/b2.jpeg'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: _buildInfor(),
              ),
              _buildavatar(),
            ],
          );
        },
      ),
    );
  }

  _buildBackgroundImage() {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.3,
            width: MediaQuery.of(context).size.width,
            child: (userLogin.background != "" && userLogin.background != "null")
                ? Image.network(userLogin.background, fit: BoxFit.cover)
                : Image.asset(
                    "assets/background/background4.jpeg",
                    fit: BoxFit.cover,
                  ),
          ),
        ],
      ),
    );
  }

  _buildInfor() {
    return ListView(
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.11),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              userLogin.name,
              style: AppTheme.nameInfor,
            )
          ],
        ),
        _builCart("Email:", userLogin.email),
        _builCart("Số điện thoại:", userLogin.phone),
        _builCart("Ngày sinh:", (userLogin.birth != "") ? DateFormat("dd-MM-yyyy").format(DateTime.fromMillisecondsSinceEpoch(int.parse(userLogin.birth))) : ""),
        _builCart("Giới thiệu:", userLogin.about),
        Container(
          margin: EdgeInsets.only(top: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(right: 10),
                width: MediaQuery.of(context).size.width * 0.4,
                height: 40,
                decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(15)),
                child: InkWell(
                  onTap: () {
                    Navigator.push<void>(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => BlocProvider(
                          create: (context) => ProfileBloc(),
                          child: ProfileEditScreen(
                            userLogin: userLogin,
                            chatUser: userLogin,
                          ),
                        ),
                      ),
                    );
                  },
                  child: const Center(
                      child: Text(
                    "Cập nhật thông tin",
                    style: AppTheme.textButtonWhite,
                  )),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.4,
                height: 40,
                decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(15)),
                child: InkWell(
                  onTap: () {
                    Navigator.push<void>(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) => BlocProvider(
                            create: (context) => ProfileBloc(),
                            child: ProfileChangePasswordScreen(
                              chatUser: userLogin,
                            ),
                          ),
                        ));
                  },
                  child: const Center(
                      child: Text(
                    "Đổi mật khẩu",
                    style: AppTheme.textButtonWhite,
                  )),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  _builCart(String lable, String value) {
    return Container(
      margin: EdgeInsets.only(left: 15, right: 15, top: 15),
      padding: EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: AppTheme.blue1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              flex: 3,
              child: Text(
                lable,
                style: AppTheme.body1,
              )),
          Expanded(
              flex: 5,
              child: Text(
                value,
                style: AppTheme.body2,
              )),
        ],
      ),
    );
  }

  _buildavatar() {
    return Positioned(
        bottom: MediaQuery.of(context).size.height * 0.6,
        child: Container(
            width: MediaQuery.of(context).size.height * 0.2,
            height: MediaQuery.of(context).size.height * 0.2,
            decoration: BoxDecoration(border: Border.all(width: 4, color: AppTheme.blue), borderRadius: BorderRadius.circular(MediaQuery.of(context).size.height * 0.1)),
            child: (userLogin.image != "" && userLogin.image != "null")
                ? InkWell(
                    onTap: () {},
                    child: ClipOval(
                      child: FadeInImage.assetNetwork(
                        placeholder: 'assets/images/no-avatar.png',
                        image: userLogin.image,
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                : CircleAvatar(
                    backgroundImage: AssetImage(
                      'assets/images/no-avatar.png',
                    ),
                  )));
  }

  @override
  void dispose() {
    super.dispose();
  }
}
