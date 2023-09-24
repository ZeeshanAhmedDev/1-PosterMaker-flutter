import 'package:flutter/material.dart';
import 'package:poster_maker/Models/Backgrounds%20Model/background_model.dart';

class ItemWidget extends StatelessWidget {
  final BackgroundModel item;

  ItemWidget({required this.item});

  @override
  Widget build(BuildContext context) {
    double myHeight = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.all(myHeight * 0.01),
      child: Image.asset(
        item.imageUrl,
        fit: BoxFit.cover,
      ),
    );
  }
}
