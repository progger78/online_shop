import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:online_shop/models/http_exception.dart';
import 'package:online_shop/utils/app_constants.dart';

import '../utils/utils.dart';

class Product with ChangeNotifier {
  final String? id;
  final String description;
  final String title;
  final double price;
  final String imageUrl;
  bool isFavorite;
  Product(
      {required this.id,
      required this.title,
      required this.description,
      required this.price,
      required this.imageUrl,
      this.isFavorite = false});

  void _setFavValue(bool newValue) {
    isFavorite = newValue;
    notifyListeners();
  }

  Future<void> toggleFavorite() async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;

    notifyListeners();
    final url = Uri.parse(
        'https://onlineshop-df883-default-rtdb.firebaseio.com/products/$id.json');
    try {
      final response =
          await http.patch(url, body: jsonEncode({'isFavorite': isFavorite}));
      if (response.statusCode >= 400) {
        _setFavValue(oldStatus);
      }
    } catch (error) {
      _setFavValue(oldStatus);
    }
  }
}

class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //     id: 'p1',
    //     title: 'Red Shirt',
    //     description: 'A red shirt - it is pretty red!',
    //     price: 29.99,
    //     imageUrl: 'https://www.babyshop.com/images/978457/card_xlarge.jpg'),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  List<Product> get items => _items;

  List<Product> get favItems {
    return _items.where((element) => element.isFavorite).toList();
  }

  Future<void> removeProduct(String productId) async {
    final url = Uri.parse(
        'https://onlineshop-df883-default-rtdb.firebaseio.com/products/$productId.json');

    final existingProductIndex =
        _items.indexWhere((element) => element.id == productId);
    var existingProduct = _items[existingProductIndex];
    _items.removeWhere((element) => element.id == productId);
    notifyListeners();
    final response = await http.delete(url).then((response) {
      if (response.statusCode >= 400) {
        _items.insert(existingProductIndex, existingProduct);
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
        // TODO FIGURE OUT UNHANDLED EXCEPTION AND TRY NULL SAFETY (existingProduct = null)

      }
    });
  }

  Future<void> fetchAndSetProducts() async {
    final url = Uri.parse(AppConstants.productsUrl);
    try {
      final response = await http.get(url);

      final List<Product> loadedProducts = [];
      final extractedData = jsonDecode(response.body) as Map<String, dynamic>;
      if (extractedData.isEmpty) {
        return;
      }
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Product(
            id: prodId,
            title: prodData['title'],
            description: prodData['description'],
            price: prodData['price'],
            imageUrl: prodData['imageUrl'],
            isFavorite: prodData['isFavorite']));
        _items = loadedProducts;
        notifyListeners();
      });
    } catch (error) {
      print(error);
      rethrow;
    }
  }

  Future<void> addProduct(Product product) async {
    final url = Uri.parse(AppConstants.productsUrl);
    try {
      final response = await http.post(
        url,
        body: jsonEncode(
          {
            'title': product.title,
            'price': product.price,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'isFavorite': product.isFavorite
          },
        ),
      );

      final newProduct = Product(
          id: jsonDecode(response.body)['name'],
          title: product.title,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl);
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      print(error.toString());
      rethrow;
    }
  }

  Future<void> updateProduct(String productId, Product newProduct) async {
    var prodIndx = _items.indexWhere((element) => element.id == productId);
    if (prodIndx >= 0) {
      final url = Uri.parse(
          'https://onlineshop-df883-default-rtdb.firebaseio.com/products/$productId.json');
      try {
        final response = await http.patch(url,
            body: jsonEncode({
              'title': newProduct.title,
              'price': newProduct.price,
              'description': newProduct.description,
              'imageUrl': newProduct.imageUrl
            }));
        if (response.statusCode >= 400) {
          Get.snackbar(
            'Error',
            'Could not edit a product!',
            backgroundColor: AppColors.yelowColor,
            colorText: Colors.white,
            duration: const Duration(seconds: 2),
            snackPosition: SnackPosition.BOTTOM,
            dismissDirection: DismissDirection.horizontal,
          );
        } else {
          Get.snackbar('Success', 'Product updated!',
              backgroundColor: AppColors.yelowColor,
              colorText: Colors.white,
              duration: const Duration(seconds: 2),
              snackPosition: SnackPosition.BOTTOM,
              icon: const Icon(
                Icons.done,
                color: Colors.white,
              ),
              shouldIconPulse: true,
              dismissDirection: DismissDirection.horizontal);
        }
        _items[prodIndx] = newProduct;
        notifyListeners();
      } catch (error) {
        print(error.toString());
        rethrow;
      }
    }
  }
}
