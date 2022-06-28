import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../widgets/custom_dissmisible.dart';
import '/provider/orders.dart';
import '/routes/route_helper.dart';
import '/utils/utils.dart';
import '/widgets/app_big_text.dart';
import '/widgets/app_small_text.dart';

import '/widgets/main_drawer.dart';
import 'package:provider/provider.dart';

class OrdersScreen extends StatelessWidget {
  OrdersScreen({Key? key}) : super(key: key);

  var isExpanded = false;

  final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    print('build again');
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
            Positioned(
              child: Container(
                width: double.maxFinite,
                height: Dimensions.height55 * 2,
                color: AppColors.mainColor,
                child: Padding(
                  padding: EdgeInsets.only(
                      left: Dimensions.width15,
                      top: Dimensions.height25 + 5,
                      right: Dimensions.width15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {
                          _scaffoldState.currentState!.openDrawer();
                        },
                        icon: Icon(
                          Icons.menu,
                          color: Colors.white,
                          size: Dimensions.height45 - 10,
                        ),
                      ),
                      AppBigText(
                          text: 'Your Orders',
                          color: Colors.white,
                          size: Dimensions.font26)
                    ],
                  ),
                ),
              ),
            ),
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
                              future: Provider.of<Order>(context)
                                  .fetchAndSetOrder(),
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
                                        isExpanded: isExpanded,
                                        orderInfo: orderInfo,
                                        index: index,
                                        child: SizedBox(
                                          width: double.maxFinite,
                                          height: Dimensions.height45 * 3,
                                          child: Card(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        Dimensions.radius20)),
                                            elevation: 3,
                                            child: Row(
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                    image:
                                                        const DecorationImage(
                                                            image: AssetImage(
                                                              'assets/images/product-placeholder2.png',
                                                            ),
                                                            fit: BoxFit.cover),
                                                    color: Colors.amber,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      Dimensions.radius20,
                                                    ),
                                                  ),
                                                  width: Dimensions.width45 * 3,
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: Dimensions.width5,
                                                      top: Dimensions.height10),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      AppBigText(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        text:
                                                            '\$${orderInfo.orders[index].amount}',
                                                        color: Colors.black,
                                                      ),
                                                      AppBigText(
                                                        text:
                                                            'Number of items: ${orderInfo.orders[index].itemsAmount}',
                                                        color: Colors.black,
                                                      ),
                                                      Row(
                                                        children: [
                                                          AppBigText(
                                                            text: DateFormat
                                                                    .yMMMEd()
                                                                .format(
                                                              orderInfo
                                                                  .orders[index]
                                                                  .orderTime,
                                                            ),
                                                            color: Colors.black,
                                                          ),
                                                          SizedBox(
                                                            width: Dimensions
                                                                .width20,
                                                          ),
                                                          GestureDetector(
                                                            onTap: () {},
                                                            child: Row(
                                                              children: [
                                                                AppSmallText(
                                                                  text: 'More',
                                                                  color: AppColors
                                                                      .mainColor,
                                                                  size: Dimensions
                                                                          .font22 -
                                                                      4,
                                                                ),
                                                                Padding(
                                                                  padding: EdgeInsets.only(
                                                                      top: Dimensions
                                                                              .height5 -
                                                                          2),
                                                                  child: Icon(
                                                                    isExpanded
                                                                        ? Icons
                                                                            .expand_less
                                                                        : Icons
                                                                            .expand_more,
                                                                    color: AppColors
                                                                        .mainColor,
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
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
