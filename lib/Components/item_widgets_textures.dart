import 'package:flutter/material.dart';
import 'package:poster_maker/Models/Textures%20Model/texture_model.dart';

class ItemTextureWidget extends StatelessWidget {
  final TextureModel item;
  final baseUrl = 'http://15.206.75.95:3000/uploads/texture/';

  ItemTextureWidget({required this.item});

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
