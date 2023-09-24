import 'package:flutter/material.dart';
import 'package:poster_maker/EditImageScreen/editImageScreen.dart';

class ImageBox extends StatelessWidget {
  // const imageBox({ Key? key }) : super(key: key);
  var img;
  var aspect;
  ImageBox({this.img, this.aspect});

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
                    builder: (context) =>
                        EditImageScreen(img: this.img, aspect: this.aspect)));
          },
          child: Image.asset(
            img,
            // backgroundList.last.imageUrl,
          ),
        ),
      ),
    );
  }
}
