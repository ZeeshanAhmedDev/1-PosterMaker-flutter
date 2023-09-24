import 'package:flutter/material.dart';
import 'package:poster_maker/constant/constants.dart';
import 'package:share/share.dart';

Widget popupMenu(BuildContext context, VoidCallback onDelete, String image) {
  List<String> actions = <String>['Share', 'Delete'];

  onAction(String action) async {
    switch (action) {
      case 'Share':
        print("share");
        await Share.shareFiles([image], subject: 'Share ScreenShot');
        break;
      case 'Delete':
        _onDeletePopUp(context, onDelete);
        break;
    }
  }

  return PopupMenuButton(
    icon: Icon(Icons.more_vert, color: kWhiteColor),
    onSelected: onAction,
    itemBuilder: (BuildContext context) {
      return actions.map((String action) {
        return PopupMenuItem(value: action, child: Text(action));
      }).toList();
    },
  );
}

_onDeletePopUp(BuildContext context, VoidCallback onDelete) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: kAppBgColor,
        title: Center(
            child: Text(
          'Alert',
          style: TextStyle(color: kWhiteColor, fontWeight: FontWeight.w900),
        )),
        content: Container(
          height: 100,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Text(
                      "Are you sure you want to delete Poster",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: kWhiteColor,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 13.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      MaterialButton(
                          minWidth: 100,
                          color: kAppBarColor,
                          child: Text(
                            'Cancel',
                            style: TextStyle(color: kWhiteColor),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          }),
                      MaterialButton(
                          color: Colors.red.shade900,
                          minWidth: 100,
                          child: Text(
                            'OK',
                            style: TextStyle(color: kWhiteColor),
                          ),
                          onPressed: () {
                            onDelete();
                            Navigator.of(context).pop();
                          }) // button 2
                    ]),
              )
            ],
          ),
        ),
      );
    },
  );
}
