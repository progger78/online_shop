class AppConstants {
  static const String appName = 'food_delivery';
  static const int appVersion = 1;

  static const String baseUrl = 'http://mvs.bslmeiyu.com';
  static const String productsUrl =
      'https://onlineshop-df883-default-rtdb.firebaseio.com/products.json';
  static const String ordersUrl =
      'https://onlineshop-df883-default-rtdb.firebaseio.com/orders.json';
  static const String sighUpUrl =
      'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyB-o02dwnztrbAj586UFi2f-xwgjA-WDyM';
        static const String signInUrl =
      'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyB-o02dwnztrbAj586UFi2f-xwgjA-WDyM';
  static const String recommendedProductUrl = '/api/v1/products/recommended';

  static const String token = 'MyToken';
  static const String uploadUrl = '/uploads/';

  static const String cartList = 'Cart-list';
  static const String cartHistoryList = 'Cart-history-list';
}
