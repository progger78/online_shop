import 'package:get/get.dart';
import 'package:online_shop/screens/auth_screen/auth-screen.dart';
import '/screens/cart_screen.dart/cart_screen.dart';
import '/screens/detail_product_screen/detail_product_screen.dart';
import '/screens/edit_product_screen/edit_product_screen.dart';
import '/screens/main_product_screen/main_product_screen.dart';
import '/screens/orders_screen/orders_screen.dart';
import '/screens/user_product_screen/user_product_screen.dart';

class RouteHelper {
  static const String initialScreen = '/';
  static const String detailProductScreen = '/detail-product-screen';
  static const String cartScreen = '/cart-screen';
  static const String ordersScreen = '/order-screen';
  static const String userProductScreen = '/user-product-screen';
  static const String editProductScreen = '/edit-product-screen';
  static const String authScreen = '/auth-screen';
  static const String mainFoodScreen = '/main-food-screen';

  static getInitial() => initialScreen;
  static getDetailProductScreen(int pageId) =>
      '$detailProductScreen?pageId=$pageId';
  static getCartScreen() => cartScreen;
  static getOrdersScreen() => ordersScreen;
  static getUserProductScreen() => userProductScreen;
  static getAuthScreen() => authScreen;
  static getEditProductScreen(int? pageId) =>
      '$editProductScreen?pageId=$pageId';
  static List<GetPage> pages = [
    GetPage(
        name: initialScreen,
        transition: Transition.fadeIn,
        page: () {
          return AuthScreen();
        }),
    GetPage(
        name: mainFoodScreen ,
        transition: Transition.fadeIn,
        page: () {
          return const MainProductScreen();
        }),
    GetPage(
        name: detailProductScreen,
        transition: Transition.fadeIn,
        page: () {
          var pageId = Get.parameters['pageId'];

          return DetailProductScreen(pageId: int.parse(pageId!));
        }),
    GetPage(
        name: cartScreen,
        transition: Transition.fadeIn,
        page: () {
          return CartScreen();
        }),
    GetPage(
        name: ordersScreen,
        transition: Transition.fadeIn,
        page: () {
          return OrdersScreen();
        }),
    GetPage(
        name: userProductScreen,
        transition: Transition.fadeIn,
        page: () {
          return UserProductScreen();
        }),
    GetPage(
        name: editProductScreen,
        transition: Transition.fadeIn,
        page: () {
          var pageId = Get.parameters['pageId'];
          return EditProductScreen(pageId: int.parse(pageId!));
        })
  ];
}
