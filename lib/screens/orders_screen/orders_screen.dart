import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../widgets/custom_dissmisible.dart';
import '/provider/orders.dart';
import '/routes/route_helper.dart';
import '/utils/utils.dart';
import '/widgets/app_big_text.dart';
import 'components/order_item.dart' as order;

import '/widgets/main_drawer.dart';
import 'package:provider/provider.dart';

import 'components/orders_app_bar.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  late Future _ordersFuture;
  Future _obtainFuture() {
    return Provider.of<Order>(context, listen: false).fetchAndSetOrder();
  }

  @override
  void initState() {
    _ordersFuture = _obtainFuture();
    super.initState();
  }



  final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 245, 245, 245),
      key: _scaffoldState,
      drawer: const AppDrawer(),
      body: SizedBox(
        height: size.height,
        width: size.width,
        child: Stack(
          children: [
            OrdersAppBar(scaffoldState: _scaffoldState),
            Positioned(
              top: size.height * 0.12,
              left: 0,
              right: 0,
              bottom: 0,
              child: Consumer<Order>(
                builder: (context, value, child) => Container(
                  margin: EdgeInsets.only(top: Dimensions.height10),
                  height: 0.75,
                  width: double.maxFinite,
                  child: MediaQuery.removePadding(
                    context: context,
                    removeBottom: true,
                    removeTop: true,
                    child: value.orders.isEmpty
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: Image.asset(
                                    'assets/images/missing_orders.png'),
                              ),
                              TextButton.icon(
                                onPressed: () {
                                  Get.toNamed(RouteHelper.initialScreen);
                                },
                                label: AppBigText(
                                  text: 'Let\'s Go Shopping',
                                  color: AppColors.mainColor,
                                ),
                                icon: const Icon(
                                  Icons.shopping_basket,
                                  color: AppColors.yelowColor,
                                ),
                              )
                            ],
                          )
                        : Consumer<Order>(
                            builder: (context, orderInfo, child) =>
                                FutureBuilder(
                              future: _ordersFuture,
                              builder: (BuildContext context,
                                  AsyncSnapshot snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                    child: CircularProgressIndicator(
                                      color: AppColors.mainColor,
                                      backgroundColor: AppColors.yelowColor,
                                    ),
                                  );
                                } else if (snapshot.error != null) {
                                  return Center(
                                    child: AppBigText(
                                        text: 'A problem occured...',
                                        color: Colors.black),
                                  );
                                } else {
                                  return ListView.builder(
                                    itemCount: orderInfo.orders.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return CustomDismissible(
                                        
                                        orderInfo: orderInfo,
                                        index: index,
                                        child: SizedBox(
                                          width: double.maxFinite,
                                          height: Dimensions.height45 * 3,
                                          child: order.OrderItem(
                                             
                                              orderInfo: orderInfo,
                                              index: index),
                                        ),
                                      );
                                    },
                                  );
                                }
                              },
                            ),
                          ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
