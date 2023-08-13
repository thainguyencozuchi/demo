// ignore_for_file: must_be_immutable, avoid_print, depend_on_referenced_packages

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:flowder/flowder.dart';
import 'package:path_provider/path_provider.dart';

class ViewImageScreen extends StatefulWidget {
  String url;
  ViewImageScreen({Key? key, required this.url}) : super(key: key);

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
    initPlatformState();
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

  late DownloaderUtils options;
  late DownloaderCore core;
  late final String path;

  Future<void> initPlatformState() async {
    _setPath();
    if (!mounted) return;
  }

  void _setPath() async {
    path = (await getExternalStorageDirectory())!.path;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () async {
                try {
                  // options = DownloaderUtils(
                  //   progressCallback: (current, total) {
                  //     final progress = (current / total) * 100;
                  //     print('Downloading: $progress');
                  //   },
                  //   file: File('$path/200MB.zip'),
                  //   progress: ProgressImplementation(),
                  //   onDone: (value) {
                  //     print('COMPLETE');
                  //   },
                  //   deleteOnCancel: true,
                  // );
                  // core = await Flowder.download(widget.url, options);
                } catch (e) {
                  print("error: $e");
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
          ElevatedButton(
            onPressed: () async => core.resume(),
            child: Text('RESUME'),
          ),
          ElevatedButton(
            onPressed: () async => core.cancel(),
            child: Text('CANCEL'),
          ),
          ElevatedButton(
            onPressed: () async => core.pause(),
            child: Text('PAUSE'),
          ),
        ],
      ),
    );
  }
}
