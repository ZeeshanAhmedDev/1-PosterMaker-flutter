import 'dart:io';
import 'package:flutter/material.dart';
import 'package:poster_maker/EditImageScreen/resizeWidget.dart';
import 'package:poster_maker/EditImageScreen/textfield.dart';

class ImageEdit extends StatefulWidget {
  File image;
  ImageEdit({Key? key, required this.image}) : super(key: key);

  @override
  _ImageEditState createState() => _ImageEditState();
}

class _ImageEditState extends State<ImageEdit> {
  var result = 'Click To Edit';
  @override
  Widget build(BuildContext context) {
    return ResizebleWidget(child: Image.file(widget.image)
        // text: result??'Text'
        );
  }
}
