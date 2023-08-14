// ignore_for_file: must_be_immutable, unused_import
import 'package:demo/common/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/theme/color.dart';
import '../../../common/widget/toast.dart';
import '../../../navigation_home_screen.dart';
import '../../sign/bloc/sign_bloc.dart';
import '../../sign/ui/sign.screen.dart';
import '../bloc/login_bloc.dart';

class LoginScreen extends StatefulWidget {
  String? email;
  LoginScreen({Key? key, this.email}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _bloc = LoginBloc();
  int volume = 0;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  

  @override
  void initState() {
    super.initState();
    _bloc.add(AutoLogin());
    _nameController.text = widget.email ?? "";
  }
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
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background/b1.jpeg"),
            fit: BoxFit.cover,
          ),
        ),
        child: BlocConsumer<LoginBloc, LoginState>(
          bloc: _bloc,
          listener: (context, state) {
            if (state is LoginLoading) {
              onLoading(context);
              return;
            } else if (state is LoginSuccess) {
              Navigator.push<void>(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => NavigationHomeScreen(),
                ),
              );
            } else if (state is AutoLoginSuccess) {
              Navigator.push<void>(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => NavigationHomeScreen(),
                ),
              );
            } else if (state is AutoLoginFail) {
              Navigator.pop(context);
            } else if (state is LoginFailure) {
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
                  child: TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: "Tài khoản",
                      prefixIcon: const Icon(Icons.people),
                      border: myinputborder(),
                      enabledBorder: myinputborder(),
                      focusedBorder: myfocusborder(),
                    ),
                    keyboardType: TextInputType.text,
                  ),
                ),
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
                        labelText: 'Mật khẩu',
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
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                          onPressed: () {
                            Navigator.push<void>(
                              context,
                              MaterialPageRoute<void>(
                                builder: (BuildContext context) => BlocProvider(
                                  create: (context) => SignBloc(),
                                  child: const SignScreen(),
                                ),
                              ),
                            );
                          },
                          child: const Text(
                            "Chưa có tài khoản?",
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                            ),
                          ))
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Container(
                    height: 60,
                    decoration: BoxDecoration(
                      color: AppTheme.blue1,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: InkWell(
                      onTap: () {
                        _bloc.add(
                          LoginFireBaseEvent(
                            email: _nameController.text,
                            password: _passwordController.text,
                          ),
                        );
                      },
                      child: const Center(
                        child: Text(
                          "Login",
                          style: AppTheme.textButtonWhite,
                        ),
                      ),
                    ),
                  ),
                )
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
    super.dispose();
  }
}
