class CatalogModelOfStickers {
  static List<StickersModel> stickers = [];
}

class StickersModel {
  var imageUrl;

  StickersModel({required this.imageUrl});
  factory StickersModel.fromMap(Map<dynamic, dynamic> map) {
    return StickersModel(imageUrl: map['photo']);
  }
}
