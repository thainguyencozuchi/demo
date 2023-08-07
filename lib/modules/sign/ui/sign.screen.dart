import 'package:demo/common/theme/color.dart';
import 'package:demo/modules/login/ui/login.screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  void initstate() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
          // leading: ,
          ),
      body: BlocConsumer<SignBloc, SignState>(
        listener: (context, state) {
          if (state is SignLoading) {
            onLoading(context);
            return;
          } else if (state is SignSuccess) {
            showToast(
                context: context,
                msg: "Đăng ký thành công",
                color: colorSuccesc,
                icon: const Icon(Icons.done));
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
            showToast(
                context: context,
                msg: state.error,
                color: colorErorr,
                icon: const Icon(Icons.warning));
          }
        },
        builder: (context, state) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Card(
                  elevation: 3,
                  child: TextFormField(
                    controller: _fullNameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Full name',
                    ),
                    keyboardType: TextInputType.text,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Card(
                  elevation: 3,
                  child: TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                    ),
                    keyboardType: TextInputType.text,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Card(
                  elevation: 3,
                  child: TextFormField(
                      controller: _passwordController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Password',
                      ),
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.characters),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(3),
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
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
