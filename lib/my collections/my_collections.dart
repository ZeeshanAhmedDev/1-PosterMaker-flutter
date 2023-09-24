import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:poster_maker/MyPosters/My%20Posters.dart';
import 'package:poster_maker/MyPosters/My%20Videos.dart';
import '../constant/constants.dart';

class MyCollections extends StatefulWidget {
  const MyCollections({Key? key}) : super(key: key);

  @override
  _MyCollectionsState createState() => _MyCollectionsState();
}

class _MyCollectionsState extends State<MyCollections> {
  @override
  Widget build(BuildContext context) {
    double myHeight = MediaQuery.of(context).size.height;
    double myWidth = MediaQuery.of(context).size.width;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kAppBarColor,
          title: Text(
            'My Collections'.toUpperCase(),
            style: GoogleFonts.anton(
              textStyle:
                  TextStyle(color: kWhiteColor, fontSize: myHeight * 0.034),
            ),
          ),
          centerTitle: true,
          bottom: TabBar(
            indicatorColor: kWhiteColor,
            isScrollable: true,
            physics:
                BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            tabs: [
              Tab(text: 'my images'.toUpperCase()),
              Tab(text: 'my videos'.toUpperCase()),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            MyPosters(),
            MyVideos(),

            //=============2nd tab COLOR===============
            // Container(
            //   width: myWidth,
            //   height: myHeight,
            //   child: Center(child: Text('No Video Saved')),
            // ),
          ],
        ),
      ),
    );
  }
}
