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

class AllNewProducts extends StatefulWidget {
  final String type;
  final String category;
  AllNewProducts({Key key, this.type, this.category}) : super(key: key);

  @override
  _AllNewProductsState createState() => _AllNewProductsState();
}

class _AllNewProductsState extends State<AllNewProducts> {
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
        if (product.listMoreNewProduct.length % 8 == 0) {
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
        .fetchNewProducts(widget.category, page: page);
    loadCartCount();
  }

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<ProductProvider>(context, listen: false);

    Widget buildItems = ListenableProvider.value(
      value: product,
      child: Consumer<ProductProvider>(builder: (context, value, child) {
        if (value.loadingNew && page == 1) {
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
        if (value.listMoreNewProduct.isEmpty) {
          return buildSearchEmpty();
        }
        return Expanded(
          child: GridView.builder(
              controller: _scrollController,
              shrinkWrap: true,
              itemCount: value.listMoreNewProduct.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 1 / 2,
                  crossAxisCount: 2,
                  mainAxisSpacing: 15,
                  crossAxisSpacing: 15),
              itemBuilder: (context, i) {
                if (value.listMoreNewProduct[i].productSalePrice.isNotEmpty) {
                  value.listMoreNewProduct[i].discProduct = ((double.parse(
                                  value.listMoreNewProduct[i].productRegPrice) -
                              double.parse(value
                                  .listMoreNewProduct[i].productSalePrice)) /
                          double.parse(
                              value.listMoreNewProduct[i].productRegPrice)) *
                      100;
                } else {
                  value.listMoreNewProduct[i].discProduct = 0;
                }
                return itemGridList(
                    value.listMoreNewProduct[i].productName,
                    value.listMoreNewProduct[i].discProduct.round().toString(),
                    value.listMoreNewProduct[i].productPrice,
                    value.listMoreNewProduct[i].productRegPrice,
                    i,
                    value.listMoreNewProduct[i].productStock,
                    value.listMoreNewProduct[i].images[0].src,
                    value.listMoreNewProduct[i]);
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
                          Text(
                            "Available : $stock In Stock",
                            style: TextStyle(fontSize: responsiveFont(8)),
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
