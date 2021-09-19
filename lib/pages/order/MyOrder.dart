import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:nyoba/models/OrderModel.dart';
import 'package:nyoba/pages/order/OrderDetail.dart';
import 'package:nyoba/provider/OrderProvider.dart';
import 'package:nyoba/services/Session.dart';
import 'package:nyoba/utils/currency_format.dart';
import 'package:nyoba/widgets/order/OrderListShimmer.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../AppLocalizations.dart';
import '../../utils/utility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyOrder extends StatefulWidget {
  MyOrder({Key key}) : super(key: key);

  @override
  _MyOrderState createState() => _MyOrderState();
}

class _MyOrderState extends State<MyOrder> {
  String currentStatus = 'pending';
  TextEditingController searchController = new TextEditingController();

  String search = '';
  int currType = 1;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    loadListOrder();
  }

  loadListOrder() async {
    this.setState(() {});
    if (Session.data.getBool('isLogin')) {
      if (isNumeric(search)){
        await Provider.of<OrderProvider>(context, listen: false)
            .fetchOrders(status: currentStatus, orderId: search);
      } else {
        await Provider.of<OrderProvider>(context, listen: false)
            .fetchOrders(status: currentStatus, search: search);
      }
      _refreshController.refreshCompleted();
    }
  }

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return int.tryParse(s) != null;
  }

  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<OrderProvider>(context, listen: false);
    Widget buildOrders = SmartRefresher(
      controller: _refreshController,
      onRefresh: loadListOrder,
      child: Container(
        child: ListenableProvider.value(
          value: orders,
          child: Consumer<OrderProvider>(builder: (context, value, child) {
            if (value.isLoading) {
              return OrderListShimmer();
            }
            if (value.listOrder.isEmpty) {
              return buildTransactionEmpty();
            }
            return ListView.builder(
                itemCount: value.listOrder.length,
                shrinkWrap: true,
                physics: ScrollPhysics(),
                itemBuilder: (context, i) {
                  return orderItem(value.listOrder[i]);
                });
          }),
        ),
      ),
    );

    return Scaffold(
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
        title: Text(
          AppLocalizations.of(context).translate('my_order'),
          style: TextStyle(color: Colors.black, fontSize: responsiveFont(16)),
        ),
      ),
      body: !Session.data.getBool('isLogin')
          ? Center(
              child: buildNoAuth(context),
            )
          : Container(
              margin: EdgeInsets.all(15),
              child: Column(
                children: [
                  Container(
                    height: 30.h,
                    child: TextField(
                      controller: searchController,
                      style: TextStyle(fontSize: 14),
                      textAlignVertical: TextAlignVertical.center,
                      onSubmitted: (value) {
                        setState(() {});
                        loadListOrder();
                      },
                      onChanged: (value){
                        setState(() {
                          search = value;
                        });
                      },
                      textInputAction: TextInputAction.search,
                      decoration: InputDecoration(
                        isDense: true,
                        isCollapsed: true,
                        filled: true,
                        border: new OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(5),
                          ),
                        ),
                        prefixIcon: Icon(Icons.search),
                        hintText: AppLocalizations.of(context)
                            .translate('search_transaction'),
                        hintStyle: TextStyle(fontSize: responsiveFont(10)),
                      ),
                    ),
                  ),
                  Container(
                    height: 15,
                  ),
                  buildTabStatus(),
                  Container(
                    height: 10,
                  ),
                  Expanded(
                    child: buildOrders,
                  )
                ],
              ),
            ),
    );
  }

  Widget orderItem(OrderModel orderModel) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: HexColor("c4c4c4")),
                  height: 50.h,
                  width: 50.h,
                  child: Image.network(orderModel.productItems[0].image),
                ),
                Container(
                  width: 15,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        orderModel.productItems[0].productName,
                        style: TextStyle(
                            fontSize: responsiveFont(10),
                            fontWeight: FontWeight.w600),
                      ),
                      Text(
                        "${orderModel.productItems[0].quantity} item",
                        style: TextStyle(fontSize: responsiveFont(10)),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          Visibility(
            visible: orderModel.productItems.length > 1,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                "+${orderModel.productItems.length - 1} ${AppLocalizations.of(context).translate('other_product')}",
                style: TextStyle(fontSize: responsiveFont(10)),
              ),
            ),
          ),
          Container(
            height: 5,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context).translate('total_cost'),
                      style: TextStyle(fontSize: responsiveFont(8)),
                    ),
                    orderModel.discountTotal != "0"
                        ? Text(
                            stringToCurrency(
                                double.parse(orderModel.total) -
                                    double.parse(orderModel.discountTotal),
                                context),
                            style: TextStyle(
                                fontSize: responsiveFont(10),
                                fontWeight: FontWeight.w500),
                          )
                        : Text(
                            stringToCurrency(
                                double.parse(orderModel.total), context),
                            style: TextStyle(
                                fontSize: responsiveFont(10),
                                fontWeight: FontWeight.w500),
                          )
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [primaryColor, secondaryColor])),
                  height: 30.h,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => OrderDetail(
                                    orderId: orderModel.id.toString(),
                                  )));
                    },
                    child: Text(
                      AppLocalizations.of(context).translate('more_detail'),
                      style: TextStyle(
                          color: Colors.white, fontSize: responsiveFont(10)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Order ID : ${orderModel.id}",
                      style: TextStyle(
                        fontSize: responsiveFont(10),
                      ),
                    ),
                    Text(
                      convertDateFormatShortMonth(
                          DateTime.parse(orderModel.dateCreated)),
                      style: TextStyle(
                          fontSize: responsiveFont(8),
                          fontWeight: FontWeight.w500),
                    )
                  ],
                ),
                buildStatusOrder(orderModel.status)
              ],
            ),
          ),
          Container(
            color: HexColor("c4c4c4"),
            height: 1,
            width: double.infinity,
            margin: EdgeInsets.symmetric(vertical: 10),
          ),
        ],
      ),
    );
  }

  Widget buildStatusOrder(String status) {
    var color = 'FFFFFF';
    var colorText = 'FFFFFF';
    var statusText = '';

    if (status == 'pending') {
      color = 'FFCDD2';
      colorText = 'B71C1C';
      statusText = 'Waiting For Payment';
    } else if (status == 'on-hold') {
      color = 'FFF9C4';
      colorText = 'F57F17';
      statusText = 'On Hold';
    } else if (status == 'processing') {
      color = 'FFF9C4';
      colorText = 'F57F17';
      statusText = 'Processing';
    } else if (status == 'completed') {
      color = 'C8E6C9';
      colorText = '1B5E20';
      statusText = 'Completed';
    } else if (status == 'cancelled') {
      color = 'CFD8DC';
      colorText = '333333';
      statusText = 'Canceled';
    } else if (status == 'refunded') {
      color = 'B2EBF2';
      colorText = '006064';
      statusText = 'Refunded';
    } else if (status == 'failed') {
      color = 'FFCCBC';
      colorText = 'BF360C';
      statusText = 'Failed';
    }

    return Container(
      color: HexColor(color),
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      child: Text(
        statusText,
        style:
            TextStyle(fontSize: responsiveFont(10), color: HexColor(colorText)),
      ),
    );
  }

  Widget buildTabStatus() {
    return Container(
      height: 65.h,
      child: ListView(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                currType = 1;
                currentStatus = 'pending';
              });
              loadListOrder();
            },
            child: Container(
              width: 70.w,
              height: 60.h,
              child: Column(
                children: [
                  Container(
                      width: 30.w,
                      height: 30.h,
                      child: currType == 1
                          ? Image.asset("images/order/pending.png")
                          : Image.asset("images/order/pending_dark.png")),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    AppLocalizations.of(context).translate('pending'),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: responsiveFont(10)),
                  )
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                currType = 2;
                currentStatus = 'on-hold';
              });
              loadListOrder();
            },
            child: Container(
              width: 70.w,
              height: 60.h,
              child: Column(
                children: [
                  Container(
                      width: 30.w,
                      height: 30.h,
                      child: currType == 2
                          ? Image.asset("images/order/hold.png")
                          : Image.asset("images/order/hold_dark.png")),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    AppLocalizations.of(context).translate('on_hold'),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: responsiveFont(10)),
                  )
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                currType = 3;
                currentStatus = 'processing';
              });
              loadListOrder();
            },
            child: Container(
              width: 70.w,
              height: 60.h,
              child: Column(
                children: [
                  Container(
                      width: 30.w,
                      height: 30.h,
                      child: currType == 3
                          ? Image.asset("images/order/processing.png")
                          : Image.asset("images/order/processing_dark.png")),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    AppLocalizations.of(context).translate('processing'),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: responsiveFont(10)),
                  )
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                currType = 4;
                currentStatus = 'completed';
              });
              loadListOrder();
            },
            child: Container(
              width: 70.w,
              height: 60.h,
              child: Column(
                children: [
                  Container(
                      width: 30.w,
                      height: 30.h,
                      child: currType == 4
                          ? Image.asset("images/order/completed.png")
                          : Image.asset("images/order/completed_dark.png")),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    AppLocalizations.of(context).translate('completed'),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: responsiveFont(10)),
                  )
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                currType = 5;
                currentStatus = 'cancelled';
              });
              loadListOrder();
            },
            child: Container(
              width: 70.w,
              height: 60.h,
              child: Column(
                children: [
                  Container(
                      width: 30.w,
                      height: 30.h,
                      child: currType == 5
                          ? Image.asset("images/order/cancel.png")
                          : Image.asset("images/order/cancel_dark.png")),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    AppLocalizations.of(context).translate('cancel'),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: responsiveFont(10)),
                  )
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                currType = 6;
                currentStatus = 'refunded';
              });
              loadListOrder();
            },
            child: Container(
              width: 70.w,
              height: 60.h,
              child: Column(
                children: [
                  Container(
                      width: 30.w,
                      height: 30.h,
                      child: currType == 6
                          ? Image.asset("images/order/refund.png")
                          : Image.asset("images/order/refund_dark.png")),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    AppLocalizations.of(context).translate('refunded'),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: responsiveFont(10)),
                  )
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                currType = 7;
                currentStatus = 'failed';
              });
              loadListOrder();
            },
            child: Container(
              width: 70.w,
              height: 60.h,
              child: Column(
                children: [
                  Container(
                      width: 30.w,
                      height: 30.h,
                      child: currType == 7
                          ? Image.asset("images/order/failed.png")
                          : Image.asset("images/order/failed_dark.png")),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    AppLocalizations.of(context).translate('failed'),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: responsiveFont(10)),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  buildTransactionEmpty() {
    return Center(
      child: Column(
        children: [
          Image.asset(
            "images/order/empty_list.png",
            width: 250.w,
            height: 220.h,
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 15),
            child: Text(
              AppLocalizations.of(context).translate('no_transaction'),
              style: TextStyle(
                  fontSize: responsiveFont(14), fontWeight: FontWeight.w500),
            ),
          )
        ],
      ),
    );
  }
}
