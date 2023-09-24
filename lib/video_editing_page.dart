import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:screenshot/screenshot.dart';
import 'package:tapioca/tapioca.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;
import 'Components/item_widget_stickers.dart';
import 'Models/Stickers Model/stickers_model.dart';
import 'constant/constants.dart';

//-------------------//
//PICKUP VIDEO SCREEN//
//-------------------//
class VideoPickerPage extends StatefulWidget {
  @override
  _VideoPickerPageState createState() => _VideoPickerPageState();
}

class _VideoPickerPageState extends State<VideoPickerPage> {
  final navigatorKey = GlobalKey<NavigatorState>();
  late XFile _video;
  bool isLoading = false;

  ///
  ScreenshotController screenshotController = ScreenshotController();

  ///

  /// isOnProgress Variable is used for showing Circular Indicator or loader
  bool isOnProgress = false;

  /// isAbsorbPointer Variable is used for freezing the Video Picker
  bool isAbsorbPointer = false;

  ScrollController _scrollController = ScrollController();
  int currentPage = 1;

  @override
  void initState() {
    loadStickersImages(1);
    super.initState();
    _controller = TextEditingController();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  loadStickersImages(int currentPage) async {
    final response =
        await http.get(Uri.parse(url + '/sticker?page=$currentPage'));
    if (response.statusCode == 200) {
      String data = response.body;
      final decodedData = jsonDecode(data)['data'];
      CatalogModelOfStickers.stickers = decodedData
          .map<StickersModel>((item) => StickersModel.fromMap(item))
          .toList();
      setState(() {});
    } else {
      print(response.statusCode);
    }
  }
  //===============End STICKERS==============================

  final url = 'http://15.206.75.95:3000';

  //==================Alert==================================

  //==================Alert==================================

  _pickVideo() async {
    try {
      final ImagePicker _picker = ImagePicker();
      XFile? video = await _picker.pickVideo(source: ImageSource.gallery);
      if (video != null) {
        setState(() {
          _video = video;
          isLoading = true;
          isOnProgress = true;
          isAbsorbPointer = !isAbsorbPointer;
          LinearProgressIndicator(
            backgroundColor: Colors.red,
          );
        });
      } else {
        Fluttertoast.showToast(
            msg: 'Please select video ',
            backgroundColor: kAppBgColor,
            textColor: kWhiteColor);
        isOnProgress = false;
        // isAbsorbPointer = !isAbsorbPointer;
      }
    } catch (error) {
      print(error);
    }
  }

  // Widget _customSnackBar() {
  //   // return Align(
  //   //   alignment: Alignment.bottomCenter,
  //   //   child: SwipeTransition(
  //   //     visible: true,
  //   //     child: Container(
  //   //       height: 200,
  //   //       width: double.infinity,
  //   //       color: Colors.black.withOpacity(0.8),
  //   //       child: Center(
  //   //         child: Text(path),
  //   //       ),
  //   //     ),
  //   //   ),
  //   // );
  // }

  var result;
  var colorResult;
  showDialog() {
    showGeneralDialog(
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 700),
      context: context,
      pageBuilder: (_, __, ___) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.02),
            height: 300,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    print("HELLO");

                    colorResult = "p";
                    Navigator.pop(context, "p");
                  },
                  child: new Container(
                    height: 100,
                    width: 100,
                    decoration: new BoxDecoration(
                      border: Border.all(
                        color: Colors.black26,
                        width: 2,
                      ),
                      borderRadius: new BorderRadius.circular(16.0),
                      color: Color(0xFFFFC0CB),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    colorResult = "w";
                    Navigator.pop(context, "w");
                  },
                  child: Container(
                    height: 100,
                    width: 100,
                    decoration: new BoxDecoration(
                      border: Border.all(
                        color: Colors.black26,
                        width: 2,
                      ),
                      borderRadius: new BorderRadius.circular(16.0),
                      color: Color(0xFFffffff),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    colorResult = "b";
                    Navigator.pop(context, "b");
                  },
                  child: Container(
                    height: 100,
                    width: 100,
                    decoration: new BoxDecoration(
                      border: Border.all(
                        color: Colors.black26,
                        width: 2,
                      ),
                      borderRadius: new BorderRadius.circular(16.0),
                      color: Color(0xFF1f8eed),
                    ),
                  ),
                ),
              ],
            ),
            margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.height * 0.3,
                left: 12,
                right: 12),
            decoration: BoxDecoration(
              color: kAppBgColor,
              borderRadius: BorderRadius.circular(40),
            ),
          ),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        return SlideTransition(
          position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim),
          child: child,
        );
      },
    );
  }

  TextEditingController? _controller;
  showTextDiaglog() {
    showGeneralDialog(
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 700),
      context: context,
      pageBuilder: (_, __, ___) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Material(
            color: Colors.transparent,
            child: Container(
              height: 300,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextField(
                      style: TextStyle(
                          color: kWhiteColor,
                          fontWeight: FontWeight.w700,
                          fontStyle: FontStyle.italic),
                      cursorColor: kAppBgColor,
                      controller: _controller,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: kAppBarColor,
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(15)),
                        suffixIcon: IconButton(
                          icon: Icon(
                            Icons.done,
                            color: kAppBgColor,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        labelText: 'Enter Your Text',
                        labelStyle: TextStyle(
                            color: kAppBgColor, fontWeight: FontWeight.w900),
                      ),
                      onChanged: (text) {},
                    ),
                  ),
                ],
              ),
              margin: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.height * 0.3,
                  left: 12,
                  right: 12),
              decoration: BoxDecoration(
                color: kAppBgColor,
                borderRadius: BorderRadius.circular(40),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        return SlideTransition(
          position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim),
          child: child,
        );
      },
    );
  }

  ///=======================================================================
  showStickersDialogBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: new Icon(Icons.photo),
                title: new Text('Photo'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: new Icon(Icons.music_note),
                title: new Text('Music'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: new Icon(Icons.videocam),
                title: new Text('Video'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: new Icon(Icons.share),
                title: new Text('Share'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              Row(
                children: [
                  ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      Text('2'),
                      Text('2'),
                      Text('2'),
                      Text('2'),
                      Text('2'),
                      Text('2'),
                      Text('2'),
                      Text('2'),
                      Text('2'),
                      Text('2'),
                      Text('2'),
                    ],
                  )
                ],
              )
            ],
          );
        });
  }

  ///=======================================================================

  //=============================STICKERS============================
  PersistentBottomSheetController? _mycontroller;
  showStickerDiaglog() {
    showModalBottomSheet(
      // isScrollControlled: true,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30))),
      backgroundColor: kAppBgColor.withOpacity(0.9),
      context: context,
      builder: (context) {
        return Column(
          children: [
            // Text('Column > Text_A'),
            Expanded(
              // Expanded_A
              child: Column(
                children: [
                  Column(
                    children: [
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                      //   // shrinkWrap: true,
                      //   // scrollDirection: Axis.horizontal,
                      //   children: [
                      //     InkWell(
                      //       onTap: () {
                      //         loadStickersImages(1);
                      //         setState(() {});
                      //       },
                      //       child: Container(
                      //         child: Text(
                      //           '1',
                      //           style: TextStyle(
                      //             fontWeight: FontWeight.w900,
                      //             color: kWhiteColor,
                      //           ),
                      //         ),
                      //         decoration: BoxDecoration(
                      //           color: Colors.orange,
                      //           shape: BoxShape.circle,
                      //         ),
                      //         alignment: Alignment.center,
                      //         height: MediaQuery.of(context).size.height * 0.08,
                      //         width: MediaQuery.of(context).size.width * 0.08,
                      //       ),
                      //     ),
                      //     InkWell(
                      //       onTap: () {
                      //         loadStickersImages(2);
                      //         setState(() {});
                      //       },
                      //       child: Container(
                      //         child: Text(
                      //           '2',
                      //           style: TextStyle(
                      //             fontWeight: FontWeight.w900,
                      //             color: kWhiteColor,
                      //           ),
                      //         ),
                      //         decoration: BoxDecoration(
                      //           color: Colors.orange,
                      //           shape: BoxShape.circle,
                      //         ),
                      //         alignment: Alignment.center,
                      //         height: MediaQuery.of(context).size.height * 0.08,
                      //         width: MediaQuery.of(context).size.width * 0.08,
                      //       ),
                      //     ),
                      //     InkWell(
                      //       onTap: () {
                      //         loadStickersImages(3);
                      //         setState(() {});
                      //       },
                      //       child: Container(
                      //         child: Text(
                      //           '3',
                      //           style: TextStyle(
                      //             fontWeight: FontWeight.w900,
                      //             color: kWhiteColor,
                      //           ),
                      //         ),
                      //         decoration: BoxDecoration(
                      //           color: Colors.orange,
                      //           shape: BoxShape.circle,
                      //         ),
                      //         alignment: Alignment.center,
                      //         height: MediaQuery.of(context).size.height * 0.08,
                      //         width: MediaQuery.of(context).size.width * 0.08,
                      //       ),
                      //     ),
                      //     InkWell(
                      //       onTap: () {
                      //         setState(() {
                      //           loadStickersImages(4);
                      //         });
                      //       },
                      //       child: Container(
                      //         child: Text(
                      //           '4',
                      //           style: TextStyle(
                      //             fontWeight: FontWeight.w900,
                      //             color: kWhiteColor,
                      //           ),
                      //         ),
                      //         decoration: BoxDecoration(
                      //           color: Colors.orange,
                      //           shape: BoxShape.circle,
                      //         ),
                      //         alignment: Alignment.center,
                      //         height: MediaQuery.of(context).size.height * 0.08,
                      //         width: MediaQuery.of(context).size.width * 0.08,
                      //       ),
                      //     )
                      //
                      //     // InkWell(
                      //     //   onTap: () {
                      //     //     setState(() {
                      //     //       loadStickersImages(4);
                      //     //     });
                      //     //   },
                      //     //   child: Container(
                      //     //     child: Text(
                      //     //       '4',
                      //     //       style: TextStyle(
                      //     //         fontWeight: FontWeight.w900,
                      //     //         color: kWhiteColor,
                      //     //       ),
                      //     //     ),
                      //     //     decoration: BoxDecoration(
                      //     //       color: Colors.orange,
                      //     //       shape: BoxShape.circle,
                      //     //     ),
                      //     //     alignment: Alignment.center,
                      //     //     height: MediaQuery.of(context).size.height * 0.08,
                      //     //     width: MediaQuery.of(context).size.width * 0.08,
                      //     //   ),
                      //     // ),
                      //     // InkWell(
                      //     //   onTap: () {
                      //     //     setState(() {
                      //     //       loadStickersImages(4);
                      //     //     });
                      //     //   },
                      //     //   child: Container(
                      //     //     child: Text(
                      //     //       '4',
                      //     //       style: TextStyle(
                      //     //         fontWeight: FontWeight.w900,
                      //     //         color: kWhiteColor,
                      //     //       ),
                      //     //     ),
                      //     //     decoration: BoxDecoration(
                      //     //       color: Colors.orange,
                      //     //       shape: BoxShape.circle,
                      //     //     ),
                      //     //     alignment: Alignment.center,
                      //     //     height: MediaQuery.of(context).size.height * 0.08,
                      //     //     width: MediaQuery.of(context).size.width * 0.08,
                      //     //   ),
                      //     // ),
                      //     // InkWell(
                      //     //   onTap: () {
                      //     //     setState(() {
                      //     //       loadStickersImages(4);
                      //     //     });
                      //     //   },
                      //     //   child: Container(
                      //     //     child: Text(
                      //     //       '4',
                      //     //       style: TextStyle(
                      //     //         fontWeight: FontWeight.w900,
                      //     //         color: kWhiteColor,
                      //     //       ),
                      //     //     ),
                      //     //     decoration: BoxDecoration(
                      //     //       color: Colors.orange,
                      //     //       shape: BoxShape.circle,
                      //     //     ),
                      //     //     alignment: Alignment.center,
                      //     //     height: MediaQuery.of(context).size.height * 0.08,
                      //     //     width: MediaQuery.of(context).size.width * 0.08,
                      //     //   ),
                      //     // ),
                      //     // InkWell(
                      //     //   onTap: () {
                      //     //     setState(() {
                      //     //       loadStickersImages(4);
                      //     //     });
                      //     //   },
                      //     //   child: Container(
                      //     //     child: Text(
                      //     //       '4',
                      //     //       style: TextStyle(
                      //     //         fontWeight: FontWeight.w900,
                      //     //         color: kWhiteColor,
                      //     //       ),
                      //     //     ),
                      //     //     decoration: BoxDecoration(
                      //     //       color: Colors.orange,
                      //     //       shape: BoxShape.circle,
                      //     //     ),
                      //     //     alignment: Alignment.center,
                      //     //     height: MediaQuery.of(context).size.height * 0.08,
                      //     //     width: MediaQuery.of(context).size.width * 0.08,
                      //     //   ),
                      //     // ),
                      //     // InkWell(
                      //     //   onTap: () {
                      //     //     setState(() {
                      //     //       loadStickersImages(4);
                      //     //     });
                      //     //   },
                      //     //   child: Container(
                      //     //     child: Text(
                      //     //       '4',
                      //     //       style: TextStyle(
                      //     //         fontWeight: FontWeight.w900,
                      //     //         color: kWhiteColor,
                      //     //       ),
                      //     //     ),
                      //     //     decoration: BoxDecoration(
                      //     //       color: Colors.orange,
                      //     //       shape: BoxShape.circle,
                      //     //     ),
                      //     //     alignment: Alignment.center,
                      //     //     height: MediaQuery.of(context).size.height * 0.08,
                      //     //     width: MediaQuery.of(context).size.width * 0.08,
                      //     //   ),
                      //     // ),
                      //     // InkWell(
                      //     //   onTap: () {
                      //     //     setState(() {
                      //     //       loadStickersImages(4);
                      //     //     });
                      //     //   },
                      //     //   child: Container(
                      //     //     child: Text(
                      //     //       '4',
                      //     //       style: TextStyle(
                      //     //         fontWeight: FontWeight.w900,
                      //     //         color: kWhiteColor,
                      //     //       ),
                      //     //     ),
                      //     //     decoration: BoxDecoration(
                      //     //       color: Colors.orange,
                      //     //       shape: BoxShape.circle,
                      //     //     ),
                      //     //     alignment: Alignment.center,
                      //     //     height: MediaQuery.of(context).size.height * 0.08,
                      //     //     width: MediaQuery.of(context).size.width * 0.08,
                      //     //   ),
                      //     // ),
                      //     // InkWell(
                      //     //   onTap: () {
                      //     //     setState(() {
                      //     //       loadStickersImages(4);
                      //     //     });
                      //     //   },
                      //     //   child: Container(
                      //     //     child: Text(
                      //     //       '4',
                      //     //       style: TextStyle(
                      //     //         fontWeight: FontWeight.w900,
                      //     //         color: kWhiteColor,
                      //     //       ),
                      //     //     ),
                      //     //     decoration: BoxDecoration(
                      //     //       color: Colors.orange,
                      //     //       shape: BoxShape.circle,
                      //     //     ),
                      //     //     alignment: Alignment.center,
                      //     //     height: MediaQuery.of(context).size.height * 0.08,
                      //     //     width: MediaQuery.of(context).size.width * 0.08,
                      //     //   ),
                      //     // ),
                      //     // InkWell(
                      //     //   onTap: () {
                      //     //     setState(() {
                      //     //       loadStickersImages(4);
                      //     //     });
                      //     //   },
                      //     //   child: Container(
                      //     //     child: Text(
                      //     //       '4',
                      //     //       style: TextStyle(
                      //     //         fontWeight: FontWeight.w900,
                      //     //         color: kWhiteColor,
                      //     //       ),
                      //     //     ),
                      //     //     decoration: BoxDecoration(
                      //     //       color: Colors.orange,
                      //     //       shape: BoxShape.circle,
                      //     //     ),
                      //     //     alignment: Alignment.center,
                      //     //     height: MediaQuery.of(context).size.height * 0.08,
                      //     //     width: MediaQuery.of(context).size.width * 0.08,
                      //     //   ),
                      //     // ),
                      //   ],
                      // ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                      //   // shrinkWrap: true,
                      //   // scrollDirection: Axis.horizontal,
                      //   children: [
                      //     InkWell(
                      //       onTap: () {
                      //         loadStickersImages(1);
                      //         setState(() {});
                      //       },
                      //       child: Container(
                      //         child: Text(
                      //           '1',
                      //           style: TextStyle(
                      //             fontWeight: FontWeight.w900,
                      //             color: kWhiteColor,
                      //           ),
                      //         ),
                      //         decoration: BoxDecoration(
                      //           color: Colors.orange,
                      //           shape: BoxShape.circle,
                      //         ),
                      //         alignment: Alignment.center,
                      //         height: MediaQuery.of(context).size.height * 0.08,
                      //         width: MediaQuery.of(context).size.width * 0.08,
                      //       ),
                      //     ),
                      //     InkWell(
                      //       onTap: () {
                      //         loadStickersImages(2);
                      //         setState(() {});
                      //       },
                      //       child: Container(
                      //         child: Text(
                      //           '2',
                      //           style: TextStyle(
                      //             fontWeight: FontWeight.w900,
                      //             color: kWhiteColor,
                      //           ),
                      //         ),
                      //         decoration: BoxDecoration(
                      //           color: Colors.orange,
                      //           shape: BoxShape.circle,
                      //         ),
                      //         alignment: Alignment.center,
                      //         height: MediaQuery.of(context).size.height * 0.08,
                      //         width: MediaQuery.of(context).size.width * 0.08,
                      //       ),
                      //     ),
                      //     InkWell(
                      //       onTap: () {
                      //         loadStickersImages(3);
                      //         setState(() {});
                      //       },
                      //       child: Container(
                      //         child: Text(
                      //           '3',
                      //           style: TextStyle(
                      //             fontWeight: FontWeight.w900,
                      //             color: kWhiteColor,
                      //           ),
                      //         ),
                      //         decoration: BoxDecoration(
                      //           color: Colors.orange,
                      //           shape: BoxShape.circle,
                      //         ),
                      //         alignment: Alignment.center,
                      //         height: MediaQuery.of(context).size.height * 0.08,
                      //         width: MediaQuery.of(context).size.width * 0.08,
                      //       ),
                      //     ),
                      //     InkWell(
                      //       onTap: () {
                      //         setState(() {
                      //           loadStickersImages(4);
                      //         });
                      //       },
                      //       child: Container(
                      //         child: Text(
                      //           '4',
                      //           style: TextStyle(
                      //             fontWeight: FontWeight.w900,
                      //             color: kWhiteColor,
                      //           ),
                      //         ),
                      //         decoration: BoxDecoration(
                      //           color: Colors.orange,
                      //           shape: BoxShape.circle,
                      //         ),
                      //         alignment: Alignment.center,
                      //         height: MediaQuery.of(context).size.height * 0.08,
                      //         width: MediaQuery.of(context).size.width * 0.08,
                      //       ),
                      //     )
                      //
                      //     // InkWell(
                      //     //   onTap: () {
                      //     //     setState(() {
                      //     //       loadStickersImages(4);
                      //     //     });
                      //     //   },
                      //     //   child: Container(
                      //     //     child: Text(
                      //     //       '4',
                      //     //       style: TextStyle(
                      //     //         fontWeight: FontWeight.w900,
                      //     //         color: kWhiteColor,
                      //     //       ),
                      //     //     ),
                      //     //     decoration: BoxDecoration(
                      //     //       color: Colors.orange,
                      //     //       shape: BoxShape.circle,
                      //     //     ),
                      //     //     alignment: Alignment.center,
                      //     //     height: MediaQuery.of(context).size.height * 0.08,
                      //     //     width: MediaQuery.of(context).size.width * 0.08,
                      //     //   ),
                      //     // ),
                      //     // InkWell(
                      //     //   onTap: () {
                      //     //     setState(() {
                      //     //       loadStickersImages(4);
                      //     //     });
                      //     //   },
                      //     //   child: Container(
                      //     //     child: Text(
                      //     //       '4',
                      //     //       style: TextStyle(
                      //     //         fontWeight: FontWeight.w900,
                      //     //         color: kWhiteColor,
                      //     //       ),
                      //     //     ),
                      //     //     decoration: BoxDecoration(
                      //     //       color: Colors.orange,
                      //     //       shape: BoxShape.circle,
                      //     //     ),
                      //     //     alignment: Alignment.center,
                      //     //     height: MediaQuery.of(context).size.height * 0.08,
                      //     //     width: MediaQuery.of(context).size.width * 0.08,
                      //     //   ),
                      //     // ),
                      //     // InkWell(
                      //     //   onTap: () {
                      //     //     setState(() {
                      //     //       loadStickersImages(4);
                      //     //     });
                      //     //   },
                      //     //   child: Container(
                      //     //     child: Text(
                      //     //       '4',
                      //     //       style: TextStyle(
                      //     //         fontWeight: FontWeight.w900,
                      //     //         color: kWhiteColor,
                      //     //       ),
                      //     //     ),
                      //     //     decoration: BoxDecoration(
                      //     //       color: Colors.orange,
                      //     //       shape: BoxShape.circle,
                      //     //     ),
                      //     //     alignment: Alignment.center,
                      //     //     height: MediaQuery.of(context).size.height * 0.08,
                      //     //     width: MediaQuery.of(context).size.width * 0.08,
                      //     //   ),
                      //     // ),
                      //     // InkWell(
                      //     //   onTap: () {
                      //     //     setState(() {
                      //     //       loadStickersImages(4);
                      //     //     });
                      //     //   },
                      //     //   child: Container(
                      //     //     child: Text(
                      //     //       '4',
                      //     //       style: TextStyle(
                      //     //         fontWeight: FontWeight.w900,
                      //     //         color: kWhiteColor,
                      //     //       ),
                      //     //     ),
                      //     //     decoration: BoxDecoration(
                      //     //       color: Colors.orange,
                      //     //       shape: BoxShape.circle,
                      //     //     ),
                      //     //     alignment: Alignment.center,
                      //     //     height: MediaQuery.of(context).size.height * 0.08,
                      //     //     width: MediaQuery.of(context).size.width * 0.08,
                      //     //   ),
                      //     // ),
                      //     // InkWell(
                      //     //   onTap: () {
                      //     //     setState(() {
                      //     //       loadStickersImages(4);
                      //     //     });
                      //     //   },
                      //     //   child: Container(
                      //     //     child: Text(
                      //     //       '4',
                      //     //       style: TextStyle(
                      //     //         fontWeight: FontWeight.w900,
                      //     //         color: kWhiteColor,
                      //     //       ),
                      //     //     ),
                      //     //     decoration: BoxDecoration(
                      //     //       color: Colors.orange,
                      //     //       shape: BoxShape.circle,
                      //     //     ),
                      //     //     alignment: Alignment.center,
                      //     //     height: MediaQuery.of(context).size.height * 0.08,
                      //     //     width: MediaQuery.of(context).size.width * 0.08,
                      //     //   ),
                      //     // ),
                      //     // InkWell(
                      //     //   onTap: () {
                      //     //     setState(() {
                      //     //       loadStickersImages(4);
                      //     //     });
                      //     //   },
                      //     //   child: Container(
                      //     //     child: Text(
                      //     //       '4',
                      //     //       style: TextStyle(
                      //     //         fontWeight: FontWeight.w900,
                      //     //         color: kWhiteColor,
                      //     //       ),
                      //     //     ),
                      //     //     decoration: BoxDecoration(
                      //     //       color: Colors.orange,
                      //     //       shape: BoxShape.circle,
                      //     //     ),
                      //     //     alignment: Alignment.center,
                      //     //     height: MediaQuery.of(context).size.height * 0.08,
                      //     //     width: MediaQuery.of(context).size.width * 0.08,
                      //     //   ),
                      //     // ),
                      //     // InkWell(
                      //     //   onTap: () {
                      //     //     setState(() {
                      //     //       loadStickersImages(4);
                      //     //     });
                      //     //   },
                      //     //   child: Container(
                      //     //     child: Text(
                      //     //       '4',
                      //     //       style: TextStyle(
                      //     //         fontWeight: FontWeight.w900,
                      //     //         color: kWhiteColor,
                      //     //       ),
                      //     //     ),
                      //     //     decoration: BoxDecoration(
                      //     //       color: Colors.orange,
                      //     //       shape: BoxShape.circle,
                      //     //     ),
                      //     //     alignment: Alignment.center,
                      //     //     height: MediaQuery.of(context).size.height * 0.08,
                      //     //     width: MediaQuery.of(context).size.width * 0.08,
                      //     //   ),
                      //     // ),
                      //     // InkWell(
                      //     //   onTap: () {
                      //     //     setState(() {
                      //     //       loadStickersImages(4);
                      //     //     });
                      //     //   },
                      //     //   child: Container(
                      //     //     child: Text(
                      //     //       '4',
                      //     //       style: TextStyle(
                      //     //         fontWeight: FontWeight.w900,
                      //     //         color: kWhiteColor,
                      //     //       ),
                      //     //     ),
                      //     //     decoration: BoxDecoration(
                      //     //       color: Colors.orange,
                      //     //       shape: BoxShape.circle,
                      //     //     ),
                      //     //     alignment: Alignment.center,
                      //     //     height: MediaQuery.of(context).size.height * 0.08,
                      //     //     width: MediaQuery.of(context).size.width * 0.08,
                      //     //   ),
                      //     // ),
                      //   ],
                      // ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                      //   // shrinkWrap: true,
                      //   // scrollDirection: Axis.horizontal,
                      //   children: [
                      //     InkWell(
                      //       onTap: () {
                      //         loadStickersImages(1);
                      //         setState(() {});
                      //       },
                      //       child: Container(
                      //         child: Text(
                      //           '1',
                      //           style: TextStyle(
                      //             fontWeight: FontWeight.w900,
                      //             color: kWhiteColor,
                      //           ),
                      //         ),
                      //         decoration: BoxDecoration(
                      //           color: Colors.orange,
                      //           shape: BoxShape.circle,
                      //         ),
                      //         alignment: Alignment.center,
                      //         height: MediaQuery.of(context).size.height * 0.08,
                      //         width: MediaQuery.of(context).size.width * 0.08,
                      //       ),
                      //     ),
                      //     InkWell(
                      //       onTap: () {
                      //         loadStickersImages(2);
                      //         setState(() {});
                      //       },
                      //       child: Container(
                      //         child: Text(
                      //           '2',
                      //           style: TextStyle(
                      //             fontWeight: FontWeight.w900,
                      //             color: kWhiteColor,
                      //           ),
                      //         ),
                      //         decoration: BoxDecoration(
                      //           color: Colors.orange,
                      //           shape: BoxShape.circle,
                      //         ),
                      //         alignment: Alignment.center,
                      //         height: MediaQuery.of(context).size.height * 0.08,
                      //         width: MediaQuery.of(context).size.width * 0.08,
                      //       ),
                      //     ),
                      //     InkWell(
                      //       onTap: () {
                      //         loadStickersImages(3);
                      //         setState(() {});
                      //       },
                      //       child: Container(
                      //         child: Text(
                      //           '3',
                      //           style: TextStyle(
                      //             fontWeight: FontWeight.w900,
                      //             color: kWhiteColor,
                      //           ),
                      //         ),
                      //         decoration: BoxDecoration(
                      //           color: Colors.orange,
                      //           shape: BoxShape.circle,
                      //         ),
                      //         alignment: Alignment.center,
                      //         height: MediaQuery.of(context).size.height * 0.08,
                      //         width: MediaQuery.of(context).size.width * 0.08,
                      //       ),
                      //     ),
                      //     InkWell(
                      //       onTap: () {
                      //         setState(() {
                      //           loadStickersImages(4);
                      //         });
                      //       },
                      //       child: Container(
                      //         child: Text(
                      //           '4',
                      //           style: TextStyle(
                      //             fontWeight: FontWeight.w900,
                      //             color: kWhiteColor,
                      //           ),
                      //         ),
                      //         decoration: BoxDecoration(
                      //           color: Colors.orange,
                      //           shape: BoxShape.circle,
                      //         ),
                      //         alignment: Alignment.center,
                      //         height: MediaQuery.of(context).size.height * 0.08,
                      //         width: MediaQuery.of(context).size.width * 0.08,
                      //       ),
                      //     )
                      //
                      //     // InkWell(
                      //     //   onTap: () {
                      //     //     setState(() {
                      //     //       loadStickersImages(4);
                      //     //     });
                      //     //   },
                      //     //   child: Container(
                      //     //     child: Text(
                      //     //       '4',
                      //     //       style: TextStyle(
                      //     //         fontWeight: FontWeight.w900,
                      //     //         color: kWhiteColor,
                      //     //       ),
                      //     //     ),
                      //     //     decoration: BoxDecoration(
                      //     //       color: Colors.orange,
                      //     //       shape: BoxShape.circle,
                      //     //     ),
                      //     //     alignment: Alignment.center,
                      //     //     height: MediaQuery.of(context).size.height * 0.08,
                      //     //     width: MediaQuery.of(context).size.width * 0.08,
                      //     //   ),
                      //     // ),
                      //     // InkWell(
                      //     //   onTap: () {
                      //     //     setState(() {
                      //     //       loadStickersImages(4);
                      //     //     });
                      //     //   },
                      //     //   child: Container(
                      //     //     child: Text(
                      //     //       '4',
                      //     //       style: TextStyle(
                      //     //         fontWeight: FontWeight.w900,
                      //     //         color: kWhiteColor,
                      //     //       ),
                      //     //     ),
                      //     //     decoration: BoxDecoration(
                      //     //       color: Colors.orange,
                      //     //       shape: BoxShape.circle,
                      //     //     ),
                      //     //     alignment: Alignment.center,
                      //     //     height: MediaQuery.of(context).size.height * 0.08,
                      //     //     width: MediaQuery.of(context).size.width * 0.08,
                      //     //   ),
                      //     // ),
                      //     // InkWell(
                      //     //   onTap: () {
                      //     //     setState(() {
                      //     //       loadStickersImages(4);
                      //     //     });
                      //     //   },
                      //     //   child: Container(
                      //     //     child: Text(
                      //     //       '4',
                      //     //       style: TextStyle(
                      //     //         fontWeight: FontWeight.w900,
                      //     //         color: kWhiteColor,
                      //     //       ),
                      //     //     ),
                      //     //     decoration: BoxDecoration(
                      //     //       color: Colors.orange,
                      //     //       shape: BoxShape.circle,
                      //     //     ),
                      //     //     alignment: Alignment.center,
                      //     //     height: MediaQuery.of(context).size.height * 0.08,
                      //     //     width: MediaQuery.of(context).size.width * 0.08,
                      //     //   ),
                      //     // ),
                      //     // InkWell(
                      //     //   onTap: () {
                      //     //     setState(() {
                      //     //       loadStickersImages(4);
                      //     //     });
                      //     //   },
                      //     //   child: Container(
                      //     //     child: Text(
                      //     //       '4',
                      //     //       style: TextStyle(
                      //     //         fontWeight: FontWeight.w900,
                      //     //         color: kWhiteColor,
                      //     //       ),
                      //     //     ),
                      //     //     decoration: BoxDecoration(
                      //     //       color: Colors.orange,
                      //     //       shape: BoxShape.circle,
                      //     //     ),
                      //     //     alignment: Alignment.center,
                      //     //     height: MediaQuery.of(context).size.height * 0.08,
                      //     //     width: MediaQuery.of(context).size.width * 0.08,
                      //     //   ),
                      //     // ),
                      //     // InkWell(
                      //     //   onTap: () {
                      //     //     setState(() {
                      //     //       loadStickersImages(4);
                      //     //     });
                      //     //   },
                      //     //   child: Container(
                      //     //     child: Text(
                      //     //       '4',
                      //     //       style: TextStyle(
                      //     //         fontWeight: FontWeight.w900,
                      //     //         color: kWhiteColor,
                      //     //       ),
                      //     //     ),
                      //     //     decoration: BoxDecoration(
                      //     //       color: Colors.orange,
                      //     //       shape: BoxShape.circle,
                      //     //     ),
                      //     //     alignment: Alignment.center,
                      //     //     height: MediaQuery.of(context).size.height * 0.08,
                      //     //     width: MediaQuery.of(context).size.width * 0.08,
                      //     //   ),
                      //     // ),
                      //     // InkWell(
                      //     //   onTap: () {
                      //     //     setState(() {
                      //     //       loadStickersImages(4);
                      //     //     });
                      //     //   },
                      //     //   child: Container(
                      //     //     child: Text(
                      //     //       '4',
                      //     //       style: TextStyle(
                      //     //         fontWeight: FontWeight.w900,
                      //     //         color: kWhiteColor,
                      //     //       ),
                      //     //     ),
                      //     //     decoration: BoxDecoration(
                      //     //       color: Colors.orange,
                      //     //       shape: BoxShape.circle,
                      //     //     ),
                      //     //     alignment: Alignment.center,
                      //     //     height: MediaQuery.of(context).size.height * 0.08,
                      //     //     width: MediaQuery.of(context).size.width * 0.08,
                      //     //   ),
                      //     // ),
                      //     // InkWell(
                      //     //   onTap: () {
                      //     //     setState(() {
                      //     //       loadStickersImages(4);
                      //     //     });
                      //     //   },
                      //     //   child: Container(
                      //     //     child: Text(
                      //     //       '4',
                      //     //       style: TextStyle(
                      //     //         fontWeight: FontWeight.w900,
                      //     //         color: kWhiteColor,
                      //     //       ),
                      //     //     ),
                      //     //     decoration: BoxDecoration(
                      //     //       color: Colors.orange,
                      //     //       shape: BoxShape.circle,
                      //     //     ),
                      //     //     alignment: Alignment.center,
                      //     //     height: MediaQuery.of(context).size.height * 0.08,
                      //     //     width: MediaQuery.of(context).size.width * 0.08,
                      //     //   ),
                      //     // ),
                      //     // InkWell(
                      //     //   onTap: () {
                      //     //     setState(() {
                      //     //       loadStickersImages(4);
                      //     //     });
                      //     //   },
                      //     //   child: Container(
                      //     //     child: Text(
                      //     //       '4',
                      //     //       style: TextStyle(
                      //     //         fontWeight: FontWeight.w900,
                      //     //         color: kWhiteColor,
                      //     //       ),
                      //     //     ),
                      //     //     decoration: BoxDecoration(
                      //     //       color: Colors.orange,
                      //     //       shape: BoxShape.circle,
                      //     //     ),
                      //     //     alignment: Alignment.center,
                      //     //     height: MediaQuery.of(context).size.height * 0.08,
                      //     //     width: MediaQuery.of(context).size.width * 0.08,
                      //     //   ),
                      //     // ),
                      //   ],
                      // ),
                    ],
                  ),
                  Expanded(
                    // Expanded_B
                    child: Container(
                      // height: myHeight * 0.03,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10))),
                      child: (CatalogModelOfStickers.stickers != null &&
                              CatalogModelOfStickers.stickers.isNotEmpty)
                          ? GridView.builder(
                              controller: _scrollController,
                              physics: BouncingScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                // maxCrossAxisExtent: 200,
                                crossAxisCount: 4,
                                childAspectRatio: 3 / 3,
                              ),
                              itemCount: CatalogModelOfStickers.stickers.length,
                              itemBuilder: (BuildContext ctx, index) {
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      Navigator.pop(context, _scrollController);
                                    });
                                  },
                                  child: ItemStickersWidget(
                                    item:
                                        CatalogModelOfStickers.stickers[index],
                                  ),
                                );
                              })
                          : Center(
                              child: CircularProgressIndicator(
                                color: kCreatePosterColor,
                              ),
                            ),
                    ),
                  )
                ],
              ),
            ),
          ],
        );
      },
    );
    // .whenComplete(() => print('selected'))
    // .then((value) => (_scrollController));
  }
  //============================= END ---============================

  videoExportedAlert() {
    CoolAlert.show(
      backgroundColor: kAppBgColor,
      context: context,
      type: CoolAlertType.success,
      animType: CoolAlertAnimType.scale,
      onConfirmBtnTap: () async {
        Navigator.pop(context);
        //==========================================================
        // Directory? appDocDir = await getExternalStorageDirectory();
        // String appDocPath = appDocDir!.path;
        // print(appDocPath);
        //==========================================================

        ///Start === from here we are saving video to my collection====
        // print("making");
        // final directory = (await getApplicationDocumentsDirectory()).path;
        // print(directory);
        // // var fileName = DateTime.now().microsecondsSinceEpoch;
        // String path = '$directory/Posters';
        // new Directory(path).create();
        // print("here");
        //
        // screenshotController
        //     .captureAndSave(path,
        //         delay: Duration(milliseconds: 10), pixelRatio: 1.5)
        //     .then((value) => Fluttertoast.showToast(
        //         msg: "Video saved in My Collection",
        //         toastLength: Toast.LENGTH_SHORT,
        //         timeInSecForIosWeb: 1,
        //         backgroundColor: Colors.green,
        //         textColor: Colors.white,
        //         fontSize: 16.0))
        //     .catchError(
        //   (onError) {
        //     print(onError);
        //   },
        // );

        /// ----- END === from here we are saving video to my collection====
        setState(() {
          /// =====this used for loader for video editor Circular Loader=========
          if (isOnProgress == true) {
            isOnProgress = !isOnProgress;
          } else {
            isOnProgress = true;
          }

          ///========== END OF FREEZING THE VIDEO EDITOR CONDITION=========

          /// this condition is used for freezing the Video Picker until and unless the previous exported successfully.
          if (isAbsorbPointer == true) {
            isAbsorbPointer = !isAbsorbPointer;
          } else {
            isAbsorbPointer = false;
          }

          /// =======END OF FREEZING THE VIDEO EDITOR CONDITION==========
        });
      },
      confirmBtnColor: kAppBarColor,
      title: 'Exported Successfully',
      text: 'Please find the exported video in the Gallery.',
    );
  }

  // videoExportingAlert() {
  //   CoolAlert.show(
  //     backgroundColor: kAppBgColor,
  //     context: context,
  //     type: CoolAlertType.loading,
  //     animType: CoolAlertAnimType.scale,
  //     onConfirmBtnTap: () {
  //       Navigator.pop(context);
  //       setState(() {
  //         if (isOnProgress == true) {
  //           isOnProgress = !isOnProgress;
  //         } else {
  //           isOnProgress = true;
  //         }
  //       });
  //     },
  //     // confirmBtnColor: kAppBarColor,
  //     title: 'Exporting',
  //     text: 'Please wait.',
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    double myHeight = MediaQuery.of(context).size.height;
    double myWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(myHeight * 0.02),
          width: myWidth,
          height: myHeight,
          child: Stack(
            children: [
              Center(
                child: Container(
                  width: double.infinity,
                  color: kAppBarColor,
                  height: myHeight * 0.3,
                ),
              ),
              Positioned(
                top: myHeight * 0.42,
                left: myWidth * 0.02,
                child: GestureDetector(
                  onTap: () {
                    print('Clicked on gallery');
                  },
                  child: Container(
                    width: myWidth * 0.88,
                    height: myHeight * 0.2,
                    color: kAppBgColor,
                  ),
                ),
              ),
              Positioned(
                top: myHeight * 0.34,
                left: myWidth * 0.18,
                child: Text(
                  'select Video using'.toUpperCase(),
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
                top: myHeight * 0.43,
                left: myWidth * 0.35,
                child: SvgPicture.asset(
                  kGalleryImage,
                  height: myHeight * 0.12,
                  // width: myWidth * 0.2,
                ),
              ),
              Positioned(
                top: myHeight * 0.56,
                left: myWidth * 0.37,
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

              //=================Loader================
              Visibility(
                visible: isOnProgress,
                child: Positioned(
                  top: myHeight * 0.66,
                  left: myWidth * 0.44,
                  child: CircularProgressIndicator(
                    strokeWidth: 11,
                    backgroundColor: kAppBgColor,
                    valueColor: new AlwaysStoppedAnimation<Color>(kAppBarColor),
                    // color: kAppBarColor,
                  ),
                ),
              ),
              //------------------------

              //=================Loader================
              Positioned(
                top: myHeight * 0.42,
                left: myWidth * 0.02,
                child: AbsorbPointer(
                  absorbing: isAbsorbPointer,
                  child: GestureDetector(
                    onTap: () async {
                      setState(() {
                        // isOnProgress = !isOnProgress;
                      });
                      print("clicked!");

                      /// isAbsorbPointer Variable is used for freezing the Video Picker
                      // isAbsorbPointer = !isAbsorbPointer;
                      await _pickVideo();

                      var tempDir = await getTemporaryDirectory();

                      final path =
                          '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}result.mp4';
                      print(tempDir);
                      final imageBitmap =
                          // (await rootBundle.load(_scrollController.toString()))
                          (await rootBundle.load("images/text.png"))
                              .buffer
                              .asUint8List();
                      try {
                        final tapiocaBalls = [
                          TapiocaBall.filter(colorResult == "b"
                              ? Filters.blue
                              : colorResult == "p"
                                  ? Filters.pink
                                  : colorResult == "w"
                                      ? Filters.white
                                      : Filters.pink),
                          TapiocaBall.textOverlay(_controller!.text.toString(),
                              100, 10, 100, Color(0xffffc0cb)),
                          TapiocaBall.imageOverlay(imageBitmap, 300, 300),
                        ];
                        final cup = Cup(Content(_video.path), tapiocaBalls);
                        cup.suckUp(path).then((_) async {
                          print("finished");
                          //Successful Exported Message
                          videoExportedAlert();
                          // print(path);
                          //===========================================
                          Directory tempDir =
                              await getApplicationDocumentsDirectory();
                          String tempPath = tempDir.path;
                          print('Path Demo== $tempPath');
                          //===========================================
                          GallerySaver.saveVideo(path).then((bool? success) {
                            print(success.toString());
                          });
                          final currentState = navigatorKey.currentState;
                          if (currentState != null) {
                            currentState.push(
                              MaterialPageRoute(
                                  builder: (context) => VideoScreen(path)),
                            );
                          }

                          setState(() {
                            isLoading = false;
                          });
                        });
                      } on PlatformException {
                        print("error!!!!");
                      }
                    },
                  ),
                ),
              ),

              ///===========================================================
              Positioned(
                top: myHeight * 0.05,
                child: Container(
                  height: 90,
                  width: MediaQuery.of(context).size.width,
                  color: kAppBarColor,
                  child: Row(
                    children: [
                      Container(width: 0.2, color: Colors.white),
                      Container(
                          child: Text(
                        ' stickers pagi..',
                        style: GoogleFonts.anton(
                          textStyle: TextStyle(
                              color: kWhiteColor, fontSize: myHeight * 0.020),
                        ),
                      )),
                      Container(width: 0.2, color: Colors.white),
                      Container(
                        child: TextButton(
                            style: TextButton.styleFrom(
                              textStyle: const TextStyle(fontSize: 20),
                            ),
                            onPressed: () async {
                              loadStickersImages(1);
                              setState(() {});
                            },
                            child: Text(
                              '1',
                              style: GoogleFonts.anton(
                                textStyle: TextStyle(
                                    color: kWhiteColor,
                                    fontSize: myHeight * 0.02),
                              ),
                            )),
                      ),
                      Container(width: 0.2, color: Colors.white),
                      Container(
                        child: TextButton(
                            style: TextButton.styleFrom(
                              textStyle: const TextStyle(fontSize: 20),
                            ),
                            onPressed: () async {
                              loadStickersImages(2);
                              setState(() {});
                            },
                            child: Text(
                              '2',
                              style: GoogleFonts.anton(
                                textStyle: TextStyle(
                                    color: kWhiteColor,
                                    fontSize: myHeight * 0.02),
                              ),
                            )),
                      ),
                      Container(width: 0.2, color: Colors.white),
                      Container(
                        child: TextButton(
                            style: TextButton.styleFrom(
                              textStyle: const TextStyle(fontSize: 20),
                            ),
                            onPressed: () async {
                              loadStickersImages(3);
                              setState(() {});
                            },
                            child: Text(
                              '3',
                              style: GoogleFonts.anton(
                                textStyle: TextStyle(
                                    color: kWhiteColor,
                                    fontSize: myHeight * 0.02),
                              ),
                            )),
                      ),
                      Container(width: 0.2, color: Colors.white),
                      Container(
                        child: TextButton(
                            style: TextButton.styleFrom(
                              textStyle: const TextStyle(fontSize: 20),
                            ),
                            onPressed: () async {
                              loadStickersImages(4);
                              setState(() {});
                            },
                            child: Text(
                              '4',
                              style: GoogleFonts.anton(
                                textStyle: TextStyle(
                                    color: kWhiteColor,
                                    fontSize: myHeight * 0.02),
                              ),
                            )),
                      ),
                    ],
                  ),
                ),
              ),

              ///===========================================================

              Positioned(
                bottom: 1,
                child: Container(
                  height: 90,
                  width: MediaQuery.of(context).size.width,
                  color: kAppBarColor,
                  child: Row(
                    children: [
                      Container(
                        child: TextButton(
                            style: TextButton.styleFrom(
                              textStyle: const TextStyle(fontSize: 20),
                            ),
                            onPressed: () async {
                              showTextDiaglog();
                              setState(() {});
                            },
                            child: Text(
                              't',
                              style: GoogleFonts.anton(
                                textStyle: TextStyle(
                                    color: kWhiteColor,
                                    fontSize: myHeight * 0.034),
                              ),
                            )),
                      ),
                      Container(width: 0.2, color: Colors.white),
                      Container(
                        child: TextButton(
                            style: TextButton.styleFrom(
                              textStyle: const TextStyle(fontSize: 20),
                            ),
                            onPressed: () async {
                              showDialog();

                              setState(() {});
                              print(colorResult);
                            },
                            child: Text(
                              'Filter',
                              style: GoogleFonts.anton(
                                textStyle: TextStyle(
                                    color: kWhiteColor,
                                    fontSize: myHeight * 0.020),
                              ),
                            )),
                      ),
                      Container(width: 0.2, color: Colors.white),
                      Container(
                        child: TextButton(
                            style: TextButton.styleFrom(
                              textStyle: const TextStyle(fontSize: 20),
                            ),
                            onPressed: () async {
                              setState(() {});
                              showStickerDiaglog();
                              // showStickersDialogBottomSheet();
                            },
                            child: Text(
                              'stickers',
                              style: GoogleFonts.anton(
                                textStyle: TextStyle(
                                    color: kWhiteColor,
                                    fontSize: myHeight * 0.020),
                              ),
                            )),
                      ),
                      Container(width: 0.2, color: Colors.white),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class VideoScreen extends StatefulWidget {
  final String path;

  VideoScreen(this.path);

  @override
  _VideoAppState createState() => _VideoAppState(path);
}

class _VideoAppState extends State<VideoScreen> {
  final String path;

  _VideoAppState(this.path);

  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(File(path))
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : Container(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _controller.value.isPlaying
                ? _controller.pause()
                : _controller.play();
          });
        },
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
