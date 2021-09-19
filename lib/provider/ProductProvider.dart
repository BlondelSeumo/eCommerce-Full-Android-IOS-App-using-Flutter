import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:nyoba/models/ProductExtendModel.dart';
import 'package:nyoba/models/ProductModel.dart';
import 'package:nyoba/models/ReviewModel.dart';
import 'package:nyoba/services/ProductAPI.dart';
import 'package:nyoba/services/ReviewAPI.dart';
import 'package:nyoba/utils/utility.dart';

class ProductProvider with ChangeNotifier {
  bool loadingFeatured = false;
  bool loadingNew = false;

  bool loadingExtends = true;
  bool loadingSpecial = true;
  bool loadingBest = true;
  bool loadingRecommendation = true;
  bool loadingDetail = true;
  bool loadingCategory = false;
  bool loadingBrand = false;
  bool loadingMore = true;

  bool loadingReview = false;
  bool loadAddReview = false;
  bool loadingRecent = false;

  String message;

  List<ProductModel> listFeaturedProduct = [];
  List<ProductModel> listMoreFeaturedProduct = [];

  List<ProductModel> listNewProduct = [];
  List<ProductModel> listMoreNewProduct = [];

  List<ProductModel> listSpecialProduct = [];
  List<ProductModel> listMoreSpecialProduct = [];

  List<ProductModel> listBestProduct = [];
  List<ProductModel> listRecentProduct = [];
  List<ProductModel> listRecommendationProduct = [];
  List<ProductModel> listCategoryProduct = [];
  List<ProductModel> listBrandProduct = [];

  List<ProductModel> listMoreExtendProduct = [];

  List<ReviewHistoryModel> listReviewLimit = [];

  ProductExtendModel productSpecial;
  ProductExtendModel productBest;
  ProductExtendModel productRecommendation;

  String productRecent;

  ProductModel productDetail;

  ProductProvider() {
    fetchFeaturedProducts();
    fetchExtendProducts('our_best_seller');
    fetchExtendProducts('special');
    fetchExtendProducts('recomendation');
  }

  Future<bool> fetchFeaturedProducts({int page = 1}) async {
    loadingFeatured = true;
    await ProductAPI().fetchProduct(featured: true, page: page).then((data) {
      if (data.statusCode == 200) {
        final responseJson = json.decode(data.body);

        if (page == 1) {
          listFeaturedProduct.clear();
          listMoreFeaturedProduct.clear();
        }
        for (Map item in responseJson) {
          if (page == 1) {
            listFeaturedProduct.add(ProductModel.fromJson(item));
            listMoreFeaturedProduct.add(ProductModel.fromJson(item));
          } else {
            listMoreFeaturedProduct.add(ProductModel.fromJson(item));
          }
        }

        loadingFeatured = false;
        notifyListeners();
      } else {
        loadingFeatured = false;
        notifyListeners();
      }
    });
    return true;
  }

  Future<bool> fetchNewProducts(String category, {int page = 1}) async {
    loadingNew = true;
    await ProductAPI()
        .fetchProduct(category: category, page: page)
        .then((data) {
      if (data.statusCode == 200) {
        final responseJson = json.decode(data.body);

        if (page == 1) {
          listNewProduct.clear();
          listMoreNewProduct.clear();
        }
        for (Map item in responseJson) {
          if (page == 1) {
            listNewProduct.add(ProductModel.fromJson(item));
            listMoreNewProduct.add(ProductModel.fromJson(item));
          } else {
            listMoreNewProduct.add(ProductModel.fromJson(item));
          }
        }

        loadingNew = false;
        notifyListeners();
      } else {
        loadingNew = false;
        notifyListeners();
      }
    });
    return true;
  }

  Future<bool> fetchExtendProducts(type) async {
    await ProductAPI().fetchExtendProduct(type).then((data) {
      if (data.statusCode == 200) {
        final responseJson = json.decode(data.body);

        for (Map item in responseJson) {
          if (type == 'our_best_seller') {
            productBest = ProductExtendModel.fromJson(item);
          } else if (type == 'special') {
            productSpecial = ProductExtendModel.fromJson(item);
          } else if (type == 'recomendation') {
            productRecommendation = ProductExtendModel.fromJson(item);
          }
        }
        notifyListeners();
      } else {
        notifyListeners();
        print("Load Extend Failed");
      }
    });
    return true;
  }

  Future<bool> fetchSpecialProducts(String productId) async {
    await ProductAPI().fetchProduct(include: productId).then((data) {
      if (data.statusCode == 200) {
        final responseJson = json.decode(data.body);
        // printLog(responseJson.toString(), name: 'Special Product');

        listSpecialProduct.clear();
        for (Map item in responseJson) {
          listSpecialProduct.add(ProductModel.fromJson(item));
        }
        loadingSpecial = false;
        notifyListeners();
      } else {
        print("Load Special Failed");
        loadingSpecial = false;
        notifyListeners();
      }
    });
    return true;
  }

  Future<bool> fetchBestProducts(String productId) async {
    await ProductAPI().fetchProduct(include: productId).then((data) {
      if (data.statusCode == 200) {
        final responseJson = json.decode(data.body);

        // printLog(responseJson.toString(), name: 'Best Product');
        listBestProduct.clear();
        for (Map item in responseJson) {
          listBestProduct.add(ProductModel.fromJson(item));
        }
        loadingBest = false;
        notifyListeners();
      } else {
        print("Load Best Failed");
        loadingBest = false;
        notifyListeners();
      }
    });
    return true;
  }

  Future<bool> fetchRecentProducts() async {
    await ProductAPI().fetchRecentViewProducts().then((data) {
      if (data["products"].toString().isNotEmpty) {
        productRecent = data["products"];
        this.fetchListRecentProducts(productRecent);
      }
      notifyListeners();
    });
    return true;
  }

  Future<bool> fetchListRecentProducts(productId) async {
    await ProductAPI()
        .fetchMoreProduct(
            include: productId, order: 'desc', orderBy: 'popularity')
        .then((data) {
      if (data.statusCode == 200) {
        final responseJson = json.decode(data.body);
        printLog(responseJson.toString(), name: 'Recent Product');

        listRecentProduct.clear();
        for (Map item in responseJson) {
          listRecentProduct.add(ProductModel.fromJson(item));
        }
        loadingRecent = false;
        notifyListeners();
      } else {
        print("Load Recent Failed");
        loadingRecent = false;
        notifyListeners();
      }
    });
    return true;
  }

  Future<bool> hitViewProducts(productId) async {
    await ProductAPI().hitViewProductsAPI(productId).then((data) {
      notifyListeners();
    });
    return true;
  }

  Future<bool> fetchRecommendationProducts(String productId) async {
    await ProductAPI().fetchProduct(include: productId).then((data) {
      if (data.statusCode == 200) {
        final responseJson = json.decode(data.body);

        listRecommendationProduct.clear();
        for (Map item in responseJson) {
          listRecommendationProduct.add(ProductModel.fromJson(item));
        }
        loadingRecommendation = false;
        notifyListeners();
      } else {
        print("Load Failed");
        loadingRecommendation = false;
        notifyListeners();
      }
    });
    return true;
  }

  Future<ProductModel> fetchProductDetail(String productId) async {
    loadingDetail = true;
    await ProductAPI().fetchDetailProduct(productId).then((data) {
      if (data.statusCode == 200) {
        final responseJson = json.decode(data.body);

        productDetail = ProductModel.fromJson(responseJson);

        loadingDetail = false;
        notifyListeners();
      } else {
        print("Load Failed");
        loadingDetail = false;
        notifyListeners();
      }
    });
    return productDetail;
  }

  Future<ProductModel> fetchProductDetailSlug(String slug) async {
    loadingDetail = true;
    await ProductAPI().fetchDetailProductSlug(slug).then((data) {
      if (data.statusCode == 200) {
        final responseJson = json.decode(data.body);

        for (Map item in responseJson) {
          productDetail = ProductModel.fromJson(item);
        }

        notifyListeners();
      } else {
        print("Load Failed");
        notifyListeners();
      }
    });
    return productDetail;
  }

  Future<Map<String, dynamic>> checkVariation({productId, list}) async {
    var result;
    await ProductAPI().checkVariationProduct(productId, list).then((data) {
      result = data;
      notifyListeners();
      printLog(result.toString());
    });
    return result;
  }

  Future<bool> fetchCategoryProduct(String category) async {
    loadingCategory = true;
    await ProductAPI().fetchProduct(category: category).then((data) {
      if (data.statusCode == 200) {
        final responseJson = json.decode(data.body);

        listCategoryProduct.clear();
        for (Map item in responseJson) {
          listCategoryProduct.add(ProductModel.fromJson(item));
        }
        loadingCategory = false;
        notifyListeners();
      } else {
        loadingCategory = false;
        notifyListeners();
      }
    });
    return true;
  }

  Future<bool> fetchBrandProduct(
      {String category, int page, String order, String orderBy}) async {
    loadingBrand = true;
    await ProductAPI()
        .fetchBrandProduct(
            category: category, order: order, orderBy: orderBy, page: page)
        .then((data) {
      if (data.statusCode == 200) {
        final responseJson = json.decode(data.body);

        if (page == 1) {
          listBrandProduct.clear();
        }
        for (Map item in responseJson) {
          listBrandProduct.add(ProductModel.fromJson(item));
        }
        loadingBrand = false;
        notifyListeners();
      } else {
        loadingBrand = false;
        notifyListeners();
      }
    });
    return true;
  }

  Future<Map<String, dynamic>> addReview(context,
      {productId, review, rating}) async {
    loadAddReview = !loadAddReview;
    var result;

    await ReviewAPI().inputReview(productId, review, rating).then((data) {
      result = data;
      printLog(result.toString());

      if (result['status'] == 'success') {
        var _ratingCountTemp = (productDetail.ratingCount + 1);
        var _avgTemp = ((double.parse(productDetail.avgRating) *
                    productDetail.ratingCount) +
                rating) /
            _ratingCountTemp;

        productDetail.ratingCount = _ratingCountTemp;
        productDetail.avgRating = _avgTemp.toStringAsFixed(2);

        loadAddReview = !loadAddReview;

        snackBar(context, message: 'Successfully add your product review');
      } else {
        loadAddReview = !loadAddReview;

        snackBar(context, message: 'Error, ${result['message']}');
      }

      notifyListeners();
      printLog(result.toString());
    });
    return result;
  }

  Future<bool> fetchMoreExtendProduct(String productId,
      {int page, String order, String orderBy}) async {
    loadingMore = true;
    await ProductAPI()
        .fetchMoreProduct(
            include: productId, page: page, order: order, orderBy: orderBy)
        .then((data) {
      if (data.statusCode == 200) {
        final responseJson = json.decode(data.body);

        if (page == 1) {
          listMoreExtendProduct.clear();
        }
        for (Map item in responseJson) {
          listMoreExtendProduct.add(ProductModel.fromJson(item));
        }

        loadingMore = false;
        notifyListeners();
      } else {
        print("Load Failed");
        loadingMore = false;
        notifyListeners();
      }
    });
    return true;
  }
}
