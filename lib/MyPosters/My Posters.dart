import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:poster_maker/MyPosters/popupMenu.dart';

class MyPosters extends StatefulWidget {
  const MyPosters({Key? key}) : super(key: key);

  @override
  _MyPostersState createState() => _MyPostersState();
}

class _MyPostersState extends State<MyPosters> {
  List<String> images = [];

  getImages() async {
    try {
      images = [];
      final dir = await getApplicationDocumentsDirectory();
      final imagesDirectory = new Directory(dir.path + "/Posters");
      if (await imagesDirectory.exists()) {
        final _imagesFile =
            imagesDirectory.listSync(followLinks: false, recursive: true);
        _imagesFile.forEach((img) {
          setState(() {
            images.add(img.path.toString());
          });
        });
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  deleteImage(int index) async {
    try {
      setState(() {});
      final file = await File(images[index]);
      await file.delete();
      setState(() {});
      Fluttertoast.showToast(msg: "Your image has been deleted");
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  @override
  void initState() {
    getImages();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double myHeight = MediaQuery.of(context).size.height;
    double myWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: images.length == 0
            ? Center(child: Text("No Poster Saved"))
            : GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemCount: images.length,
                itemBuilder: (BuildContext ctx, index) {
                  return Stack(children: [
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Container(
                        //alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15.0),
                            child: Image.file(
                              File(images[index]),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.grey.shade300),
                      ),
                    ),
                    Positioned(
                      right: -3,
                      top: 0,
                      child: popupMenu(context, () {
                        deleteImage(index);
                        getImages();
                      }, images[index]),
                    )
                  ]);
                }),
      ),
    );
  }
}
