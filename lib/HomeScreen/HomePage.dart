import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:poster_maker/Designs/Designs.dart';
import 'package:poster_maker/Video%20Editor%20Trimmer/video_trimmer.dart';
import 'package:poster_maker/constant/constants.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../my collections/my_collections.dart';
import '../video_editing_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

_launchURL() async {
  const url = 'https://flutter.io';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    double myHeight = MediaQuery.of(context).size.height;
    double myWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
                height: myHeight / 2,
                width: myWidth,
                color: Colors.white12,
                child: CarouselSlider(
                  options: CarouselOptions(
                      height: myHeight,
                      initialPage: 0,
                      enableInfiniteScroll: true,
                      reverse: false,
                      autoPlay: true,
                      autoPlayInterval: Duration(seconds: 3),
                      autoPlayAnimationDuration: Duration(milliseconds: 800),
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enlargeCenterPage: true,
                      scrollDirection: Axis.horizontal),
                  items: [
                    'images/pic_1.jpg',
                    'images/pic_2.jpg',
                    'images/pic_1.jpg',
                    'images/pic_3.jpg',
                    'images/pic_2.jpg',
                  ].map((i) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          margin:
                              EdgeInsets.symmetric(horizontal: myWidth * 0.02),
                          child: Image.asset(
                            i,
                            fit: BoxFit.fitWidth,
                            isAntiAlias: true,
                          ),
                        );
                      },
                    );
                  }).toList(),
                )),
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          child: SvgPicture.asset(
                            // kCreatePoster,
                            kVideosButton,
                            height: myHeight * 0.2,
                            width: myWidth * 0.2,
                          ),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VideoPickerPage(),
                            ),
                          ),
                        ),
                        GestureDetector(
                          child: SvgPicture.asset(
                            kDesigns,
                            height: myHeight * 0.2,
                            width: myWidth * 0.2,
                          ),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DesignsScreen(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          child: SvgPicture.asset(
                            // kMyPoster,
                            kMyCollectionsButton,
                            height: myHeight * 0.2,
                            width: myWidth * 0.2,
                          ),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MyCollections(),
                            ),
                          ),
                        ),
                        GestureDetector(
                          child: SvgPicture.asset(
                            kMore,
                            height: myHeight * 0.2,
                            width: myWidth * 0.2,
                          ),
                          onTap: () => _launchURL(),
                        ),
                      ],
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
}
