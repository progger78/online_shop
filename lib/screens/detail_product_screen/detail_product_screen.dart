import 'package:flutter/material.dart';

import 'package:online_shop/provider/products.dart';
import 'package:online_shop/utils/configurations.dart';
import 'package:online_shop/widgets/app_big_text.dart';
import 'package:online_shop/widgets/app_small_text.dart';
import 'package:provider/provider.dart';

class DetailProductScreen extends StatelessWidget {
  const DetailProductScreen({
    Key? key,
    required this.pageId,
  }) : super(key: key);
  final int pageId;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    var product = Provider.of<Products>(context, listen: false).items[pageId];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.mainColor,
        elevation: 0,
        title: Text(product.title),
      ),
      body: Column(
        children: [
          SizedBox(
            height: size.height * 0.3,
            width: double.maxFinite,
            child: Image.network(
              product.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              AppBigText(
                text: product.title,
                color: AppColors.mainColor,
              ),
              AppBigText(
                text: product.price.toString(),
                color: AppColors.mainColor,
              ),
            ],
          ),
          AppSmallText(
            text: product.description,
            color: AppColors.mainColor,
          )
        ],
      ),
    );
  }
}
