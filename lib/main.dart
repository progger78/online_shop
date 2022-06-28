import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:online_shop/provider/orders.dart';

import 'package:online_shop/routes/route_helper.dart';
import 'package:provider/provider.dart';

import 'provider/cart.dart';
import 'provider/products.dart';
import 'screens/main_product_screen/main_product_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Products(),
        ),
        ChangeNotifierProvider(
          create: (context) => Cart(),
        ),
        ChangeNotifierProvider(create:(context) => Order(),)
      ],
      child: GetMaterialApp(

        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        home: MainProductScreen(),
        initialRoute: RouteHelper.initialScreen,
        getPages: RouteHelper.pages,
      ),
    );
  }
}
