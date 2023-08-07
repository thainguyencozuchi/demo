import 'package:flutter/material.dart';

class SignScreen extends StatefulWidget {
  const SignScreen({Key? key}) : super(key: key);

  @override
  State<SignScreen> createState() => _SignScreenState();
}

class _SignScreenState extends State<SignScreen> {
  // final bloc = SignBloc();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initstate() {
    super.initState();
    // bloc.add();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // leading: ,
      ),
      body: Column(
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
                onTap: () {},
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
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}