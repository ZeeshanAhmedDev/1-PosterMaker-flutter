import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:poster_maker/EditImageScreen/resizeWidget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:poster_maker/constant/constants.dart';
import 'package:screenshot/screenshot.dart';

Future<void> showMyDialog(BuildContext context, double myHeight, double myWidth,
    ScreenshotController screenshotController) async {
  return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          //this right here
          child: Container(
            height: myHeight * 0.25,
            width: myWidth * 0.8,
            child: Column(
              children: [
                Container(
                    color: kAppBarColor,
                    height: myHeight * 0.05,
                    child: Center(
                        child: Text(
                      "SAVE AS",
                      style: GoogleFonts.anton(
                        textStyle: TextStyle(
                          color: kWhiteColor,
                          // fontSize: myHeight * 0.021,
                          fontSize: myHeight * 0.028,
                        ),
                      ),
                    ))),
                Container(
                  height: myHeight * 0.2,
                  color: kcolorCheck,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: myWidth * 0.03),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(bottom: myHeight * 0.01),
                              child: Text(
                                "Design - Lets you rework",
                                style: TextStyle(
                                    fontSize: myHeight * 0.02,
                                    color: Color(0xfff2f2f2)),
                                maxLines: 1,
                              ),
                            ),
                            Text(
                                "Image - Is final Picture for sharing and Posting.",
                                style: TextStyle(
                                  fontSize: myHeight * 0.02,
                                  color: Color(0xfff2f2f2),
                                ),
                                maxLines: 2)
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          MaterialButton(
                            minWidth: myWidth * 0.34,
                            height: myHeight * 0.047,
                            color: kAppBarColor,
                            child: Text(
                              "DESIGN",
                              style: GoogleFonts.anton(
                                textStyle: TextStyle(
                                  color: kWhiteColor,
                                  fontWeight: FontWeight.w400,
                                  fontSize: myHeight * 0.022,
                                ),
                              ),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          MaterialButton(
                              minWidth: myWidth * 0.34,
                              height: myHeight * 0.047,
                              color: kAppBarColor,
                              child: Text(
                                "IMAGE",
                                style: GoogleFonts.anton(
                                  textStyle: TextStyle(
                                    color: kWhiteColor,
                                    fontWeight: FontWeight.w400,
                                    fontSize: myHeight * 0.022,
                                  ),
                                ),
                              ),
                              onPressed: () async {
                                Navigator.pop(context);
                                print("making");
                                final directory =
                                    (await getApplicationDocumentsDirectory())
                                        .path;
                                print(directory);
                                var fileName =
                                    DateTime.now().microsecondsSinceEpoch;
                                String path = '$directory/Posters';
                                new Directory(path).create();
                                print("here");

                                screenshotController
                                    .captureAndSave(path,
                                        delay: Duration(milliseconds: 10),
                                        pixelRatio: 1.5)
                                    .then((value) => Fluttertoast.showToast(
                                        msg: "Poster saved in My Poster",
                                        toastLength: Toast.LENGTH_SHORT,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.green,
                                        textColor: Colors.white,
                                        fontSize: 16.0))
                                    .catchError(
                                  (onError) {
                                    print(onError);
                                  },
                                );
                              })
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      });
}
