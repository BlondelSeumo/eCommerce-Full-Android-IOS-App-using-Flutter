import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:nyoba/pages/order/CartScreen.dart';
import 'package:nyoba/provider/OrderProvider.dart';
import 'package:nyoba/provider/WishlistProvider.dart';
import 'package:nyoba/services/Session.dart';
import 'package:nyoba/widgets/wishlist/ListItemWishlist.dart';
import 'package:nyoba/widgets/wishlist/ShimmerWishlist.dart';
import 'package:provider/provider.dart';
import '../../AppLocalizations.dart';
import '../../utils/utility.dart';

class WishList extends StatefulWidget {
  WishList({Key key}) : super(key: key);

  @override
  _WishListState createState() => _WishListState();
}

class _WishListState extends State<WishList> {
  int cartCount = 0;

  load() async {
    final wishlist = Provider.of<WishlistProvider>(context, listen: false);

    if (Session.data.getBool('isLogin')) {
      await Provider.of<WishlistProvider>(context, listen: false)
          .loadWishlistProduct()
          .then((value) async {
        await Provider.of<WishlistProvider>(context, listen: false)
            .fetchWishlistProducts(wishlist.productWishlist);
      });
    }
    loadCartCount();
  }

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<dynamic> loadCartCount() async {
    await Provider.of<OrderProvider>(context, listen: false)
        .loadCartCount()
        .then((value) {
      setState(() {
        cartCount = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final wishlist = Provider.of<WishlistProvider>(context, listen: false);

    Widget buildWishlist = Container(
      child: ListenableProvider.value(
        value: wishlist,
        child: Consumer<WishlistProvider>(builder: (context, value, child) {
          if (value.loadingWishlist) {
            return ListView.separated(
              shrinkWrap: true,
              itemBuilder: (context, i) {
                return GestureDetector(
                    onTap: () {},
                    child: ShimmerWishlist(
                      i: i,
                      itemCount: 6,
                    ));
              },
              itemCount: 6,
              separatorBuilder: (BuildContext context, int index) {
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 18),
                  width: double.infinity,
                  height: 1,
                  color: HexColor("c4c4c4"),
                );
              },
            );
          }
          if (value.listWishlistProduct.isEmpty) {
            return Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 48,
                    color: primaryColor,
                  ),
                  Text(AppLocalizations.of(context).translate('wishlist_empty'))
                ],
              ),
            );
          }
          return ListView.separated(
            shrinkWrap: true,
            itemBuilder: (context, i) {
              return ListItemWishlist(
                i: i,
                product: wishlist.listWishlistProduct[i],
                itemCount: wishlist.listWishlistProduct.length,
                loadCartCount: loadCartCount,
              );
            },
            itemCount: wishlist.listWishlistProduct.length,
            separatorBuilder: (BuildContext context, int index) {
              return Container(
                margin: EdgeInsets.symmetric(vertical: 18),
                width: double.infinity,
                height: 1,
                color: HexColor("c4c4c4"),
              );
            },
          );
        }),
      ),
    );

    Widget buildNotLogin = buildNoAuth(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
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
        title: Text(
          "Wishlist",
          style: TextStyle(
              color: Colors.black,
              fontSize: responsiveFont(16),
              fontWeight: FontWeight.w500),
        ),
      ),
      body: Container(
        margin: EdgeInsets.all(15),
        child: Session.data.getBool('isLogin') ? buildWishlist : buildNotLogin,
      ),
    );
  }
}
