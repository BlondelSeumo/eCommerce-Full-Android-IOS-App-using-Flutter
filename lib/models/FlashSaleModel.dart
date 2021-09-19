class FlashSaleModel {
  // Model
  final int id;
  final String title;
  final String startDate;
  final String endDate;
  final String image;
  final String products;

  FlashSaleModel(
      {this.id,
      this.title,
      this.image,
      this.startDate,
      this.endDate,
      this.products});

  Map toJson() => {
        'id': id,
        'title': title,
        'start': startDate,
        'end': endDate,
        'image': image,
        'products': products
      };

  FlashSaleModel.fromJson(Map json)
      : id = json['id'],
        title = json['title'],
        startDate = json['start'],
        endDate = json['end'],
        image = json['image'],
        products = json['products'];

  @override
  String toString() {
    return 'FlashSaleModel{id: $id, title: $title, startDate: $startDate, endDate: $endDate, image: $image, products: $products}';
  }
}
