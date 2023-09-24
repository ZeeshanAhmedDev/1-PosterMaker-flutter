class CatalogModelOfTexture {
  static List<TextureModel> textures = [];
}

class TextureModel {
  var imageUrl;

  TextureModel({required this.imageUrl});
  factory TextureModel.fromMap(Map<dynamic, dynamic> map) {
    return TextureModel(imageUrl: map['photo']);
  }
}
