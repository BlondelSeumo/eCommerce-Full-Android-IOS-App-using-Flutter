import 'package:nyoba/constant/constants.dart';
import 'package:nyoba/constant/global_url.dart';
import 'package:nyoba/utils/utility.dart';

class CategoriesAPI {

  fetchCategories({String showPopular = ''}) async {
    var response = await baseAPI.getAsync(
        '$category?show_popular=$showPopular',isCustom: true);
    return response;
  }

  fetchProductCategories({int parent}) async {
    var url = productCategories;
    if (parent != null){
      url = '$productCategories?parent=$parent';
    }
    var response = await baseAPI.getAsync(
        '$url');
    return response;
  }

  fetchPopularCategories() async {
    var response = await baseAPI.getAsync(
        '$popularCategories',isCustom: true);
    return response;
  }

  fetchAllCategories() async {
    Map data = {};
    printLog(data.toString());
    var response = await baseAPI.postAsync(
      '$allCategoriesUrl',
      data,
      isCustom: true,
    );
    return response;
  }
}
