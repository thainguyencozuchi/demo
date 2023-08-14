// ignore_for_file: must_be_immutable, unused_import, use_build_context_synchronously
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../common/theme/app_theme.dart';
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
  String urlImage = "";
  File? selectFileBackGound;
  String urlImageBackground = "";
  ChatUser chatUser = ChatUser(id: '', name: '', about: '', createdAt: '', email: '', image: '', isOnline: false, pushToken: '', lastActive: '', background: '', phone: '', birth: '');

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _birthController = TextEditingController();
  final TextEditingController _aboutController = TextEditingController();
  final _bloc = ProfileBloc();

  DateTime? selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        widget.chatUser.birth = selectedDate!.millisecondsSinceEpoch.toString();
        _birthController.text = DateFormat('dd-MM-yyyy').format(selectedDate!);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.chatUser.name;
    _phoneController.text = widget.chatUser.phone;
    _aboutController.text = widget.chatUser.about;
    _birthController.text = (widget.chatUser.birth != "") ? DateFormat('dd-MM-yyyy').format(DateTime.fromMillisecondsSinceEpoch(int.parse(widget.chatUser.birth))) : "";
    chatUser = widget.chatUser;
  }

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
      body: BlocConsumer<ProfileBloc, ProfileState>(
        bloc: _bloc,
        listener: (context, state) {
          if (state is ProfileLoading) {
            onLoading(context);
            return;
          } else if (state is UpdateProfieSuccess) {
            Navigator.pop(context);
            showToast(context: context, msg: "Cập nhật thành công", color: colorSuccesc, icon: const Icon(Icons.done));
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
                decoration: const BoxDecoration(
                    color: AppTheme.white,
                    image: DecorationImage(
                      image: AssetImage('assets/background/b2.jpeg'),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    )),
                child: ListView(
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.person),
                            border: myinputborder(),
                            enabledBorder: myinputborder(),
                            focusedBorder: myfocusborder(),
                            labelText: 'Tên',
                          ),
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.characters),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: TextFormField(
                          controller: _phoneController,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.phone),
                            border: myinputborder(),
                            enabledBorder: myinputborder(),
                            focusedBorder: myfocusborder(),
                            labelText: 'Số điện thoại',
                          ),
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.characters),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: TextFormField(
                        controller: _birthController,
                        readOnly: true, // To prevent manual text input
                        onTap: () => _selectDate(context),
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.calendar_today),
                          border: myinputborder(), // You need to define myinputborder() function
                          enabledBorder: myinputborder(),
                          focusedBorder: myfocusborder(),
                          labelText: "Ngày sinh",
                        ),
                        keyboardType: TextInputType.text,
                        textCapitalization: TextCapitalization.none,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: TextFormField(
                          controller: _aboutController,
                          maxLines: 5,
                          minLines: 2,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.info),
                            border: myinputborder(),
                            enabledBorder: myinputborder(),
                            focusedBorder: myfocusborder(),
                            labelText: 'Giới thiệu',
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
                                FilePickerResult? result = await FilePicker.platform.pickFiles(
                                  type: FileType.custom,
                                  allowedExtensions: ['jpg', 'png'],
                                );

                                if (result != null) {
                                  setState(() {
                                    selectFile = File(result.files.single.path!);
                                    urlImage = result.files.single.name;
                                  });
                                } else {
                                  showToast(context: context, msg: "Chưa chọn file", color: colorErorr, icon: const Icon(Icons.warning));
                                }
                              },
                              child: const Center(
                                  child: Text(
                                "Đổi ảnh đại diện",
                                style: AppTheme.textButtonWhite,
                              )),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.4,
                            height: 40,
                            decoration: BoxDecoration(color: AppTheme.blue1, borderRadius: BorderRadius.circular(15)),
                            child: InkWell(
                              onTap: () async {
                                FilePickerResult? result = await FilePicker.platform.pickFiles(
                                  type: FileType.custom,
                                  allowedExtensions: ['jpg', 'png'],
                                );

                                if (result != null) {
                                  setState(() {
                                    selectFileBackGound = File(result.files.single.path!);
                                    urlImageBackground = result.files.single.name;
                                  });
                                } else {
                                  showToast(context: context, msg: "Chưa chọn file", color: colorErorr, icon: const Icon(Icons.warning));
                                }
                              },
                              child: const Center(
                                  child: Text(
                                "Đổi ảnh bìa",
                                style: AppTheme.textButtonWhite,
                              )),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 15, bottom: 300),
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
                                _bloc.add(UpdateProfieEvent(
                                  avatarFile: selectFile,
                                  bacnkgroundFile: selectFileBackGound,
                                  chatUser: chatUser,
                                  avatarName: urlImage,
                                  bacnkgroundName: urlImageBackground,
                                  about: _aboutController.text,
                                  birth: _birthController.text,
                                  phoneNumber: _phoneController.text,
                                  name: _nameController.text,
                                ));
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
                ),
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
              child: (selectFileBackGound != null)
                  ? Image.file(
                      selectFileBackGound!,
                      fit: BoxFit.cover,
                    )
                  : (widget.chatUser.background != "")
                      ? FadeInImage.assetNetwork(
                          placeholder: "assets/background/background4.jpeg",
                          image: widget.chatUser.background,
                          fit: BoxFit.cover,
                        )
                      : Image.asset(
                          "assets/background/background4.jpeg",
                          fit: BoxFit.cover,
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
            child: (selectFile != null)
                ? ClipOval(
                    child: Image.file(
                      selectFile!,
                      fit: BoxFit.cover,
                    ),
                  )
                : (widget.chatUser.image != "" && widget.chatUser.image != "null")
                    ? InkWell(
                        onTap: () {},
                        child: ClipOval(
                          child: FadeInImage.assetNetwork(
                            placeholder: 'assets/images/no-avatar.png',
                            image: widget.chatUser.image,
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    : const CircleAvatar(
                        backgroundImage: AssetImage(
                          'assets/images/no-avatar.png',
                        ),
                      )));
  }

  @override
  void dispose() {
    _bloc.close();
    _nameController.dispose();
    _aboutController.dispose();
    _birthController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}
