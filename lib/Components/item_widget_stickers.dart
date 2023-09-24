import 'package:flutter/material.dart';
import 'package:poster_maker/Models/Stickers%20Model/stickers_model.dart';

class ItemStickersWidget extends StatelessWidget {
  final StickersModel item;
  final baseUrl = 'http://15.206.75.95:3000/uploads/sticker/';

  ItemStickersWidget({required this.item});

  @override
  Widget build(BuildContext context) {
    double myHeight = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.all(myHeight * 0.01),
      child: Image.network(
        baseUrl + item.imageUrl,
        fit: BoxFit.cover,
      ),
    );
  }
}
