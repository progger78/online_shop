import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:online_shop/provider/cart.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';
import '../utils/utils.dart';

class OrderItem {
  final String id;
  final List<CartItem> products;
  final double amount;
  final DateTime orderTime;
  final int itemsAmount;

  OrderItem(
      {required this.id,
      required this.products,
      required this.itemsAmount,
      required this.amount,
      required this.orderTime});
}

class Order with ChangeNotifier {
  List<OrderItem> _orders = [];
  List<OrderItem> get orders => _orders;

  Future<void> fetchAndSetOrder() async {
    final url = Uri.parse(AppConstants.ordersUrl);
    final response = await http.get(url);
    final List<OrderItem> loadedOrders = [];
    final extractedData = jsonDecode(response.body) as Map<String, dynamic>;
    if (extractedData.isEmpty) {
      return;
    }
    extractedData.forEach((orderId, orderData) {
      loadedOrders.add(OrderItem(
          id: orderId,
          products: (orderData['products'] as List<dynamic>)
              .map((item) => CartItem(
                  id: item['id'],
                  imageUrl: item['imageUrl'],
                  price: item['price'],
                  quantity: item['quantity'],
                  title: item['title']))
              .toList(),
          itemsAmount: orderData['itemsAmount'],
          amount: orderData['amount'],
          orderTime: DateTime.parse(orderData['dateTime'])));
    });
    _orders = loadedOrders.reversed.toList();
  }

  Future<void> addOrder(
      List<CartItem> products, double totalAmount, int itemsAmount) async {
    if (products.isNotEmpty) {
      final url = Uri.parse(AppConstants.ordersUrl);
      final timestamp = DateTime.now();
      final response = await http.post(url,
          body: jsonEncode({
            'amount': totalAmount,
            'itemsAmount': itemsAmount,
            'dateTime': timestamp.toIso8601String(),
            'products': products
                .map((e) => {
                      'id': e.id,
                      'title': e.title,
                      'quantity': e.quantity,
                      'price': e.price,
                      'imageUrl': e.imageUrl,
                    })
                .toList()
          }));
      _orders.insert(
          0,
          OrderItem(
              id: jsonDecode(response.body)['name'],
              products: products,
              amount: totalAmount,
              itemsAmount: itemsAmount,
              orderTime: DateTime.now()));

      Get.snackbar('Order is done', 'You\'ve made the order!',
          backgroundColor: AppColors.yelowColor,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
          snackPosition: SnackPosition.BOTTOM);
    } else {
      Get.snackbar('No products', 'There is nothing to order!',
          backgroundColor: AppColors.yelowColor,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
          snackPosition: SnackPosition.BOTTOM);
    }

    notifyListeners();
  }

  Future<void> deleteOrder(String orderId) async {
    final url = Uri.parse(
        'https://onlineshop-df883-default-rtdb.firebaseio.com/orders/$orderId.json');
    final existingProductIndex =
        _orders.indexWhere((element) => element.id == orderId);
    final existingProduct = _orders[existingProductIndex];
    _orders.removeWhere((element) => element.id == orderId);

    notifyListeners();

    final response = await http.delete(url).then((response) {
      if (response.statusCode >= 400) {
        _orders.insert(existingProductIndex, existingProduct);
        Get.snackbar('Error', 'Could not remove an item!',
            backgroundColor: AppColors.yelowColor,
            colorText: Colors.white,
            duration: const Duration(seconds: 2),
            snackPosition: SnackPosition.BOTTOM,
            dismissDirection: DismissDirection.horizontal,
            icon: const Icon(
              Icons.delete,
              color: Colors.red,
            ),
            shouldIconPulse: true);

        notifyListeners();
        throw HttpException(message: 'Could not delete a product');
      } else {
        _orders.removeWhere((element) => element.id == orderId);
        Get.snackbar('Order removed', 'You\'ve removed your order!',
            backgroundColor: AppColors.yelowColor,
            colorText: Colors.white,
            duration: const Duration(seconds: 2),
            snackPosition: SnackPosition.BOTTOM);
      }
    });
  }
}
