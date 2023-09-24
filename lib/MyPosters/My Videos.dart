// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:poster_maker/MyPosters/popupMenu.dart';
//
// class MyVideos extends StatefulWidget {
//   const MyVideos({Key? key}) : super(key: key);
//
//   @override
//   _MyVideosState createState() => _MyVideosState();
// }
//
// class _MyVideosState extends State<MyVideos> {
//   List<String> videos = [];
//
//   getVideos() async {
//     try {
//       videos = [];
//       final dir = await getApplicationDocumentsDirectory();
//       final videosDirectory = new Directory(dir.path + "/Videos");
//       if (await videosDirectory.exists()) {
//         final _videosFile =
//             videosDirectory.listSync(followLinks: false, recursive: true);
//         _videosFile.forEach((vdo) {
//           setState(() {
//             videos.add(vdo.path.toString());
//           });
//         });
//       }
//     } catch (e) {
//       Fluttertoast.showToast(msg: e.toString());
//     }
//   }
//
//   deleteVideo(int index) async {
//     try {
//       setState(() {});
//       final file = await File(videos[index]);
//       await file.delete();
//       setState(() {});
//       Fluttertoast.showToast(msg: "Your video has been deleted");
//     } catch (e) {
//       Fluttertoast.showToast(msg: e.toString());
//     }
//   }
//
//   @override
//   void initState() {
//     getVideos();
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     double myHeight = MediaQuery.of(context).size.height;
//     double myWidth = MediaQuery.of(context).size.width;
//     return Scaffold(
//       body: SafeArea(
//         child: videos.length == 0
//             ? Center(child: Text("No Video Saved"))
//             : GridView.builder(
//                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 2),
//                 itemCount: videos.length,
//                 itemBuilder: (BuildContext ctx, index) {
//                   return Stack(children: [
//                     Padding(
//                       padding: const EdgeInsets.all(4.0),
//                       child: Container(
//                         //alignment: Alignment.center,
//                         child: Padding(
//                           padding: const EdgeInsets.all(2.0),
//                           child: ClipRRect(
//                             borderRadius: BorderRadius.circular(15.0),
//                             child: Image.file(
//                               File(videos[index]),
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                         ),
//                         decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(15),
//                             color: Colors.grey.shade300),
//                       ),
//                     ),
//                     Positioned(
//                       right: -3,
//                       top: 0,
//                       child: popupMenu(context, () {
//                         deleteVideo(index);
//                         getVideos();
//                       }, videos[index]),
//                     )
//                   ]);
//                 }),
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';
//
// class MyVideosos extends StatefulWidget {
//   const MyVideosos({Key? key}) : super(key: key);
//
//   @override
//   _MyVideososState createState() => _MyVideososState();
// }
//
// class _MyVideososState extends State<MyVideosos> {
//   int _counter = 0;
//   String? dirPath;
//   bool loading = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: ListView(
//         children: <Widget>[
//           Container(
//             padding: const EdgeInsets.all(20),
//             child: loading
//                 ? CircularProgressIndicator()
//                 : NetworkPlayerLifeCycle(
//                     '$dirPath', // with the String dirPath I have error but if I use the same path but write like this  /data/user/0/com.XXXXX.flutter_video_test/app_flutter/Movies/2019-11-08.mp4 it's ok ... why ?
//                     (BuildContext context, VideoPlayerController controller) =>
//                         AspectRatioVideo(controller)),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class VideoPlayPause extends StatefulWidget {
//   VideoPlayPause(this.controller);
//
//   final VideoPlayerController controller;
//
//   @override
//   State createState() {
//     return _VideoPlayPauseState();
//   }
// }
//
// class _VideoPlayPauseState extends State<VideoPlayPause> {
//   FadeAnimation imageFadeAnim =
//       FadeAnimation(child: const Icon(Icons.play_arrow, size: 100.0));
//   late VoidCallback listener;
//
//   VideoPlayerController get controller => widget.controller;
//
//   @override
//   void initState() {
//     super.initState();
//     controller.addListener(listener);
//     controller.setVolume(1.0);
//     controller.play();
//   }
//
//   @override
//   void deactivate() {
//     controller.setVolume(0.0);
//     controller.removeListener(listener);
//     super.deactivate();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final List<Widget> children = <Widget>[
//       GestureDetector(
//         child: VideoPlayer(controller),
//         onTap: () {
//           if (!controller.value.isInitialized) {
//             return;
//           }
//           if (controller.value.isPlaying) {
//             imageFadeAnim =
//                 FadeAnimation(child: const Icon(Icons.pause, size: 100.0));
//             controller.pause();
//           } else {
//             imageFadeAnim =
//                 FadeAnimation(child: const Icon(Icons.play_arrow, size: 100.0));
//             controller.play();
//           }
//         },
//       ),
//       Align(
//         alignment: Alignment.bottomCenter,
//         child: VideoProgressIndicator(
//           controller,
//           allowScrubbing: true,
//         ),
//       ),
//       Center(child: imageFadeAnim),
//       Center(
//           child: controller.value.isBuffering
//               ? const CircularProgressIndicator()
//               : null),
//     ];
//
//     return Stack(
//       fit: StackFit.passthrough,
//       children: children,
//     );
//   }
// }
//
// class FadeAnimation extends StatefulWidget {
//   FadeAnimation(
//       {required this.child, this.duration = const Duration(milliseconds: 500)});
//
//   final Widget child;
//   final Duration duration;
//
//   @override
//   _FadeAnimationState createState() => _FadeAnimationState();
// }
//
// class _FadeAnimationState extends State<FadeAnimation>
//     with SingleTickerProviderStateMixin {
//   late AnimationController animationController;
//
//   @override
//   void initState() {
//     super.initState();
//     animationController =
//         AnimationController(duration: widget.duration, vsync: this);
//     animationController.addListener(() {
//       if (mounted) {
//         setState(() {});
//       }
//     });
//     animationController.forward(from: 0.0);
//   }
//
//   @override
//   void deactivate() {
//     animationController.stop();
//     super.deactivate();
//   }
//
//   @override
//   void didUpdateWidget(FadeAnimation oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (oldWidget.child != widget.child) {
//       animationController.forward(from: 0.0);
//     }
//   }
//
//   @override
//   void dispose() {
//     animationController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return animationController.isAnimating
//         ? Opacity(
//             opacity: 1.0 - animationController.value,
//             child: widget.child,
//           )
//         : Container();
//   }
// }
//
// typedef Widget VideoWidgetBuilder(
//     BuildContext context, VideoPlayerController controller);
//
// abstract class PlayerLifeCycle extends StatefulWidget {
//   PlayerLifeCycle(this.dataSource, this.childBuilder);
//
//   final VideoWidgetBuilder childBuilder;
//   final String dataSource;
// }
//
// /// A widget connecting its life cycle to a [VideoPlayerController] using
// /// a data source from the network.
// class NetworkPlayerLifeCycle extends PlayerLifeCycle {
//   NetworkPlayerLifeCycle(String dataSource, VideoWidgetBuilder childBuilder)
//       : super(dataSource, childBuilder);
//
//   @override
//   _NetworkPlayerLifeCycleState createState() => _NetworkPlayerLifeCycleState();
// }
//
// /// A widget connecting its life cycle to a [VideoPlayerController] using
// /// an asset as data source
// class AssetPlayerLifeCycle extends PlayerLifeCycle {
//   AssetPlayerLifeCycle(String dataSource, VideoWidgetBuilder childBuilder)
//       : super(dataSource, childBuilder);
//
//   @override
//   _AssetPlayerLifeCycleState createState() => _AssetPlayerLifeCycleState();
// }
//
// abstract class _PlayerLifeCycleState extends State<PlayerLifeCycle> {
//   late VideoPlayerController controller;
//
//   @override
//
//   /// Subclasses should implement [createVideoPlayerController], which is used
//   /// by this method.
//   void initState() {
//     super.initState();
//     controller = createVideoPlayerController();
//     controller.addListener(() {
//       if (controller.value.hasError) {
//         print(controller.value.errorDescription);
//       }
//     });
//     controller.initialize();
//     controller.setLooping(true);
//     controller.play();
//   }
//
//   @override
//   void deactivate() {
//     super.deactivate();
//   }
//
//   @override
//   void dispose() {
//     controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return widget.childBuilder(context, controller);
//   }
//
//   VideoPlayerController createVideoPlayerController();
// }
//
// class _NetworkPlayerLifeCycleState extends _PlayerLifeCycleState {
//   @override
//   VideoPlayerController createVideoPlayerController() {
//     return VideoPlayerController.network(widget.dataSource);
//   }
// }
//
// class _AssetPlayerLifeCycleState extends _PlayerLifeCycleState {
//   @override
//   VideoPlayerController createVideoPlayerController() {
//     return VideoPlayerController.asset(widget.dataSource);
//   }
// }
//
// /// A filler card to show the video in a list of scrolling contents.
// Widget buildCard(String title) {
//   return Card(
//     child: Column(
//       mainAxisSize: MainAxisSize.min,
//       children: <Widget>[
//         ListTile(
//           leading: const Icon(Icons.airline_seat_flat_angled),
//           title: Text(title),
//         ),
//         // TODO(jackson): Remove when deprecation is on stable branch
//         // ignore: deprecated_member_use
//         ButtonTheme(
//           child: ButtonBar(
//             children: <Widget>[
//               FlatButton(
//                 child: const Text('BUY TICKETS'),
//                 onPressed: () {
//                   /* ... */
//                 },
//               ),
//               FlatButton(
//                 child: const Text('SELL TICKETS'),
//                 onPressed: () {
//                   /* ... */
//                 },
//               ),
//             ],
//           ),
//         ),
//       ],
//     ),
//   );
// }
//
// class VideoInListOfCards extends StatelessWidget {
//   VideoInListOfCards(this.controller);
//
//   final VideoPlayerController controller;
//
//   @override
//   Widget build(BuildContext context) {
//     return ListView(
//       children: <Widget>[
//         buildCard("Item a"),
//         buildCard("Item b"),
//         buildCard("Item c"),
//         buildCard("Item d"),
//         buildCard("Item e"),
//         buildCard("Item f"),
//         buildCard("Item g"),
//         Card(
//             child: Column(children: <Widget>[
//           Column(
//             children: <Widget>[
//               const ListTile(
//                 leading: Icon(Icons.cake),
//                 title: Text("Video video"),
//               ),
//               Stack(
//                   alignment: FractionalOffset.bottomRight +
//                       const FractionalOffset(-0.1, -0.1),
//                   children: <Widget>[
//                     AspectRatioVideo(controller),
//                     Image.asset('assets/flutter-mark-square-64.png'),
//                   ]),
//             ],
//           ),
//         ])),
//         buildCard("Item h"),
//         buildCard("Item i"),
//         buildCard("Item j"),
//         buildCard("Item k"),
//         buildCard("Item l"),
//       ],
//     );
//   }
// }
//
// class AspectRatioVideo extends StatefulWidget {
//   AspectRatioVideo(this.controller);
//
//   final VideoPlayerController controller;
//
//   @override
//   AspectRatioVideoState createState() => AspectRatioVideoState();
// }
//
// class AspectRatioVideoState extends State<AspectRatioVideo> {
//   VideoPlayerController get controller => widget.controller;
//   bool initialized = false;
//
//   late VoidCallback listener;
//
//   @override
//   void initState() {
//     super.initState();
//     listener = () {
//       if (!mounted) {
//         return;
//       }
//       if (initialized != controller.value.isInitialized) {
//         initialized = controller.value.isInitialized;
//         setState(() {});
//       }
//     };
//     controller.addListener(listener);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (initialized) {
//       return Center(
//         child: AspectRatio(
//           aspectRatio: controller.value.aspectRatio,
//           child: VideoPlayPause(controller),
//         ),
//       );
//     } else {
//       return Container();
//     }
//   }
// }
// import 'dart:io';
//
// import 'package:path_provider/path_provider.dart';
// import 'package:video_player/video_player.dart';
// import 'package:flutter/material.dart';
//
// class VideoApp extends StatefulWidget {
//   @override
//   _VideoAppState createState() => _VideoAppState();
// }
//
// class _VideoAppState extends State<VideoApp> {
//   late VideoPlayerController _controller;
//
//   late Future<File> $pathdir = getdata();
//   getdata() async {
//     //==========================================================
//     Directory? appDocDir = await getExternalStorageDirectory();
//     String data = appDocDir!.path;
//     // print(appDocPath);
//     return data;
//     //==========================================================
//   }
//
//   @override
//   void initState() {
//     super.initState();
//
//     _controller = VideoPlayerController.file(getdata())
//       ..initialize().then((_) {
//         // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
//         setState(() {});
//       });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Video Demo',
//       home: Scaffold(
//         body: Center(
//           child: _controller.value.isInitialized
//               ? AspectRatio(
//                   aspectRatio: _controller.value.aspectRatio,
//                   child: VideoPlayer(_controller),
//                 )
//               : Container(),
//         ),
//         floatingActionButton: FloatingActionButton(
//           onPressed: () {
//             setState(() {
//               _controller.value.isPlaying
//                   ? _controller.pause()
//                   : _controller.play();
//             });
//           },
//           child: Icon(
//             _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
//           ),
//         ),
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//     _controller.dispose();
//   }
// }

import 'package:flutter/material.dart';

class MyVideos extends StatefulWidget {
  const MyVideos({Key? key}) : super(key: key);

  @override
  _MyVideosState createState() => _MyVideosState();
}

class _MyVideosState extends State<MyVideos> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
