import 'package:flutter/material.dart';
import 'dart:io' show File;

import 'package:ubandbase/widget/flutter_drage_scale/core/drag_scale_widget.dart';

enum ImgType { FILE, ASSET, URL }

// ignore: must_be_immutable
class CenterPictureDetail extends StatelessWidget {
  String picAsset;
  File filePath;
  String url;

  ImgType _type;

  CenterPictureDetail.path(File filePath) {
    this.filePath = filePath;
    _type = ImgType.FILE;
  }

  CenterPictureDetail.asset(String picAsset) {
    this.picAsset = picAsset;
    _type = ImgType.ASSET;
  }

  CenterPictureDetail.url(String url) {
    this.url = url;
    _type = ImgType.URL;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Container(
          padding: EdgeInsets.fromLTRB(
              0, 40 / 750 * screenWidth, 0, 40 / 750 * screenWidth),
          child: DragScaleContainer(
              doubleTapStillScale: true, child: _getImg(_type)),
        ));
  }

  Widget _getImg(ImgType type) {
    switch (type) {
      case ImgType.FILE:
        return Image.file(filePath);
      case ImgType.ASSET:
        return Image.asset(picAsset);
      case ImgType.URL:
        return Image.network(url);
      default:
        return Image.asset("image/img_placeholder.png");
    }
  }
}
