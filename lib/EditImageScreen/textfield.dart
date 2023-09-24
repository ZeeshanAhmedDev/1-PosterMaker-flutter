import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:poster_maker/constant/constants.dart';
import 'package:auto_size_text_field/auto_size_text_field.dart';

class TextEditScreen extends StatefulWidget {
  const TextEditScreen({Key? key}) : super(key: key);

  @override
  _TextEditScreenState createState() => _TextEditScreenState();
}

class _TextEditScreenState extends State<TextEditScreen> {
  TextEditingController? _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    double myHeight = MediaQuery.of(context).size.height;
    double myWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kCreatePosterColor,
        title: Text(
          'Edit Text'.toUpperCase(),
          style: GoogleFonts.anton(
            textStyle:
                TextStyle(color: kWhiteColor, fontSize: myHeight * 0.034),
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pop(context, _controller!.text);
              },
              icon: Icon(
                Icons.check,
                size: 30,
              )),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // TextFormField(
            //   controller: _controller,
            //   decoration: InputDecoration(
            //     contentPadding: new EdgeInsets.all(100),
            //     enabledBorder: OutlineInputBorder(
            //       borderSide: BorderSide(color: Colors.white, width: 1.0),
            //     ),
            //     focusedBorder: OutlineInputBorder(
            //       borderSide: BorderSide(color: Colors.white, width: 1.0),
            //     ),
            //     hintText: 'Enter Text',
            //     hintStyle: TextStyle(
            //       color: kWhiteColor,
            //     ),
            //   ),
            //   // focusedBorder: OutlineInputBorder(),
            //   onChanged: (text) {},
            // ),
            AutoSizeTextField(
              controller: _controller,
              style: TextStyle(
                fontSize: 50,
                fontStyle: FontStyle.italic,
                color: kWhiteColor,
              ),
              maxLines: null,
              cursorColor: kWhiteColor,
              decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 1.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 1.0),
                  ),
                  border: OutlineInputBorder(),
                  isDense: true,
                  contentPadding: const EdgeInsets.all(20)),
              onChanged: (text) {},
            )
          ],
        ),
      ),
    );
  }
}
