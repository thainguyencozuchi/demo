// ignore_for_file: must_be_immutable
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../common/theme/color.dart';
import '../../../common/widget/home_drawer.dart';
import '../../../common/widget/toast.dart';
import '../../../models/chat_user.dart';
import '../../../navigation_home_screen.dart';
import '../bloc/profile_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'profile.screen.dart';

class ProfileEditScreen extends StatefulWidget {
  ChatUser chatUser;
  ProfileEditScreen({Key? key, required this.chatUser, required ChatUser userLogin}) : super(key: key);

  @override
  State<ProfileEditScreen> createState() => _State();
}

class _State extends State<ProfileEditScreen> {
  File? selectFile;
  ChatUser chatUser = ChatUser(
      id: '',
      name: '',
      about: '',
      createdAt: '',
      email: '',
      image: '',
      isOnline: false,
      pushToken: '',
      lastActive: '');

  String urlImage = "";
  final TextEditingController _nameController = TextEditingController();
  final _bloc = ProfileBloc();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.chatUser.name;
    chatUser = widget.chatUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cập nhật"),
      ),
      resizeToAvoidBottomInset: false,
      body: BlocConsumer<ProfileBloc, ProfileState>(
        bloc: _bloc,
        listener: (context, state) {
          if (state is ProfileLoading) {
            onLoading(context);
            return;
          } else if (state is UpdateProfieSuccess) {
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
              Container(
                height: 100,
                width: 100,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: const BoxDecoration(color: colorSuccesc),
                child: (selectFile != null)
                    ? Image.file(
                        selectFile!,
                        fit: BoxFit.fill,
                      )
                    : (chatUser.image != "")
                        ? Image.network(
                            chatUser.image,
                            fit: BoxFit.fill,
                          )
                        : const Text(""),
              ),
              const SizedBox(height: 15),
              OutlinedButton(
                  onPressed: () async {
                    FilePickerResult? result =
                        await FilePicker.platform.pickFiles(
                      type: FileType.custom,
                      allowedExtensions: ['jpg', 'png'],
                    );

                    if (result != null) {
                      setState(() {
                        selectFile = File(result.files.single.path!);
                        urlImage = result.files.single.name;
                      });
                    } else {
                      print("Chưa chọn file");
                    }
                  },
                  child: Text("Thay đổi ảnh")),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Tên',
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
                        if (urlImage != "") {
                          await FirebaseStorage.instance
                              .ref('uploads/$urlImage')
                              .putFile(selectFile!);
                        }
                        _bloc.add(UpdateProfieEvent(
                            fileName: urlImage,
                            displayName: _nameController.text,
                            chatUser: chatUser));
                      },
                      child: const Text("Cập nhật")),
                  const SizedBox(height: 20),
                  TextButton(
                      onPressed: () {
                        Navigator.push<void>(
                          context,
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) =>
                                NavigationHomeScreen(
                              drawerIndex: DrawerIndex.Profile,
                              screenView: BlocProvider(
                                create: (context) =>
                                    ProfileBloc()..add(GetProfieEvent()),
                                child: ProfileScreen(),
                              ),
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
    _nameController.dispose();
    super.dispose();
  }
}
