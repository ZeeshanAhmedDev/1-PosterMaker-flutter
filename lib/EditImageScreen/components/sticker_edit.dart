import 'dart:io';
import 'package:flutter/material.dart';
import 'package:poster_maker/EditImageScreen/resizeWidget.dart';

class StickerEdit extends StatefulWidget {
  File image;
  StickerEdit({Key? key, required this.image}) : super(key: key);

  @override
  _StickerEditState createState() => _StickerEditState();
}

class _StickerEditState extends State<StickerEdit> {
  var result = 'Click To Edit';
  @override
  Widget build(BuildContext context) {
    return ResizebleWidget(child: Image.file(widget.image)
        // text: result??'Text'
        );
  }
}
