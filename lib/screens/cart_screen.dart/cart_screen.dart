import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:online_shop/widgets/main_drawer.dart';
import '/provider/cart.dart';
import '/provider/orders.dart';
import '/routes/route_helper.dart';
import '/utils/utils.dart';
import '/widgets/app_big_text.dart';
import '/widgets/app_icon.dart';
import 'package:provider/provider.dart';

import '../../widgets/app_small_text.dart';

class CartScreen extends StatelessWidget {
  CartScreen({Key? key}) : super(key: key);
  final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var cart = Provider.of<Cart>(context);
    return Scaffold(
        key: _scaffoldState,
        backgroundColor: Colors.white,
        drawer: const AppDrawer(),
        body: SizedBox(
          height: size.height,
          width: size.width,
          child: Stack(
            children: [
              Positioned(
                  child: Container(
                height: Dimensions.height45,
                margin: EdgeInsets.only(
                    top: Dimensions.height45 + 5,
                    right: Dimensions.width20,
                    left: Dimensions.width20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: () => _scaffoldState.currentState!.openDrawer(),
                      child: AppIcon(
                        icon: Icons.menu,
                        backgorundColor: AppColors.mainColor,
                        iconColor: Colors.white,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        Get.toNamed(RouteHelper.getInitial());
                      },
                      child: AppIcon(
                        icon: Icons.home_outlined,
                        backgorundColor: AppColors.mainColor,
                        iconColor: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.toNamed(RouteHelper.getOrdersScreen());
                      },
                      child: AppIcon(
                        icon: Icons.history,
                        backgorundColor: AppColors.mainColor,
                        iconColor: Colors.white,
                      ),
                    )
                  ],
                ),
              )),
              Positioned(
                top: Dimensions.height55 * 2,
                left: Dimensions.width20,
                right: Dimensions.width20,
                bottom: 0,
                child: Container(
                  child: MediaQuery.removePadding(
                    removeBottom: true,
                    removeTop: true,
                    context: context,
                    child: cart.cartItem.isEmpty
                        ? Column(
                            children: [
                              Center(
                                child: Image.asset(
                                    'assets/images/empty_shoping_cart.jpg'),
                              ),
                              AppBigText(
                                text: 'No products yet, let\'s add some!',
                                color: AppColors.mainTextColor,
                                size: Dimensions.font26,
                              )
                            ],
                          )
                        : ListView.builder(
                            itemCount: cart.itemsAmount,
                            itemBuilder: (BuildContext context, int index) {
                              return Dismissible(
                                direction: DismissDirection.endToStart,
                                background: Container(
                                  margin: EdgeInsets.only(
                                      bottom: Dimensions.height10),
                                  color: Colors.red,
                                  padding: EdgeInsets.only(
                                    right: Dimensions.width25,
                                  ),
                                  alignment: Alignment.centerRight,
                                  child: Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                    size: Dimensions.height45,
                                  ),
                                ),
                                key: ValueKey(
                                    cart.cartItem.values.toList()[index].id),
                                confirmDismiss: (direction) {
                                  return showDialog(
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        Dimensions.radius20)),
                                            content: const AppSmallText(
                                              text:
                                                  'Do you want to delete the item?',
                                              color: Colors.black,
                                            ),
                                            title: AppBigText(
                                              text: 'Are you sure?',
                                              color: Colors.black,
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(ctx).pop(true);
                                                },
                                                child: const AppSmallText(
                                                  text: 'Yes',
                                                  color: Colors.red,
                                                ),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(ctx).pop(false);
                                                },
                                                child: const AppSmallText(
                                                  text: 'No',
                                                  color: AppColors.mainColor,
                                                ),
                                              ),
                                            ],
                                          ));
                                },
                                onDismissed: (direction) {
                                  Provider.of<Cart>(context, listen: false)
                                      .removeItem(
                                          cart.cartItem.keys.toList()[index]);
                                },
                                child: Card(
                                  elevation: 2,
                                  child: Container(
                                    margin: EdgeInsets.only(
                                        bottom: Dimensions.height10),
                                    height: Dimensions.height55 * 2.5,
                                    width: double.maxFinite,
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            width: Dimensions.height55 * 2.5,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      Dimensions.radius20),
                                              image: DecorationImage(
                                                  image: NetworkImage(cart
                                                      .cartItem.values
                                                      .toList()[index]
                                                      .imageUrl),
                                                  fit: BoxFit.cover),
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              margin: EdgeInsets.only(
                                                  left: Dimensions.width5,
                                                  top: Dimensions.height5),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  AppBigText(
                                                      color:
                                                          AppColors.mainColor,
                                                      size: Dimensions.font26,
                                                      text: cart.cartItem.values
                                                          .toList()[index]
                                                          .title),
                                                  AppBigText(
                                                    size: Dimensions.font26,
                                                    color: AppColors.mainColor,
                                                    text:
                                                        '${cart.cartItem.values.toList()[index].quantity} x',
                                                  ),
                                                  Chip(
                                                    backgroundColor:
                                                        AppColors.mainColor,
                                                    label: AppSmallText(
                                                      color: Colors.black,
                                                      text:
                                                          '\$ ${cart.cartItem.values.toList()[index].price}',
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ]),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ),
              )
            ],
          ),
        ),
        bottomNavigationBar: Container(
          height: Dimensions.height55 * 3,
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.3),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(Dimensions.radius45),
                topRight: Radius.circular(Dimensions.radius45)),
          ),
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: Dimensions.width20),
                child: AppBigText(
                  size: Dimensions.font26,
                  fontWeight: FontWeight.bold,
                  text: '\$${cart.totalAmount.toStringAsFixed(2)}',
                  color: Colors.white,
                ),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(
                      left: Dimensions.width15, right: Dimensions.width15),
                  height: Dimensions.height70,
                  width: Dimensions.width45 * 3,
                  decoration: BoxDecoration(
                    color: AppColors.mainColor,
                    borderRadius: BorderRadius.circular(
                      Dimensions.radius20,
                    ),
                  ),
                  child: OrderButton(cart: cart),
                ),
              ),
            ],
          ),
        ));
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key? key,
    required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const CircularProgressIndicator(
            color: AppColors.mainColor,
            backgroundColor: AppColors.yelowColor,
          )
        : GestureDetector(
            onTap: () async {
              setState(() {
                _isLoading = true;
              });
              await Provider.of<Order>(context, listen: false).addOrder(
                  widget.cart.cartItem.values.toList(),
                  widget.cart.totalAmount,
                  widget.cart.itemsAmount);
              setState(() {
                _isLoading = false;
              });
              widget.cart.clear();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                VerticalDivider(
                  thickness: 2,
                  endIndent: Dimensions.height20,
                  indent: Dimensions.height25,
                  color: Colors.white,
                ),
                AppSmallText(
                    differSize: true,
                    text: 'Add To Cart',
                    color: Colors.white,
                    size: Dimensions.font26 - 2)
              ],
            ),
          );
  }
}
