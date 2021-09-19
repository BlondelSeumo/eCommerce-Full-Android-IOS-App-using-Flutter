import 'package:nyoba/constant/constants.dart';
import 'package:nyoba/constant/global_url.dart';
import 'package:nyoba/models/ProductModel.dart';
import 'package:nyoba/services/Session.dart';
import 'package:nyoba/utils/utility.dart';

class ProductAPI {
  fetchProduct(
      {String include = '',
      bool featured = false,
      int page = 1,
      int perPage = 8,
      String parent = '',
      String search = '',
      String category = ''}) async {
    var response = await baseAPI.getAsync(
        '$product?include=$include&page=$page&per_page=$perPage&parent=$parent&featured=$featured&category=$category');
    return response;
  }

  fetchExtendProduct(String type) async {
    var response =
        await baseAPI.getAsync('$extendProducts?type=$type', isCustom: true);
    return response;
  }

  fetchRecentViewProducts() async {
    Map data = {"cookie": Session.data.getString('cookie')};
    var response =
        await baseAPI.postAsync('$recentProducts', data, isCustom: true);
    printLog(Session.data.getString('cookie'));
    return response;
  }

  hitViewProductsAPI(productId) async {
    Map data = {
      "cookie": Session.data.getString('cookie'),
      "product_id": productId,
      "ip_address": Session.data.getString('ip')
    };
    var response =
        await baseAPI.postAsync('$hitViewedProducts', data, isCustom: true);
    printLog(Session.data.getString('cookie'));
    return response;
  }

  fetchDetailProduct(String productId) async {
    var response = await baseAPI.getAsync('$product/$productId');
    return response;
  }

  fetchDetailProductSlug(String slug) async {
    var response = await baseAPI.getAsync('$product/?slug=$slug');
    return response;
  }

  searchProduct(
      {String search = '',
      String category = '',
      int page}) async {
    var response = await baseAPI.getAsync(
        '$product?search=$search&category=$category&page=$page');
    return response;
  }

  checkVariationProduct(int productId, List<ProductVariation> list) async {
    Map data = {"product_id": productId, "variation": list};
    printLog(data.toString());
    var response = await baseAPI.postAsync(
      '$checkVariations',
      data,
      isCustom: true,
    );
    return response;
  }

  fetchBrandProduct(
      {int page = 1,
      int perPage = 8,
      String search = '',
      String category = '',
      String order = 'desc',
      String orderBy = 'popularity'}) async {
    var response = await baseAPI.getAsync(
        '$product?page=$page&per_page=$perPage&category=$category&order=$order&orderby=$orderBy');
    return response;
  }

  reviewProduct({String productId = ''}) async {
    var response =
        await baseAPI.getAsync('$reviewProductUrl?product=$productId');
    return response;
  }

  reviewProductLimit({String productId = ''}) async {
    var response = await baseAPI
        .getAsync('$reviewProductUrl?product=$productId&per_page=1&page=1');
    return response;
  }

  fetchMoreProduct(
      {int page = 1,
      int perPage = 8,
      String search = '',
      String include = '',
      String category = '',
      String order = 'desc',
      String orderBy = 'popularity'}) async {
    var response = await baseAPI.getAsync(
        '$product?include=$include=$page&per_page=$perPage&category=$category&order=$order&orderby=$orderBy');
    return response;
  }

  scanProductAPI(String code) async {
    Map data = {"code": code};
    printLog(data.toString());
    var response = await baseAPI.postAsync(
      '$getBarcodeUrl',
      data,
      isCustom: true,
    );
    return response;
  }
}
