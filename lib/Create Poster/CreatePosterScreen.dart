import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:poster_maker/Components/item_widgets_bg.dart';
import 'package:poster_maker/Components/item_widgets_textures.dart';
import 'package:poster_maker/Create%20Poster/components/imageBox.dart';
import 'package:poster_maker/EditImageScreen/editImageScreen.dart';
import 'package:poster_maker/Models/Backgrounds%20Model/background_model.dart';
import 'package:poster_maker/Models/Stickers%20Model/stickers_model.dart';
import 'package:poster_maker/Models/Textures%20Model/texture_model.dart';
import 'package:poster_maker/constant/constants.dart';
import 'package:http/http.dart' as http;
import 'components/imageboxforcolor.dart';

import 'components/imageboxforcolor.dart';

class CreatePosterScreen extends StatefulWidget {
  const CreatePosterScreen({Key? key}) : super(key: key);

  @override
  _CreatePosterScreenState createState() => _CreatePosterScreenState();
}

class _CreatePosterScreenState extends State<CreatePosterScreen> {
  getImage(img) {
    return showModalBottomSheet(
        backgroundColor: kCreatePosterColor,
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.15,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                ImageBox(
                  img: img,
                  aspect: 1 / 1,
                ),
                ImageBox(
                  img: img,
                  aspect: 16 / 9,
                ),
                ImageBox(
                  img: img,
                  aspect: 9 / 16,
                ),
                ImageBox(img: img, aspect: 4 / 3),
                ImageBox(
                  img: img,
                  aspect: 3 / 4,
                ),
              ],
            ),
          );
        });
  }

  //for Color
  imageBoxForColor(colour) {
    return showModalBottomSheet(
        backgroundColor: kCreatePosterColor,
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.15,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                ImageBoxForColor(
                  colour: colour,
                  aspect: 1 / 1,
                ),
                ImageBoxForColor(
                  colour: colour,
                  aspect: 16 / 9,
                ),
                ImageBoxForColor(
                  colour: colour,
                  aspect: 9 / 16,
                ),
                ImageBoxForColor(
                  colour: colour,
                  aspect: 4 / 16,
                ),
                ImageBoxForColor(
                  colour: colour,
                  aspect: 5 / 20,
                ),
              ],
            ),
          );
        });
  }

  File? image;
  Color colour = Colors.red;
  final url = 'http://15.206.75.95:3000';
  bool isSelected = false;

  Future getImageFromGallery() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);

      if (image == null) return;

      final imageTemp = File(image.path);
      setState(() {
        this.image = imageTemp;
      });
    } on PlatformException catch (e) {
      print('Failed to pick image $e');
    }
  }

  Future getImageFromCamera() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);

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
  void initState() {
    loadBackgroundImages(1);
    loadTextureImages(1);
    // loadStickersImages(1);
    super.initState();
  }

  int currentBackgroundPage = 1;
  bool loadBackground = true;
  loadBackgroundImages(int current) async {
    print("inloading 2");
    final catalogJson = await http
        .get(Uri.parse(url + '/backgroundImage?limit=30&page=$current'));

    if (catalogJson.statusCode == 200) {
      String data = catalogJson.body;
      int pageLimit = jsonDecode(data)['totalPages'];
      print(current);
      print(pageLimit);
      if (pageLimit < currentBackgroundPage) loadBackground = false;

      final decodedData = jsonDecode(data)['data'];
      CatalogModel.backgrounds.addAll(decodedData
          .map<BackgroundModel>((item) => BackgroundModel.fromMap(item))
          .toList());
      setState(() {});
    } else {
      print(catalogJson.statusCode);
    }
  }

  int currentTexturePage = 1;
  bool loadTexture = true;
  loadTextureImages(int currentPage) async {
    final response =
        await http.get(Uri.parse(url + '/texture?limit=30&page=$currentPage'));
    if (response.statusCode == 200) {
      String data = response.body;
      int pageLimit = jsonDecode(data)['totalPages'];
      print(currentPage);
      print(pageLimit);
      if (pageLimit < currentPage) loadTexture = false;
      final decodedData = jsonDecode(data)['data'];
      CatalogModelOfTexture.textures.addAll(decodedData
          .map<TextureModel>((item) => TextureModel.fromMap(item))
          .toList());
      setState(() {});
    } else {
      print(response.statusCode);
    }
  }

  // int currentStickerPage = 1;
  // loadStickersImages(int index) async {
  //   final response =
  //       await http.get(Uri.parse(url + '/sticker?limit=30&page=$index'));
  //   if (response.statusCode == 200) {
  //     String data = response.body;
  //     final decodedData = jsonDecode(data)['data'];
  //     CatalogModelOfStickers.stickers.addAll(decodedData
  //         .map<StickersModel>((item) => StickersModel.fromMap(item))
  //         .toList());
  //     setState(() {});
  //   } else {
  //     print(response.statusCode);
  //   }
  // }

  bool isBackgroundLoading = false;
  bool isTextureLoading = false;
  bool isStickerLoading = false;
  Future _loadBackgroundData() async {
    // perform fetching data delay
    if (loadBackground) await loadBackgroundImages(++currentBackgroundPage);
    if (mounted) {
      setState(() {
        isBackgroundLoading = false;
      });
    }
  }

  Future _loadTextureData() async {
    // perform fetching data delay
    print(loadTexture);
    if (loadTexture) await loadTextureImages(++currentTexturePage);
    if (mounted) {
      setState(() {
        isTextureLoading = false;
      });
    }
  }

  // Future _loadStickerData() async {
  //   // perform fetching data delay
  //   await loadStickersImages(++currentStickerPage);
  //   if (mounted) {
  //     setState(() {
  //       isBackgroundLoading = false;
  //     });
  //   }
  // }

  final _backgroundController = ScrollController();
  final _textureController = ScrollController();
  final _stickerController = ScrollController();

  @override
  Widget build(BuildContext context) {
    double myHeight = MediaQuery.of(context).size.height;
    double myWidth = MediaQuery.of(context).size.width;
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            //===================

            // TextButton(
            //   onPressed: () {
            //     setState(() {
            //       _textureModalBottomSheet(context);
            //     });
            //   },
            //   child: Text(
            //     'Textu...',
            //     style: TextStyle(color: kWhiteColor),
            //   ),
            // ),
          ],
          backgroundColor: kAppBarColor,
          title: Text(
            'Backgrounds'.toUpperCase(),
            style: GoogleFonts.anton(
              textStyle:
                  TextStyle(color: kWhiteColor, fontSize: myHeight * 0.034),
              // TextStyle(color: kWhiteColor, fontSize: 20),
            ),
          ),
          centerTitle: true,
          bottom: TabBar(
            isScrollable: true,
            indicatorColor: kWhiteColor,
            physics:
                BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            tabs: [
              Tab(text: 'Backgrounds'.toUpperCase()),
              Tab(text: 'Textures'.toUpperCase()),
              Tab(text: 'image'.toUpperCase()),
              Tab(text: 'color'.toUpperCase()),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Backgrounds code===========
            NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                //  print(!isLoading);

                if (!isBackgroundLoading &&
                    scrollInfo.metrics.pixels ==
                        scrollInfo.metrics.maxScrollExtent) {
                  // start loading data
                  _loadBackgroundData();
                  if (mounted) {
                    setState(() {
                      isBackgroundLoading = true;
                      Timer(
                        Duration(microseconds: 50),
                        () => _backgroundController.jumpTo(
                            _backgroundController.position.maxScrollExtent),
                      );
                    });
                  }
                }
                return true;
              },
              child: (CatalogModel.backgrounds != null &&
                      CatalogModel.backgrounds.isNotEmpty)
                  ? GridView.builder(
                      controller: _backgroundController,
                      physics: BouncingScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        // maxCrossAxisExtent: 200,
                        crossAxisCount: 3,
                        childAspectRatio: 3 / 3,
                      ),
                      itemCount: CatalogModel.backgrounds.length,
                      itemBuilder: (BuildContext ctx, index) => GestureDetector(
                          onTap: () {
                            getImage(url +
                                "/uploads/backgroundImage/" +
                                CatalogModel.backgrounds[index].imageUrl);
                          },
                          child: ItemWidget(
                            item: CatalogModel.backgrounds[index],
                          )),
                    )
                  : Center(
                      child: CircularProgressIndicator(
                        color: kCreatePosterColor,
                      ),
                    ),
            ),
            // Textures code===========
            NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                //  print(!isLoading);

                if (!isTextureLoading &&
                    scrollInfo.metrics.pixels ==
                        scrollInfo.metrics.maxScrollExtent) {
                  // start loading data
                  _loadTextureData();
                  if (mounted) {
                    setState(() {
                      isTextureLoading = true;
                      Timer(
                        Duration(microseconds: 50),
                        () => _textureController.jumpTo(
                            _textureController.position.maxScrollExtent),
                      );
                    });
                  }
                }
                return true;
              },
              child: (CatalogModelOfTexture.textures != null &&
                      CatalogModelOfTexture.textures.isNotEmpty)
                  ? GridView.builder(
                      controller: _textureController,
                      physics: BouncingScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        // maxCrossAxisExtent: 200,
                        crossAxisCount: 3,
                        childAspectRatio: 3 / 3,
                      ),
                      itemCount: CatalogModelOfTexture.textures.length,
                      itemBuilder: (BuildContext ctx, index) => GestureDetector(
                          onTap: () {
                            getImage(url +
                                "/uploads/texture/" +
                                CatalogModelOfTexture.textures[index].imageUrl);
                          },
                          child: ItemTextureWidget(
                            item: CatalogModelOfTexture.textures[index],
                          )),
                    )
                  : Center(
                      child: CircularProgressIndicator(
                        color: kCreatePosterColor,
                      ),
                    ),
            ),

            Container(
              width: myWidth,
              height: myHeight,
              child: Stack(
                children: [
                  Center(
                    child: Container(
                      width: myWidth,
                      height: myHeight / 3,
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
                                    fontSize: myHeight * 0.04,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // Two Images with text
                          Positioned(
                            left: myWidth * 0.58,
                            top: myHeight * 0.122,
                            child: GestureDetector(
                              // method to open the gallery
                              onTap: () async {
                                await getImageFromGallery();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EditImageScreen(
                                              img: image,
                                              aspect: 1 / 1,
                                              isUrl: false,
                                            )));
                              },
                              child: Container(
                                width: myWidth * 0.4,
                                height: myHeight * 0.2,
                                color: kAppBgColor,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      kGalleryImage,
                                      height: myHeight * 0.1,
                                      // width: myWidth * 0.1,
                                    ),
                                    Text(
                                      'gallery'.toUpperCase(),
                                      style: GoogleFonts.openSans(
                                        textStyle: TextStyle(
                                          color: kWhiteColor,
                                          // fontSize: myHeight * 0.021,
                                          fontSize: myHeight * 0.023,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            left: myWidth * 0.02,
                            top: myHeight * 0.122,
                            child: GestureDetector(
                              // onTap: () => getImageFromCamera(),
                              onTap: () async {
                                await getImageFromCamera();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EditImageScreen(
                                              img: image,
                                              aspect: 1 / 1,
                                              isUrl: false,
                                            )));
                              },
                              child: Container(
                                width: myWidth * 0.4,
                                height: myHeight * 0.2,
                                color: kAppBgColor,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      kCameraImage,
                                      height: myHeight * 0.1,
                                      // width: myWidth * 0.1,
                                    ),
                                    Text(
                                      'camera'.toUpperCase(),
                                      style: GoogleFonts.openSans(
                                        textStyle: TextStyle(
                                          color: kWhiteColor,
                                          // fontSize: myHeight * 0.021,
                                          fontSize: myHeight * 0.023,
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
              ),
            ),

            //=============4th tab COLOR===============
            Container(
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
                    top: myHeight * 0.33,
                    left: myWidth * 0.02,
                    child: GestureDetector(
                      onTap: () => pickColor(context),
                      child: Container(
                        width: myWidth * 0.88,
                        height: myHeight * 0.2,
                        color: kAppBgColor,
                      ),
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
                      kColorPicker,
                      height: myHeight * 0.12,
                      // width: myWidth * 0.2,
                    ),
                  ),
                  Positioned(
                    top: myHeight * 0.49,
                    left: myWidth * 0.38,
                    child: Text(
                      'color'.toUpperCase(),
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
                    child: GestureDetector(
                      onTap: () => pickColor(context),
                      child: Container(
                        width: myWidth * 0.88,
                        height: myHeight * 0.2,
                        color: Colors.white12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildColorPicker() => ColorPicker(
        enableAlpha: false,
        showLabel: false,
        pickerColor: colour,
        onColorChanged: (colour) => setState(() => this.colour = colour),
      );
  pickColor(BuildContext context) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: kAppBarColor,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildColorPicker(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.08,
                    height: MediaQuery.of(context).size.height * 0.05,
                    color: colour,
                  ),
                  Icon(
                    Icons.arrow_forward,
                    size: MediaQuery.of(context).size.height * 0.05,
                    color: kAppBgColor,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.08,
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),
                ],
              ),
            ],
          ),
          title: Center(
              child: Text(
            'Pick Your Color',
            style: TextStyle(color: kAppBgColor),
          )),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: Text('Cancel', style: TextStyle(color: kAppBgColor)),
            ),
            TextButton(
              child: Text('OK', style: TextStyle(color: kAppBgColor)),
              onPressed: () {
                setState(() {
                  imageBoxForColor(colour);
                });
              },
            ),
          ],
        ),
      );
}
