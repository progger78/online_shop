import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/provider/auth.dart';
import '/provider/orders.dart';

import '/routes/route_helper.dart';
import '/screens/auth_screen/auth-screen.dart';
import '/screens/main_product_screen/main_product_screen.dart';
import '/screens/splash_screen/splash-screen.dart';
import '/utils/configurations.dart';
import 'package:provider/provider.dart';

import 'provider/cart.dart';
import 'provider/products.dart';

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
          create: (context) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
            update: (ctx, authData, previous) => Products(
                  authData.token ?? '',
                  authData.userId ?? '',
                  previous != null ? [] : previous!.items,
                ),
            create: (_) => Products('', '', [])),
        ChangeNotifierProvider(
          create: (context) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Order>(
          update: (context, value, previous) => Order(
            value.token,
            value.userId,
            previous != null ? [] : previous!.orders,
          ),
          create: (context) => Order('', '', []),
        ),
      ],
      child: Consumer<Auth>(
        builder: (context, authData, child) => GetMaterialApp(
          theme: ThemeData(primaryColor: AppColors.mainColor),
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          home: authData.isAuth
              ? const MainProductScreen()
              : FutureBuilder(
                  future: authData.tryAutoLogin(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) =>
                      snapshot.connectionState == ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen()),

      
          getPages: RouteHelper.pages,
          initialRoute: RouteHelper.initialScreen,
        ),
      ),
    );
  }
}
