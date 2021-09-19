import 'package:flutter/foundation.dart';
import 'package:nyoba/models/CategoriesModel.dart';
import 'package:nyoba/models/ProductModel.dart';
import 'dart:convert';
import 'package:nyoba/services/CategoriesAPI.dart';
import 'package:nyoba/services/ProductAPI.dart';
import 'package:nyoba/utils/utility.dart';

class CategoryProvider with ChangeNotifier {
  CategoriesModel category;
  bool loading = true;
  bool loadingAll = true;

  bool loadingSub = false;

  List<CategoriesModel> categories = [];
  List<ProductCategoryModel> productCategories = [];

  List<AllCategoriesModel> allCategories = [];
  List<ProductCategoryModel> subCategories = [];
  List<PopularCategoriesModel> popularCategories = [];
  int currentSelectedCategory;
  int currentSelectedCountSub;

  List<ProductModel> listProductCategory = [];

  CategoryProvider() {
    // fetchCategories();
    // fetchProductCategories();
  }

  Future<bool> fetchCategories() async {
    await CategoriesAPI().fetchCategories().then((data) {
      if (data.statusCode == 200) {
        final responseJson = json.decode(data.body);

        for (Map item in responseJson) {
          categories.add(CategoriesModel.fromJson(item));
        }
        categories.add(new CategoriesModel(
            image: 'images/lobby/viewMore.png',
            categories: null,
            id: null,
            titleCategories: 'View More'));
        loading = false;
        notifyListeners();
      } else {
        loading = false;
        notifyListeners();
      }
    });
    return true;
  }

  Future<bool> fetchProductCategories() async {
    await CategoriesAPI().fetchProductCategories().then((data) {
      if (data.statusCode == 200) {
        final responseJson = json.decode(data.body);

        for (Map item in responseJson) {
          productCategories.add(ProductCategoryModel.fromJson(item));
        }
        loading = false;
        notifyListeners();
      } else {
        loading = false;
        notifyListeners();
      }
    });
    return true;
  }

  Future<bool> fetchAllCategories() async {
    var result;
    await CategoriesAPI().fetchAllCategories().then((data) {
      result = data;
      printLog(result.toString());
      for (Map item in result) {
        allCategories.add(AllCategoriesModel.fromJson(item));
      }
      loadingAll = false;
      notifyListeners();
    });
    return true;
  }

  Future<bool> fetchSubCategories(int parent) async {
    loadingSub = true;
    await CategoriesAPI().fetchProductCategories(parent: parent).then((data) {
      if (data.statusCode == 200) {
        final responseJson = json.decode(data.body);

        subCategories.clear();
        for (Map item in responseJson) {
          subCategories.add(ProductCategoryModel.fromJson(item));
        }
        loadingSub = false;
        notifyListeners();
      } else {
        loadingSub = false;
        notifyListeners();
      }
    });
    return true;
  }

  Future<bool> fetchPopularCategories() async {
    loadingSub = true;
    await CategoriesAPI().fetchPopularCategories().then((data) {
      if (data.statusCode == 200) {
        final responseJson = json.decode(data.body);

        popularCategories.clear();
        for (Map item in responseJson) {
          popularCategories.add(PopularCategoriesModel.fromJson(item));
        }
        loadingSub = false;
        notifyListeners();
      } else {
        loadingSub = false;
        notifyListeners();
      }
    });
    return true;
  }

  Future<bool> fetchProductsCategory(String category, {int page = 1}) async {
    loadingSub = true;
    await ProductAPI()
        .fetchProduct(category: category, page: page, perPage: 5)
        .then((data) {
      if (data.statusCode == 200) {
        final responseJson = json.decode(data.body);

        if (page == 1) {
          listProductCategory.clear();
        }

        int count = 0;

        for (Map item in responseJson) {
          listProductCategory.add(ProductModel.fromJson(item));
          count++;
        }

        if (count >= 5) {
          listProductCategory.add(ProductModel());
        }

        loadingSub = false;
        notifyListeners();
      } else {
        loadingSub = false;
        notifyListeners();
      }
    });
    return true;
  }
}
