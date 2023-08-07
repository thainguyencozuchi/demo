import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../controllers/firebase.auth.service.dart';
import '../login/bloc/login_bloc.dart';
import '../login/ui/login.screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String name = "";
  @override
  void initState() {
    super.initState();
    User? userLogin = AuthService().getCurrentUser();
    if (userLogin != null) {
      setState(() {
        name = userLogin.displayName ?? "";
        print("object:${name}");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            color: Colors.amber,
          ),
          child: Row(
            children: [
              Column(
                children: [
                  Text("Helloo :$name"),
                  const SizedBox(
                    height: 30,
                  ),
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
                      child: const Text("Đăng xuất"))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
