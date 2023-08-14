import 'package:demo/common/theme/color.dart';
import 'package:demo/modules/login/ui/login.screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../common/theme/app_theme.dart';
import '../../../common/widget/toast.dart';
import '../../login/bloc/login_bloc.dart';
import '../bloc/sign_bloc.dart';

class SignScreen extends StatefulWidget {
  const SignScreen({Key? key}) : super(key: key);

  @override
  State<SignScreen> createState() => _SignScreenState();
}

class _SignScreenState extends State<SignScreen> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
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
      appBar: AppBar(
        title: const Text("Đăng ký"),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background/b1.jpeg"),
            fit: BoxFit.cover,
          ),
        ),
        child: BlocConsumer<SignBloc, SignState>(
          listener: (context, state) {
            if (state is SignLoading) {
              onLoading(context);
              return;
            } else if (state is SignSuccess) {
              showToast(context: context, msg: "Đăng ký thành công", color: colorSuccesc, icon: const Icon(Icons.done));
              Navigator.push<void>(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => BlocProvider(
                    create: (context) => LoginBloc(),
                    child: LoginScreen(
                      email: state.email,
                    ),
                  ),
                ),
              );
            } else if (state is SignFailure) {
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
                    controller: _fullNameController,
                    decoration: InputDecoration(
                      labelText: "Họ và tên",
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
                  child: TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      prefixIcon: const Icon(Icons.email),
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
                  padding: const EdgeInsets.all(10),
                  child: Container(
                    height: 60,
                     decoration: BoxDecoration(
                      color: AppTheme.blue1,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: InkWell(
                      onTap: () async {
                        BlocProvider.of<SignBloc>(context).add(
                          SignFireBaseEvent(
                            displayName: _fullNameController.text,
                            email: _nameController.text,
                            password: _passwordController.text,
                          ),
                        );
                      },
                      child: const Center(
                        child: Text(
                          "Sign",
                          style: TextStyle(color: Colors.white),
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
    super.dispose();
  }
}
