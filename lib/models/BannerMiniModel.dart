class BannerMiniModel {
  // Model
  final int product;
  final String titleSlider;
  final String image;
  final String type;

  BannerMiniModel({this.product, this.titleSlider, this.image, this.type});

  Map toJson() => {
        'product': product,
        'title_slider': titleSlider,
        'image': image,
        'type': type
      };

  BannerMiniModel.fromJson(Map json)
      : product = json['product'],
        titleSlider = json['title_slider'],
        image = json['image'],
        type = json['image'];
}
