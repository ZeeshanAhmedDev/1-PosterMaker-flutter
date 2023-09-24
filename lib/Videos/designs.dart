import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:poster_maker/constant/constants.dart';

class VideosScreen extends StatefulWidget {
  const VideosScreen({Key? key}) : super(key: key);

  @override
  _VideosScreenState createState() => _VideosScreenState();
}

class _VideosScreenState extends State<VideosScreen> {
  File? image;
  final ImagePicker _picker = ImagePicker();

  Future getImageFromCamera() async {
    try {
      final image = await _picker.pickVideo(source: ImageSource.gallery);

      if (image == null) return;

      final imageTemp = File(image.path);
      setState(() {
        this.image = imageTemp;
      });
    } on PlatformException catch (e) {
      print('Failed to pick image $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    double myHeight = MediaQuery.of(context).size.height;
    double myWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(myHeight * 0.02),
        width: myWidth,
        height: myHeight,
        child: Stack(
          children: [
            Center(
              child: Container(
                width: double.infinity,
                color: Color(0xFF005038),
                height: myHeight * 0.3,
              ),
            ),
            Positioned(
              top: myHeight * 0.25,
              left: myWidth * 0.15,
              child: Text(
                'select color using'.toUpperCase(),
                style: GoogleFonts.anton(
                  textStyle: TextStyle(
                    color: kWhiteColor,
                    // fontSize: myHeight * 0.021,
                    fontSize: myHeight * 0.04,
                  ),
                ),
              ),
            ),
            Positioned(
              top: myHeight * 0.35,
              left: myWidth * 0.36,
              child: SvgPicture.asset(
                kGalleryImage,
                height: myHeight * 0.12,
                // width: myWidth * 0.2,
              ),
            ),
            Positioned(
              top: myHeight * 0.49,
              left: myWidth * 0.38,
              child: Text(
                'Gallery'.toUpperCase(),
                style: GoogleFonts.openSans(
                  textStyle: TextStyle(
                    color: kWhiteColor,
                    // fontSize: myHeight * 0.021,
                    fontSize: myHeight * 0.025,
                  ),
                ),
              ),
            ),
            Positioned(
              top: myHeight * 0.34,
              left: myWidth * 0.02,
              child: Container(
                width: myWidth * 0.88,
                height: myHeight * 0.2,
                color: Colors.white12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
