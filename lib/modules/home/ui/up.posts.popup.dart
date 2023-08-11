// ignore_for_file: must_be_immutable
import 'dart:io';

import 'package:demo/common/theme/app_theme.dart';
import 'package:demo/modules/home/bloc/home_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/theme/color.dart';
import '../../../common/widget/toast.dart';
import '../../../navigation_home_screen.dart';

class UpPostsPopUp extends StatefulWidget {
  UpPostsPopUp({Key? key}) : super(key: key);

  @override
  State<UpPostsPopUp> createState() => _State();
}

class _State extends State<UpPostsPopUp> {
  final _bloc = HomeBloc();
  File? selectFile;
  String urlImage = "";
  TextEditingController title = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      bloc: _bloc,
      listener: (context, state) {
        if (state is HomeLoading) {
          onLoading(context);
          return;
        } else if (state is UpPostsSucces) {
          Navigator.push<void>(
            context,
            MaterialPageRoute<void>(
              builder: (BuildContext context) => NavigationHomeScreen(),
            ),
          );
        } else if (state is ErorrStatus) {
          Navigator.pop(context);
          showToast(
              context: context,
              msg: state.error,
              color: colorErorr,
              icon: const Icon(Icons.warning));
        }
      },
      builder: (context, state) {
        return AlertDialog(
          backgroundColor:  AppTheme.mainColors,
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 10),
                  width: 100,
                  height: 30,
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(15)),
                  child: InkWell(
                    onTap: () async {
                      _bloc.add(UpPostsEvent(
                          title: title.text,
                          imageName: urlImage,
                          imageFile: selectFile!));
                    },
                    child: const Center(
                        child: Text(
                      "Đăng",
                      style: AppTheme.textButtonWhite,
                    )),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 10),
                  width: 100,
                  height: 30,
                  decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(15)),
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Center(
                        child: Text(
                      "Huỷ",
                      style: AppTheme.textButtonWhite,
                    )),
                  ),
                )
              ],
            )
          ],
          content: Container(
            width: MediaQuery.of(context).size.width,
            height: 350,
            child: ListView(
              children: [
                TextField(
                  controller: title,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: AppTheme.white,width: 3),
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0))),
                      labelText: 'Tiêu đề',
                      labelStyle: AppTheme.lableInput,
                      contentPadding: EdgeInsets.all(8)),
                  maxLines: 3,
                  minLines: 1,
                ),
                Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 10),
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    height: 250,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: (selectFile != null)
                          ? Image.file(
                              selectFile!,
                              fit: BoxFit.cover,
                            )
                          : Image.asset(
                              "assets/images/no-image.jpg",
                              fit: BoxFit.cover,
                            ),
                    )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 10),
                      width: 100,
                      height: 30,
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(15)),
                      child: InkWell(
                        onTap: () async {
                          FilePickerResult? result =
                              await FilePicker.platform.pickFiles(
                            type: FileType.custom,
                            allowedExtensions: ['jpg', 'png', 'webp'],
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
                        child: const Center(
                            child: Text(
                          "Tải ảnh",
                          style: AppTheme.textButtonWhite,
                        )),
                      ),
                    ),
                    if (selectFile != null)
                      Container(
                        margin: const EdgeInsets.only(right: 10),
                        width: 100,
                        height: 30,
                        decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(15)),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              selectFile = null;
                              urlImage = "";
                            });
                          },
                          child: const Center(
                              child: Text(
                            "Xoá ảnh",
                            style: AppTheme.textButtonWhite,
                          )),
                        ),
                      )
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _bloc.close();
    title.dispose();
    super.dispose();
  }
}
