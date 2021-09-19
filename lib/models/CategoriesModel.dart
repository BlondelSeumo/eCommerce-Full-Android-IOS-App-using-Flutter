class CategoriesModel {
  // Model
  final int categories;
  final String id;
  final String titleCategories;
  final String image;

  CategoriesModel(
      {this.categories, this.titleCategories, this.image, this.id});

  Map toJson() => {
        'categories': categories,
        'title_slider': titleCategories,
        'image': image
      };

  CategoriesModel.fromJson(Map json)
      : categories = json['categories'],
        titleCategories = json['title_categories'] ?? json['name'],
        image = json['image'],
        id = json['id'];
}

class PopularCategoriesModel {
  // Model
  String title;
  List<CategoriesModel> categories;

  PopularCategoriesModel({this.categories, this.title});

  Map toJson() => {'categories': categories, 'title': title};

  PopularCategoriesModel.fromJson(Map json) {
    if (json['categories'] != null) {
      categories = [];
      json['categories'].forEach((v) {
        categories.add(new CategoriesModel.fromJson(v));
      });
    }
    title = json['title'];
  }
}

class AllCategoriesModel {
  // Model
  final int id, count, parent;
  final String title;
  final String description;
  final String image;

  AllCategoriesModel(
      {this.id,
      this.count,
      this.parent,
      this.title,
      this.description,
      this.image});

  Map toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'parent': parent,
        'count': count,
        'image': image
      };

  AllCategoriesModel.fromJson(Map json)
      : id = json['id'],
        title = json['title'],
        description = json['description'],
        parent = json['parent'],
        count = json['count'],
        image = json['image'];
}
