class ProductExtendModel {
  // Model
  final String title;
  final String description;
  final String products;

  ProductExtendModel(
      {
        this.title,
        this.description,
        this.products});

  Map toJson() => {
    'title': title,
    'description': description,
    'products': products
  };

  ProductExtendModel.fromJson(Map json)
      : description = json['description'],
        title = json['title'],
        products = json['products'];
}