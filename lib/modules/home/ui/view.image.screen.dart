// ignore_for_file: must_be_immutable, avoid_print, depend_on_referenced_packages, use_build_context_synchronously
import 'dart:io';

import 'package:demo/common/theme/color.dart';
import 'package:demo/common/widget/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:photo_view/photo_view.dart';
import 'package:path_provider/path_provider.dart';
import 'package:android_path_provider/android_path_provider.dart';

class ViewImageScreen extends StatefulWidget {
  String url;
  String fileName;

  ViewImageScreen({Key? key, required this.url, required this.fileName})
      : super(key: key);

  @override
  State<ViewImageScreen> createState() => _State();
}

class _State extends State<ViewImageScreen> {
  late PhotoViewController controller;
  double scaleCopy = 1;

  late PhotoViewScaleStateController scaleStateController;

  @override
  void initState() {
    super.initState();
    controller = PhotoViewController()..outputStateStream.listen(listener);
    scaleStateController = PhotoViewScaleStateController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void listener(PhotoViewControllerValue value) {
    setState(() {
      scaleCopy = value.scale!;
    });
  }

  late final String path;

  static Future<String> _prepareSaveDir() async {
    final _localPath = await _findLocalPath();
    final savedDir = Directory(_localPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      await savedDir.create();
    }

    return _localPath;
  }

  static Future<String> _findLocalPath() async {
    var externalStorageDirPath;
    if (Platform.isAndroid) {
      try {
        externalStorageDirPath = await AndroidPathProvider.downloadsPath;
      } catch (e) {
        final directory = await getExternalStorageDirectory();
        externalStorageDirPath = directory?.path;
      }
    } else if (Platform.isIOS) {
      externalStorageDirPath =
          (await getApplicationDocumentsDirectory()).absolute.path;
    }
    return externalStorageDirPath;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () async {
               try{
                 await FlutterDownloader.enqueue(
                  url: widget.url,
                  savedDir: await _prepareSaveDir(),
                  fileName: DateTime.now().millisecondsSinceEpoch.toString(),
                  saveInPublicStorage: true,
                  showNotification:
                      false,
                  openFileFromNotification:
                      false,
                );
                showToast(context: context, msg: "Tải thành công", color: colorSuccesc, icon: const Icon(Icons.done));
               }catch(e){
                print("erorr: $e");
               }
              },
              icon: const Icon(Icons.download))
        ],
      ),
      body: Stack(
        children: <Widget>[
          Positioned.fill(
              child: PhotoView(
            imageProvider: NetworkImage(widget.url),
            // controller: controller,
            scaleStateController: scaleStateController,
          )),
        ],
      ),
    );
  }
}
