import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:poster_maker/Create%20Poster/CreatePosterScreen.dart';
import 'package:poster_maker/constant/constants.dart';

class DesignsScreen extends StatefulWidget {
  const DesignsScreen({Key? key}) : super(key: key);

  @override
  _DesignsState createState() => _DesignsState();
}

class _DesignsState extends State<DesignsScreen> {
  @override
  Widget build(BuildContext context) {
    double myHeight = MediaQuery.of(context).size.height;
    double myWidth = MediaQuery.of(context).size.width;
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kAppBarColor,
          title: Text(
            'designs'.toUpperCase(),
            style: GoogleFonts.anton(
              textStyle:
                  TextStyle(color: kWhiteColor, fontSize: myHeight * 0.034),
            ),
          ),
          centerTitle: true,
          bottom: TabBar(
            isScrollable: true,
            indicatorColor: kWhiteColor,
            physics:
                BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            tabs: [
              Tab(text: 'my designs'.toUpperCase()),
              Tab(text: 'free designs'.toUpperCase()),
              Tab(text: 'create posters'.toUpperCase()),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Icon(Icons.directions_car),
            Icon(Icons.directions_transit),
            Padding(
              padding: EdgeInsets.all(myWidth * 0.3),
              child: Center(
                child: GestureDetector(
                    onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CreatePosterScreen(),
                          ),
                        ),
                    child: SvgPicture.asset(kCreatePoster)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
