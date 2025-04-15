import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';

class PhotoViewWrapper extends StatelessWidget {
  const PhotoViewWrapper({
    super.key,
    required this.imageProvider,
    required this.tag,
    this.minScale,
    this.maxScale,
    this.backgroundDecoration,
  });
  final String tag;
  final ImageProvider? imageProvider;
  final dynamic minScale;
  final dynamic maxScale;
  final BoxDecoration? backgroundDecoration;
  static void zoom(ImageProvider image, String tag) {
    Get.to(() => PhotoViewWrapper(imageProvider: image, tag: tag));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: const CloseButton(color: Colors.white),
      ),
      body: Container(
        color: Colors.black,
        constraints: BoxConstraints.expand(
          height: MediaQuery.of(context).size.height,
        ),
        child: PhotoView(
          heroAttributes: PhotoViewHeroAttributes(tag: tag),
          loadingBuilder: (_, image) {
            return Center(
              child: Align(
                alignment: Alignment.center,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).primaryColor),
                ),
              ),
            );
          },
          imageProvider: imageProvider,
          backgroundDecoration: backgroundDecoration,
          minScale: minScale,
          maxScale: maxScale,
        ),
      ),
    );
  }
}
