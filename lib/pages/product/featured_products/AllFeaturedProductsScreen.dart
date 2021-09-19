import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:nyoba/models/ProductModel.dart';
import 'package:nyoba/pages/order/CartScreen.dart';
import 'package:nyoba/pages/product/ProductDetailScreen.dart';
import 'package:nyoba/pages/search/SearchScreen.dart';
import 'package:nyoba/provider/ProductProvider.dart';
import 'package:nyoba/services/Session.dart';
import 'package:nyoba/utils/currency_format.dart';
import 'package:nyoba/widgets/contact/ContactFAB.dart';
import 'package:nyoba/widgets/product/GridItemShimmer.dart';
import 'package:provider/provider.dart';
import 'package:nyoba/utils/utility.dart';

class AllFeaturedProducts extends StatefulWidget {
  AllFeaturedProducts({Key key}) : super(key: key);

  @override
  _AllFeaturedProductsState createState() => _AllFeaturedProductsState();
}

class _AllFeaturedProductsState extends State<AllFeaturedProducts> {
  int cartCount = 0;
  int page = 1;
  ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    super.initState();
    final product = Provider.of<ProductProvider>(context, listen: false);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (product.listMoreFeaturedProduct.length % 8 == 0) {
          setState(() {
            page++;
          });
          fetchNewProduct();
        }
      }
    });
    fetchNewProduct();
  }

  Future loadCartCount() async {
    print('Load Count');
    List<ProductModel> productCart = [];
    int _count = 0;

    if (Session.data.containsKey('cart')) {
      List listCart = await json.decode(Session.data.getString('cart'));

      productCart = listCart
          .map((product) => new ProductModel.fromJson(product))
          .toList();

      productCart.forEach((element) {
        _count += element.cartQuantity;
      });
    }
    setState(() {
      cartCount = _count;
    });
  }

  fetchNewProduct() async {
    await Provider.of<ProductProvider>(context, listen: false)
        .fetchFeaturedProducts(page: page);
    loadCartCount();
  }

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<ProductProvider>(context, listen: false);

    Widget buildItems = ListenableProvider.value(
      value: product,
      child: Consumer<ProductProvider>(builder: (context, value, child) {
        if (value.loadingFeatured && page == 1) {
          return Expanded(
            child: GridView.builder(
                shrinkWrap: true,
                itemCount: 6,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 1 / 2,
                    crossAxisCount: 2,
                    mainAxisSpacing: 15,
                    crossAxisSpacing: 15),
                itemBuilder: (context, i) {
                  return GridItemShimmer();
                }),
          );
        }
        if (value.listMoreFeaturedProduct.isEmpty) {
          return buildSearchEmpty();
        }
        return Expanded(
          child: GridView.builder(
              controller: _scrollController,
              shrinkWrap: true,
              itemCount: value.listMoreFeaturedProduct.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 1 / 2,
                  crossAxisCount: 2,
                  mainAxisSpacing: 15,
                  crossAxisSpacing: 15),
              itemBuilder: (context, i) {
                return itemGridList(
                    value.listMoreFeaturedProduct[i].productName,
                    value.listMoreFeaturedProduct[i].discProduct
                        .toInt()
                        .toString(),
                    value.listMoreFeaturedProduct[i].productPrice,
                    value.listMoreFeaturedProduct[i].productRegPrice,
                    i,
                    value.listMoreFeaturedProduct[i].productStock,
                    value.listMoreFeaturedProduct[i].images[0].src,
                    value.listMoreFeaturedProduct[i]);
              }),
        );
      }),
    );

    return Scaffold(
      floatingActionButton: ContactFAB(),
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back, color: Colors.black),
        ),
        title: Container(
          height: 38,
          child: Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SearchScreen()));
                  },
                  child: TextField(
                    style: TextStyle(fontSize: 14),
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                      isDense: true,
                      isCollapsed: true,
                      enabled: false,
                      filled: true,
                      fillColor: Colors.white,
                      border: new OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(5),
                        ),
                      ),
                      prefixIcon: Icon(Icons.search),
                      hintText: "Search",
                      hintStyle: TextStyle(fontSize: responsiveFont(10)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CartScreen(
                            isFromHome: false,
                          )));
            },
            child: Container(
              width: 65,
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart,
                    color: Colors.black,
                  ),
                  Positioned(
                    right: 0,
                    top: 7,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: primaryColor),
                      alignment: Alignment.center,
                      child: Text(
                        cartCount.toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: responsiveFont(9),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
      body: Container(
          margin: EdgeInsets.all(10),
          child: Column(
            children: [
              buildItems,
              if (product.loadingNew && page != 1) customLoading()
            ],
          )),
    );
  }

  Widget itemGridList(
      String title,
      String discount,
      String price,
      String crossedPrice,
      int i,
      int stock,
      String image,
      ProductModel productDetail) {
    return Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(5)),
        child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ProductDetail(
                          productId: productDetail.id.toString(),
                        )));
          },
          child: Card(
            elevation: 5,
            margin: EdgeInsets.only(bottom: 1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Image.network(image),
                  ),
                ),
                Expanded(
                    flex: 2,
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            flex: 2,
                            child: Text(
                              title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: responsiveFont(10)),
                            ),
                          ),
                          Container(
                            height: 5,
                          ),
                          Visibility(
                            visible: discount != "0",
                            child: Flexible(
                              flex: 1,
                              child: Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: secondaryColor,
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 3, horizontal: 7),
                                    child: Text(
                                      '$discount%',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: responsiveFont(9)),
                                    ),
                                  ),
                                  Container(
                                    width: 5,
                                  ),
                                  Text(
                                    stringToCurrency(
                                        double.parse(crossedPrice), context),
                                    style: TextStyle(
                                        fontSize: responsiveFont(8),
                                        color: HexColor("C4C4C4"),
                                        decoration: TextDecoration.lineThrough),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: FittedBox(
                              child: Text(
                                stringToCurrency(double.parse(price), context),
                                style: TextStyle(
                                    fontSize: responsiveFont(10),
                                    color: secondaryColor,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                          Container(
                            height: 5,
                          ),
                          stock != null && stock != 0
                              ? Text(
                                  "Available : $stock In Stock",
                                  style: TextStyle(fontSize: responsiveFont(8)),
                                )
                              : Text(
                                  "Out of stock",
                                  style: TextStyle(
                                      fontSize: responsiveFont(8),
                                      color: Colors.red),
                                )
                        ],
                      ),
                    )),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: secondaryColor, //Color of the border
                            //Style of the border
                          ),
                          alignment: Alignment.center,
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(5))),
                      onPressed: () {
                        showMaterialModalBottomSheet(
                          context: context,
                          builder: (context) => ModalSheetCart(
                            product: productDetail,
                            type: 'add',
                            loadCount: loadCartCount,
                          ),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add,
                            size: responsiveFont(9),
                            color: secondaryColor,
                          ),
                          Text(
                            "Add to Cart",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: responsiveFont(9),
                                color: secondaryColor),
                          )
                        ],
                      )),
                )
              ],
            ),
          ),
        ));
  }

  Widget buildSearchEmpty() {
    return Center(
      child: ListView(
        shrinkWrap: true,
        physics: ScrollPhysics(),
        children: [
          Image.asset("images/search/search_empty.png"),
          Container(
            alignment: Alignment.topCenter,
            child: Text(
              "Can't find the products",
              style: TextStyle(fontSize: 18),
            ),
          )
        ],
      ),
    );
  }
}
