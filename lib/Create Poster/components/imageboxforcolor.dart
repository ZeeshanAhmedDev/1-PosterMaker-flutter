import 'package:flutter/material.dart';
import 'package:poster_maker/EditImageScreen/editImageScreen.dart';
import 'package:poster_maker/EditImageScreen/stickerEditImageScreen.dart';

class ImageBoxForColor extends StatelessWidget {
  // const imageBox({ Key? key }) : super(key: key);
  final colour;
  final aspect;
  ImageBoxForColor({this.colour, this.aspect});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 5, top: 15, bottom: 15),
      child: AspectRatio(
        aspectRatio: aspect,
        child: GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EditImageScreen(
                          img: this.colour, aspect: this.aspect)));
            },
            child: Container(
              height: 11,
              width: 11,
              color: colour,
            )),
      ),
    );
  }
}
