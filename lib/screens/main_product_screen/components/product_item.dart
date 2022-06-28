import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:online_shop/provider/cart.dart';

import 'package:online_shop/routes/route_helper.dart';
import 'package:provider/provider.dart';

import '../../../provider/products.dart';
import '../../../utils/utils.dart';
import '../../../widgets/app_small_text.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({
    Key? key,
    required this.index,
  }) : super(key: key);

  final int index;

  @override
  Widget build(BuildContext context) {
    var product = Provider.of<Product>(context, listen: false);
    var cart = Provider.of<Cart>(context);
    return GridTile(
      footer: Container(
        height: Dimensions.height55,
        width: double.maxFinite,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(Dimensions.radius15),
              bottomRight: Radius.circular(Dimensions.radius15),
            ),
            color: Colors.black54),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Consumer<Product>(
              builder: (context, product, _) => IconButton(
                  onPressed: () => product.toggleFavorite(),
                  icon: Icon(product.isFavorite
                      ? Icons.favorite
                      : Icons.favorite_outline),
                  color: AppColors.yelowColor),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.center,
                child: AppSmallText(
                  text: product.title,
                  color: Colors.white,
                  size: Dimensions.font22 - 4,
                ),
              ),
            ),
            (IconButton(
              onPressed: () {
                cart.addItem(
                  product.title,
                  product.price,
                  product.id!,
                  product.imageUrl,
                );
              },
              icon: const Icon(
                Icons.shopping_cart_outlined,
                color: AppColors.yelowColor,
              ),
            ))
          ],
        ),
      ),
      child: GestureDetector(
        onTap: () {
          Get.toNamed(RouteHelper.getDetailProductScreen(index));
        },
        child: ClipRRect(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(Dimensions.radius15),
              bottomRight: Radius.circular(Dimensions.radius15)),
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
