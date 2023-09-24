import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:poster_maker/EditImageScreen/resizeWidget.dart';
import 'package:poster_maker/EditImageScreen/textfield.dart';
import 'package:poster_maker/constant/constants.dart';

class TextEdit extends StatefulWidget {
  TextEdit({Key? key, this.onChange}) : super(key: key);
  var onChange;

  @override
  _TextEditState createState() => _TextEditState();
}

class _TextEditState extends State<TextEdit> {
  var result = 'Click To Edit';
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        result = await Navigator.push(
          context,
          // Create the SelectionScreen in the next step.
          MaterialPageRoute(builder: (context) => TextEditScreen()),
        );

        setState(() {});
      },
      child: ResizebleWidget(
        child: Text(
          result,
          style: TextStyle(
            color: kWhiteColor,
            fontWeight: FontWeight.w900,
          ),
          textScaleFactor: 1.5,
        ),
        // text: result??'Text'
      ),
    );
  }
}
