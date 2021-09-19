class BannerModel {
  // Model
  final int product;
  final String titleSlider;
  final String image;

  BannerModel({this.product, this.titleSlider, this.image});

  Map toJson() =>
      {'product': product, 'title_slider': titleSlider, 'image': image};

  BannerModel.fromJson(Map json)
      : product = json['product'],
        titleSlider = json['title_slider'],
        image = json['image'];
}