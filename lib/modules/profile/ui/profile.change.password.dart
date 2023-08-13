// ignore_for_file: must_be_immutable
import 'package:demo/models/chat_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../common/theme/app_theme.dart';
import '../../../common/theme/color.dart';
import '../../../common/widget/home_drawer.dart';
import '../../../common/widget/toast.dart';
import '../../../navigation_home_screen.dart';
import '../bloc/profile_bloc.dart';
import 'profile.screen.dart';

class ProfileChangePasswordScreen extends StatefulWidget {
  ChatUser chatUser;
  ProfileChangePasswordScreen({Key? key, required this.chatUser}) : super(key: key);

  @override
  State<ProfileChangePasswordScreen> createState() => _State();
}

class _State extends State<ProfileChangePasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _rePasswordController = TextEditingController();
  final _bloc = ProfileBloc();

  bool showPassword = false;
  OutlineInputBorder myinputborder() {
    //return type is OutlineInputBorder
    return const OutlineInputBorder(
        //Outline border type for TextFeild
        borderRadius: BorderRadius.all(Radius.circular(20)),
        borderSide: BorderSide(
          color: AppTheme.blue1,
          width: 3,
        ));
  }

  OutlineInputBorder myfocusborder() {
    return const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        borderSide: BorderSide(
          color: AppTheme.blue,
          width: 3,
        ));
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background/b2.jpeg'),
            fit: BoxFit.cover,
          ),
        ),
        child: BlocConsumer<ProfileBloc, ProfileState>(
          bloc: _bloc,
          listener: (context, state) {
            if (state is ProfileLoading) {
              onLoading(context);
              return;
            } else if (state is ChangePasswordSuccess) {
              Navigator.pop(context);
              showToast(context: context, msg: "Đổi mật khẩu thành công", color: colorSuccesc, icon: const Icon(Icons.done));
            } else if (state is GetProfieFailure) {
              Navigator.pop(context);
              showToast(context: context, msg: state.error, color: colorErorr, icon: const Icon(Icons.warning));
            }
          },
          builder: (context, state) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                      obscureText: !showPassword,
                      controller: _passwordController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.password),
                        border: myinputborder(),
                        enabledBorder: myinputborder(),
                        focusedBorder: myfocusborder(),
                        labelText: 'Mật khẩu mới',
                        suffixIcon: IconButton(
                          icon: Icon(showPassword ? Icons.visibility : Icons.visibility_off, color: AppTheme.blue),
                          onPressed: () {
                            setState(() {
                              showPassword = !showPassword;
                            });
                          },
                        ),
                      ),
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.characters),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                      obscureText: !showPassword,
                      controller: _rePasswordController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.password),
                        border: myinputborder(),
                        enabledBorder: myinputborder(),
                        focusedBorder: myfocusborder(),
                        labelText: 'Nhập lại mật khẩu',
                        suffixIcon: IconButton(
                          icon: Icon(showPassword ? Icons.visibility : Icons.visibility_off, color: AppTheme.blue),
                          onPressed: () {
                            setState(() {
                              showPassword = !showPassword;
                            });
                          },
                        ),
                      ),
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.characters),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(right: 10),
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: 40,
                        decoration: BoxDecoration(color: AppTheme.blue1, borderRadius: BorderRadius.circular(15)),
                        child: InkWell(
                          onTap: () async {
                            _bloc.add(ChangePassEvent(password: _passwordController.text, rePassword: _rePasswordController.text, chatUser: widget.chatUser));
                          },
                          child: const Center(
                              child: Text(
                            "Cập nhật",
                            style: AppTheme.textButtonWhite,
                          )),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: 40,
                        decoration: BoxDecoration(color: AppTheme.orange, borderRadius: BorderRadius.circular(15)),
                        child: InkWell(
                          onTap: () async {
                            Navigator.push<void>(
                              context,
                              MaterialPageRoute<void>(
                                builder: (BuildContext context) => NavigationHomeScreen(
                                  drawerIndex: DrawerIndex.Profile,
                                  screenView: BlocProvider(
                                    create: (context) => ProfileBloc()..add(GetProfieEvent()),
                                    child: ProfileScreen(),
                                  ),
                                ),
                              ),
                            );
                          },
                          child: const Center(
                              child: Text(
                            "Trở về",
                            style: AppTheme.textButtonWhite,
                          )),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _bloc.close();
    _passwordController.dispose();
    _rePasswordController.dispose();
    super.dispose();
  }
}
