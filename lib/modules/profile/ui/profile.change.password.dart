// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../common/theme/color.dart';
import '../../../common/widget/toast.dart';
import '../bloc/profile_bloc.dart';
import 'profile.screen.dart';

class ProfileChangePasswordScreen extends StatefulWidget {
  const ProfileChangePasswordScreen({Key? key}) : super(key: key);

  @override
  State<ProfileChangePasswordScreen> createState() => _State();
}

class _State extends State<ProfileChangePasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _rePasswordController = TextEditingController();
  final _bloc = ProfileBloc();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Đổi mật khẩu"),
      ),
      resizeToAvoidBottomInset: false,
      body: BlocConsumer<ProfileBloc, ProfileState>(
        bloc: _bloc,
        listener: (context, state) {
          if (state is ProfileLoading) {
            onLoading(context);
            return;
          } else if (state is ChangePasswordSuccess) {
            Navigator.pop(context);
            showToast(
                context: context,
                msg: "Succesc",
                color: colorSuccesc,
                icon: const Icon(Icons.warning));
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
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Mật khẩu mới',
                  ),
                  keyboardType: TextInputType.text,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  controller: _rePasswordController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Nhập lại mật khẩu',
                  ),
                  keyboardType: TextInputType.text,
                ),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                      onPressed: () async {
                        _bloc.add(ChangePassEvent(
                            password: _passwordController.text,
                            rePassword: _rePasswordController.text));
                      },
                      child: const Text("Cập nhật")),
                  const SizedBox(height: 20),
                  TextButton(
                      onPressed: () {
                        Navigator.push<void>(
                          context,
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) => BlocProvider(
                              create: (context) =>
                                  ProfileBloc()..add(GetProfieEvent()),
                              child: ProfileScreen(),
                            ),
                          ),
                        );
                      },
                      child: const Text("Trở về")),
                ],
              )
            ],
          );
        },
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
