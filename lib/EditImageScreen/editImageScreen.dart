import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photofilters/filters/preset_filters.dart';
import 'package:photofilters/widgets/photo_filter.dart';
import 'package:poster_maker/Components/item_widget_stickers.dart';
import 'package:poster_maker/Create%20Poster/CreatePosterScreen.dart';
import 'package:poster_maker/EditImageScreen/components/imageEdit.dart';
import 'package:poster_maker/EditImageScreen/components/sticker_edit.dart';
import 'package:poster_maker/EditImageScreen/saveAsAlert.dart';
import 'package:poster_maker/EditImageScreen/components/textEdit.dart';
import 'package:poster_maker/EditImageScreen/stateManagement/colorChange.dart';
import 'package:poster_maker/Models/Stickers%20Model/stickers_model.dart';
import 'package:poster_maker/constant/constants.dart';
import 'package:image/image.dart' as imageLib;
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

class EditImageScreen extends StatefulWidget {
  var img;
  var aspect;
  bool isUrl;
  EditImageScreen({this.img, this.aspect, this.isUrl = true});

  @override
  _EditImageScreenState createState() => _EditImageScreenState();
}

class _EditImageScreenState extends State<EditImageScreen> {
  bool tap = false;
  bool click = false;
  File? image;
  bool isImage = false;
  File? convertImage;
  bool text_click = false;
  TextEdit edit = TextEdit();
  ScreenshotController screenshotController = ScreenshotController();
  List<ImageEdit> imageEditList = [];
  List<TextEdit> textEditList = [];
  List<StickerEdit> stickerEditList = [];
  File? stickerImage;
  bool isSelected = false;
  String? sticker;

  Future<File> urlToFile(String imageUrl) async {
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    File file = new File('$tempPath' + imageUrl.split("/").last);
    http.Response response = await http.get(Uri.parse(imageUrl));
    await file.writeAsBytes(response.bodyBytes);
    return file;
  }

  Future<void> getLostData() async {
    final LostDataResponse response = await ImagePicker().retrieveLostData();
    if (response.isEmpty) {
      Fluttertoast.showToast(msg: "failed");
      return;
    }
    if (response.file != null) {
      Fluttertoast.showToast(msg: "retrived");
      setState(() {
        if (response.type == RetrieveType.image) {
          ImageEdit imageEdit = new ImageEdit(image: File(response.file!.path));
          setState(() {
            imageEditList.add(imageEdit);
            isImage = true;
          });
          setState(() {});
        }
      });
    } else {
      Fluttertoast.showToast(msg: "error");
      print("error");
    }
  }

  Future filterColor(context, File imageFile) async {
    String fileName = basename(imageFile.path);
    var image = imageLib.decodeImage(imageFile.readAsBytesSync());
    image = imageLib.copyResize(image!, width: 600);
    Map imagefile = await Navigator.push(
      context,
      new MaterialPageRoute(
        builder: (context) => new PhotoFilterSelector(
          title: Text("Photo Filter"),
          image: image!,
          filters: presetFiltersList,
          filename: fileName,
          loader: Center(
              child: CircularProgressIndicator(
            color: kAppBarColor,
          )),
          fit: BoxFit.contain,
        ),
      ),
    );
    if (imagefile != null && imagefile.containsKey('image_filtered')) {
      setState(() {
        convertImage = imagefile['image_filtered'];
      });
      print(convertImage!.path);
    }
  }

  Future getImageFromGallery() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);

      if (image == null) getLostData();

      final imageTemp = File(image!.path);
      ImageEdit imageEdit = new ImageEdit(image: imageTemp);
      print(imageTemp.path);
      setState(() {
        imageEditList.add(imageEdit);
        isImage = true;
      });
      setState(() {});
    } on PlatformException catch (e) {
      print('Failed to pick image $e');
    }
  }

  Future getImageFromCamera() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);

      if (image == null) await getLostData();

      final imageTemp = File(image!.path);
      ImageEdit imageEdit = new ImageEdit(image: imageTemp);
      setState(() {
        imageEditList.add(imageEdit);
        isImage = true;
      });
      setState(() {});
    } on PlatformException catch (e) {
      print('Failed to pick image $e');
    }
  }

  ValueChanged<bool>? onChanged;
  bool color_value = true;

  int currentStickerPage = 1;
  bool isStickerLoading = false;
  bool loadSticker = true;
  final _StickerController = ScrollController();
  loadStickersImages(int index) async {
    final response = await http.get(
        Uri.parse('http://15.206.75.95:3000/sticker?limit=30&page=$index'));
    if (response.statusCode == 200) {
      String data = response.body;
      int pageLimit = jsonDecode(data)['totalPages'];
      print(index);
      print(pageLimit);
      if (pageLimit < index) loadSticker = false;
      final decodedData = jsonDecode(data)['data'];
      CatalogModelOfStickers.stickers.addAll(decodedData
          .map<StickersModel>((item) => StickersModel.fromMap(item))
          .toList());
      setState(() {});
    } else {
      print(response.statusCode);
    }
  }

  Future _loadStickerData() async {
    // perform fetching data delay
    print(loadSticker);
    if (loadSticker) await loadStickersImages(++currentStickerPage);
    if (mounted) {
      setState(() {
        isStickerLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    loadStickersImages(1);
    if (widget.isUrl) {
      urlToFile(widget.img).then((value) {
        convertImage = value;

        setState(() {});
      });
    } else {
      convertImage = widget.img;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    double myHeight = MediaQuery.of(context).size.height;
    double myWidth = MediaQuery.of(context).size.width;
    return Consumer<SwitchChanged>(
      builder: (BuildContext context, value, Widget? child) => Scaffold(
        appBar: AppBar(
          backgroundColor: kAppBarColor,
          title: Text(
            'Poster Maker'.toUpperCase(),
            style: GoogleFonts.anton(
              textStyle:
                  TextStyle(color: kWhiteColor, fontSize: myHeight * 0.024),
            ),
          ),
          // centerTitle: true,
          actions: [
            //===================
            // TextButton(
            //   onPressed: () {
            //     setState(() {
            //       // _backgroundModalBottomSheet(context);
            //     });
            //   },
            //   child: Text(
            //     '1',
            //     style: TextStyle(color: kWhiteColor),
            //   ),
            // ),
            // TextButton(
            //   onPressed: () {
            //     setState(() {
            //       // _textureModalBottomSheet(context);
            //     });
            //   },
            //   child: Text(
            //     '2',
            //     style: TextStyle(color: kWhiteColor),
            //   ),
            // ),
            // TextButton(
            //   onPressed: () {
            //     setState(() {
            //       // _textureModalBottomSheet(context);
            //     });
            //   },
            //   child: Text(
            //     '3',
            //     style: TextStyle(color: kWhiteColor),
            //   ),
            // ),
            // TextButton(
            //   onPressed: () {
            //     setState(() {
            //       // _textureModalBottomSheet(context);
            //     });
            //   },
            //   child: Text(
            //     '4',
            //     style: TextStyle(color: kWhiteColor),
            //   ),
            // ),
            IconButton(
                onPressed: () {
                  print(value.val);

                  setState(() {
                    value.add(true);
                  });

                  print(value.val);
                  showMyDialog(
                      context, myHeight, myWidth, screenshotController);
                },
                icon: Icon(
                  Icons.check,
                  size: 30,
                )),
          ],
        ),
        body: Stack(
          children: [
            Positioned(
              top: 70,
              child: Container(
                height: myHeight * 0.4,
                width: myWidth,
                child: Screenshot(
                  controller: screenshotController,
                  child: Stack(children: [
                    Positioned(
                      top: 1,
                      child: Container(
                        height: myHeight * 0.4,
                        width: myWidth,
                        child: AspectRatio(
                            aspectRatio: widget.aspect,
                            // child: Image.network(
                            //   widget.img,
                            //   // backgroundList.last.imageUrl,
                            //   fit: BoxFit.contain,
                            // ),
                            child: convertImage == null
                                ? Center(
                                    child: CircularProgressIndicator(
                                    color: kAppBarColor,
                                  ))
                                : Image.file(convertImage!, fit: BoxFit.cover)),
                      ),
                    ),
                    Stack(children: imageEditList),
                    Stack(children: textEditList),
                    Stack(children: stickerEditList),
                    //
                    // isSelected ? Image.network(sticker!) : Container(),
                  ]),
                ),
              ),
            ),
            click
                ? Stack(
                    children: [
                      Positioned(
                        top: myHeight * 0.20,
                        left: myWidth * 0.1,
                        child: Container(
                          width: myWidth * 0.8,
                          height: myHeight * 0.3,
                          // color: Colors.pink.shade800,
                          color: kAppBarColor,
                          child: Stack(
                            alignment: AlignmentDirectional.bottomStart,
                            children: [
                              //this is Select Picture Using
                              Positioned(
                                child: Align(
                                  alignment: Alignment.topCenter,
                                  child: Text(
                                    'Select picture using'.toUpperCase(),
                                    style: GoogleFonts.anton(
                                      textStyle: TextStyle(
                                        color: kWhiteColor,
                                        // fontSize: myHeight * 0.021,
                                        fontSize: myHeight * 0.03,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              // Two Images with text
                              Positioned(
                                left: myWidth * 0.45,
                                top: myHeight * 0.122,
                                child: GestureDetector(
                                  // method to open the gallery
                                  onTap: () {
                                    setState(() {
                                      click = false;
                                    });
                                    getImageFromGallery();
                                  },
                                  child: CircleAvatar(
                                    foregroundColor: Colors.white,
                                    backgroundColor: kAppBgColor,
                                    radius: myHeight * 0.06,
                                    // width: myWidth * 0.2,
                                    // height: myHeight * 0.1,
                                    // color: Colors.white12,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          kGalleryImage,
                                          height: myHeight * 0.05,
                                          // width: myWidth * 0.1,
                                        ),
                                        Text(
                                          'gallery'.toUpperCase(),
                                          style: GoogleFonts.openSans(
                                            textStyle: TextStyle(
                                              color: kWhiteColor,
                                              // fontSize: myHeight * 0.021,
                                              fontSize: myHeight * 0.015,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                left: myWidth * 0.1,
                                top: myHeight * 0.122,
                                child: GestureDetector(
                                  // onTap: () => getImageFromCamera(),
                                  onTap: () => {
                                    setState(() {
                                      click = false;
                                    }),
                                    getImageFromCamera(),
                                  },
                                  child: CircleAvatar(
                                    foregroundColor: Colors.white,
                                    backgroundColor: kAppBgColor,
                                    radius: myHeight * 0.06,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          kCameraImage,
                                          height: myHeight * 0.05,
                                          // width: myWidth * 0.1,
                                        ),
                                        Text(
                                          'camera'.toUpperCase(),
                                          style: GoogleFonts.openSans(
                                            textStyle: TextStyle(
                                              color: kWhiteColor,
                                              // fontSize: myHeight * 0.021,
                                              fontSize: myHeight * 0.015,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                : Container(),
            Positioned(
              bottom: 1,
              child: Container(
                alignment: Alignment.bottomCenter,
                width: myWidth,
                height: myHeight * 0.1,
                color: Color(0xFF463E27),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                        // setState(() {
                        //   text_click = !text_click;
                        // });
                        print("hello");
                        TextEdit? textEdit = TextEdit();

                        setState(() {
                          textEditList.add(textEdit);
                        });
                        setState(() {});
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: IconButton(
                              onPressed: null,
                              icon: Icon(
                                Icons.title_outlined,
                                size: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, right: 8.0, bottom: 5),
                            child: Text(
                              "Text",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(width: 0.2, color: Colors.white),
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(30),
                                    topRight: Radius.circular(30))),
                            backgroundColor: kAppBgColor.withOpacity(0.9),
                            context: context,
                            builder: (context) {
                              return StatefulBuilder(
                                builder: (BuildContext context,
                                    StateSetter
                                        setSt /*You can rename this!*/) {
                                  return Container(
                                    // height: myHeight * 0.03,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            topRight: Radius.circular(10))),
                                    child: NotificationListener<
                                        ScrollNotification>(
                                      onNotification:
                                          (ScrollNotification scrollInfo) {
                                        //  print(!isLoading);

                                        if (!isStickerLoading &&
                                            scrollInfo.metrics.pixels ==
                                                scrollInfo
                                                    .metrics.maxScrollExtent) {
                                          // start loading data
                                          _loadStickerData();
                                          setSt(() {});
                                          if (mounted) {
                                            setState(() {
                                              isStickerLoading = true;
                                            });
                                          }
                                        }
                                        return true;
                                      },
                                      child: (CatalogModelOfStickers.stickers !=
                                                  null &&
                                              CatalogModelOfStickers
                                                  .stickers.isNotEmpty)
                                          ? GridView.builder(
                                              controller: _StickerController,
                                              physics: BouncingScrollPhysics(),
                                              gridDelegate:
                                                  SliverGridDelegateWithFixedCrossAxisCount(
                                                // maxCrossAxisExtent: 200,
                                                crossAxisCount: 4,
                                                childAspectRatio: 3 / 3,
                                              ),
                                              itemCount: CatalogModelOfStickers
                                                  .stickers.length,
                                              itemBuilder: (BuildContext ctx,
                                                      index) =>
                                                  GestureDetector(
                                                      onTap: () {
                                                        if (mounted)
                                                          setState(() {
                                                            sticker = "http://15.206.75.95:3000/uploads/sticker/" +
                                                                CatalogModelOfStickers
                                                                    .stickers[
                                                                        index]
                                                                    .imageUrl;
                                                            urlToFile(sticker!)
                                                                .then((value) {
                                                              stickerImage =
                                                                  value;

                                                              stickerEditList.add(
                                                                  StickerEdit(
                                                                      image:
                                                                          stickerImage!));

                                                              setState(() {});
                                                            });

                                                            isSelected = true;

                                                            Navigator.pop(
                                                                context);
                                                          });
                                                      },
                                                      child: ItemStickersWidget(
                                                        item:
                                                            CatalogModelOfStickers
                                                                    .stickers[
                                                                index],
                                                      )),
                                            )
                                          : Center(
                                              child: CircularProgressIndicator(
                                                color: kAppBarColor,
                                              ),
                                            ),
                                    ),
                                  );
                                },
                              );
                            });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: IconButton(
                              onPressed: null,
                              icon: Icon(
                                Icons.stars_outlined,
                                size: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, right: 8.0, bottom: 5),
                            child: Text(
                              "Stickers",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(width: 0.2, color: Colors.white),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                            child: IconButton(
                          onPressed: () async {
                            // File image = await urlToFile(widget.img);
                            // print("file :" + image.toString());
                            // print(image.uri);
                            filterColor(context, convertImage!);
                          },
                          icon: Icon(
                            Icons.healing_rounded,
                            size: 20,
                            color: Colors.white,
                          ),
                        )),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 8.0, right: 8.0, bottom: 5),
                          child: Text(
                            "Effects",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    Container(width: 0.2, color: Colors.white),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          click = !click;
                        });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: IconButton(
                              onPressed: null,
                              icon: Icon(
                                Icons.image,
                                size: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, right: 8.0, bottom: 5),
                            child: Text(
                              "Image",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(width: 0.2, color: Colors.white),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CreatePosterScreen()));
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: IconButton(
                              onPressed: null,
                              icon: Icon(
                                Icons.photo_library_rounded,
                                size: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, right: 8.0, bottom: 5),
                            child: Text(
                              "BG",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Positioned(
            //   bottom: MediaQuery.of(context).size.height * 0.11,
            //   child: Container(
            //     width: double.infinity,
            //     height: MediaQuery.of(context).size.height * 0.6,
            //     color: Colors.red,
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.spaceAround,
            //       children: [
            //         TextButton(
            //           child: Text('1'),
            //           onPressed: () {},
            //         ),
            //         TextButton(
            //           child: Text('3'),
            //           onPressed: () {},
            //         ),
            //         TextButton(
            //           child: Text('4'),
            //           onPressed: () {},
            //         ),
            //         TextButton(
            //           child: Text('1'),
            //           onPressed: () {},
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
