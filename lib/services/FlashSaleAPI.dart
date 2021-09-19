import 'package:nyoba/constant/constants.dart';
import 'package:nyoba/constant/global_url.dart';

class FlashSaleAPI {
  fetchHomeFlashSale() async {
    var response = await baseAPI.getAsync('$homeFlashSale', isCustom: true);
    return response;
  }

  fetchFlashSaleProducts(String productId) async {
    var response = await baseAPI.getAsync('$product?include=$productId');
    return response;
  }
}
