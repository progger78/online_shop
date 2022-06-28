import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:online_shop/utils/configurations.dart';
import 'package:online_shop/widgets/app_small_text.dart';

class CartItem with ChangeNotifier {
  final String id;
  final String imageUrl;
  final double price;
  final int quantity;
  final String title;

  CartItem({
    required this.id,
    required this.imageUrl,
    required this.price,
    required this.quantity,
    required this.title,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _cart = {};

  Map<String, CartItem> get cartItem => _cart;

  int get itemsAmount {
    return _cart.length;
  }

  double get totalAmount {
    var totalAmount = 0.0;
    _cart.forEach((key, value) {
      totalAmount += value.price * value.quantity;
    });
    return totalAmount;
  }

  void addItem(String title, double price, String productId, String imgUrl) {
    if (_cart.containsKey(productId)) {
      _cart.update(
          productId,
          (value) => CartItem(
              id: value.id,
              imageUrl: value.imageUrl,
              price: value.price,
              quantity: value.quantity + 1,
              title: value.title));
    } else {
      _cart.putIfAbsent(
          productId,
          () => CartItem(
              id: DateTime.now().toString(),
              imageUrl: imgUrl,
              price: price,
              quantity: 1,
              title: title));
    }
    Get.snackbar(
      'Item added',
      'You\'ve added an item to the cart!',
      backgroundColor: AppColors.yelowColor,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
      snackPosition: SnackPosition.BOTTOM,
      dismissDirection: DismissDirection.horizontal,
      mainButton: TextButton(
          onPressed: () {
            removeSingleItem(productId);
          },
          child: const AppSmallText(
            text: 'Cancel',
            color: Colors.black,
          )),
    );

    notifyListeners();
  }

  void removeItem(String productId) {
    _cart.remove(productId);
    Get.snackbar(
      'Item removed',
      'You\'ve removed an item from the cart!',
      backgroundColor: AppColors.yelowColor,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
      snackPosition: SnackPosition.BOTTOM,
      dismissDirection: DismissDirection.horizontal,
      
    );

    notifyListeners();
  }

  void clear() {
    _cart = {};
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_cart.containsKey(productId)) {
      return;
    }
    if (_cart[productId]!.quantity > 1) {
      _cart.update(
          productId,
          (value) => CartItem(
              id: value.id,
              imageUrl: value.imageUrl,
              price: value.price,
              quantity: value.quantity - 1,
              title: value.title));
    } else {
      _cart.remove(productId);
    }
    notifyListeners();
  }

  

}
