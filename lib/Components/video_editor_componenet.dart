// import 'dart:developer';
// import 'dart:io';
// // import 'package:firebase_crashlytics/firebase_crashlytics.dart';
// import 'package:flutter/material.dart';
// import 'package:gallery_saver/gallery_saver.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:poster_maker/constant/constants.dart';
// import 'package:video_trimmer/video_trimmer.dart';
// // import 'package:firebase_crashlytics/firebase_crashlytics.dart';
//
// class TrimmerView extends StatefulWidget {
//   final File file;
//
//   TrimmerView(this.file);
//
//   @override
//   _TrimmerViewState createState() => _TrimmerViewState();
// }
//
// class _TrimmerViewState extends State<TrimmerView> {
//   final Trimmer _trimmer = Trimmer();
//
//   double _startValue = 0.0;
//   double _endValue = 0.0;
//
//   bool _isPlaying = false;
//   bool _progressVisibility = false;
//
//   Future<String?> _saveVideo() async {
//     setState(() {
//       _progressVisibility = true;
//     });
//
//     String? _value;
//
//     await _trimmer
//         .saveTrimmedVideo(startValue: _startValue, endValue: _endValue)
//         .then((value) {
//       setState(() {
//         _progressVisibility = false;
//         _value = value;
//       });
//     });
//
//     return _value;
//   }
//
//   void _loadVideo() {
//     _trimmer.loadVideo(videoFile: widget.file);
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     // FirebaseCrashlytics.instance.crash();
//
//     _loadVideo();
//   }
//
//   ////////////////////////////////////////////////////////////
//   Future<void> _deleteCacheDir() async {
//     final cacheDir = await getTemporaryDirectory();
//
//     if (cacheDir.existsSync()) {
//       cacheDir.deleteSync(recursive: true);
//     }
//   }
//
//   Future<void> _deleteAppDir() async {
//     final appDir = await getApplicationSupportDirectory();
//
//     if (appDir.existsSync()) {
//       appDir.deleteSync(recursive: true);
//     }
//   }
//   ////////////////////////////////////////////////////////////
//
//   @override
//   Widget build(BuildContext context) {
//     double myHeight = MediaQuery.of(context).size.height;
//     double myWidth = MediaQuery.of(context).size.width;
//     return Scaffold(
//       body: SafeArea(
//         child: Builder(
//           builder: (context) => Center(
//             child: Container(
//               padding: EdgeInsets.only(bottom: 30.0),
//               color: kAppBgColor,
//               // color: Colors.purple,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 mainAxisSize: MainAxisSize.max,
//                 children: [
//                   Visibility(
//                     visible: _progressVisibility,
//                     child: CircularProgressIndicator(
//                         backgroundColor: Colors.red,
//                         valueColor:
//                             AlwaysStoppedAnimation<Color>(Colors.white)),
//                   ),
//                   SizedBox(
//                     height: myHeight * 0.03,
//                   ),
//                   Expanded(
//                     child: VideoViewer(trimmer: _trimmer),
//                   ),
//                   Center(
//                     child: TrimEditor(
//                       trimmer: _trimmer,
//                       viewerHeight: 50.0,
//                       viewerWidth: MediaQuery.of(context).size.width,
//                       maxVideoLength: Duration(seconds: 10),
//                       onChangeStart: (value) {
//                         _startValue = value;
//                       },
//                       onChangeEnd: (value) {
//                         _endValue = value;
//                       },
//                       onChangePlaybackState: (value) {
//                         setState(() {
//                           _isPlaying = value;
//                         });
//                       },
//                     ),
//                   ),
//                   TextButton(
//                     child: _isPlaying
//                         ? Icon(
//                             Icons.pause,
//                             size: 80.0,
//                             color: Colors.white,
//                           )
//                         : Icon(
//                             Icons.play_arrow,
//                             size: 80.0,
//                             color: Colors.white,
//                           ),
//                     onPressed: () async {
//                       bool playbackState = await _trimmer.videPlaybackControl(
//                         startValue: _startValue,
//                         endValue: _endValue,
//                       );
//                       setState(() {
//                         _isPlaying = playbackState;
//                       });
//                     },
//                   ),
//                   ElevatedButton(
//                     onPressed: _progressVisibility
//                         ? null
//                         : () async {
//                             _saveVideo().then((outputPath) {
//                               GallerySaver.saveVideo(outputPath!);
//                               print('OUTPUT PATH: $outputPath');
//                               final snackBar = SnackBar(
//                                   backgroundColor: kAppBarColor,
//                                   content: Text(
//                                     'Video Saved successfully',
//                                     textAlign: TextAlign.center,
//                                     style: TextStyle(color: Colors.white),
//                                   ));
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 snackBar,
//                               );
//                             });
//                           },
//                     child: Text("SAVE"),
//                   ),
//                   import 'package:firebase_crashlytics/firebase_crashlytics.dart';
//
// ElevatedButton(
//                     onPressed: _progressVisibility
//                         ? null
//                         : () async {
//                             try {
//                               _saveVideo().then((outputPath) {
//                                 GallerySaver.saveVideo(outputPath!);
//                                 _deleteCacheDir();
//                                 // _deleteAppDir();
//                                 print('OUTPUT PATH: $outputPath');
//                                 final snackBar = SnackBar(
//                                     backgroundColor: kAppBarColor,
//                                     content: Text(
//                                       'Video Saved successfully',
//                                       textAlign: TextAlign.center,
//                                       style: TextStyle(color: Colors.white),
//                                     ));
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   snackBar,
//                                 );
//                               });
//                               throw Error();
//                             } catch (e, s) {
//                               await FirebaseCrashlytics.instance
//                                   .recordError(e, s, reason: e);
//                             }
//                           },
//                     child: const Text('SAVE'),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
