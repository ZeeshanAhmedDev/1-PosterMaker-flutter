class CatalogModel {
  static List<BackgroundModel> backgrounds = [];
}

class BackgroundModel {
  var imageUrl;

  BackgroundModel({required this.imageUrl});
  factory BackgroundModel.fromMap(Map<dynamic, dynamic> map) {
    return BackgroundModel(imageUrl: map['photo']);
  }
}
