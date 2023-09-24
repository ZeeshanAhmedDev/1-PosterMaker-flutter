// import 'dart:io';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:poster_maker/Components/video_editor_componenet.dart';
// import 'package:poster_maker/constant/constants.dart';
//
// class VideoTrimmer extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     double myHeight = MediaQuery.of(context).size.height;
//     double myWidth = MediaQuery.of(context).size.width;
//     return Scaffold(
//       body: Container(
//         padding: EdgeInsets.all(myHeight * 0.02),
//         width: myWidth,
//         height: myHeight,
//         child: Stack(
//           children: [
//             Center(
//               child: Container(
//                 width: double.infinity,
//                 color: Color(0xFF005038),
//                 height: myHeight * 0.3,
//               ),
//             ),
//             Positioned(
//               top: myHeight * 0.34,
//               left: myWidth * 0.18,
//               child: Text(
//                 'select Video using'.toUpperCase(),
//                 style: GoogleFonts.anton(
//                   textStyle: TextStyle(
//                     color: kWhiteColor,
//                     // fontSize: myHeight * 0.021,
//                     fontSize: myHeight * 0.04,
//                   ),
//                 ),
//               ),
//             ),
//             Positioned(
//               top: myHeight * 0.43,
//               left: myWidth * 0.35,
//               child: SvgPicture.asset(
//                 kGalleryImage,
//                 height: myHeight * 0.12,
//                 // width: myWidth * 0.2,
//               ),
//             ),
//             Positioned(
//               top: myHeight * 0.56,
//               left: myWidth * 0.37,
//               child: Text(
//                 'Gallery'.toUpperCase(),
//                 style: GoogleFonts.openSans(
//                   textStyle: TextStyle(
//                     color: kWhiteColor,
//                     // fontSize: myHeight * 0.021,
//                     fontSize: myHeight * 0.025,
//                   ),
//                 ),
//               ),
//             ),
//             Positioned(
//               top: myHeight * 0.42,
//               left: myWidth * 0.02,
//               child: GestureDetector(
//                 onTap: () async {
//                   FilePickerResult? result =
//                       await FilePicker.platform.pickFiles(
//                     type: FileType.video,
//                     allowCompression: false,
//                   );
//                   if (result != null) {
//                     File file = File(result.files.single.path!);
//                     Navigator.of(context).push(
//                       MaterialPageRoute(builder: (context) {
//                         return TrimmerView(file);
//                       }),
//                     );
//                   }
//                 },
//                 child: Container(
//                   width: myWidth * 0.88,
//                   height: myHeight * 0.2,
//                   color: Colors.white12,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
