// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.download))
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
