import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/routes/route_helper.dart';

import 'package:online_shop/utils/utils.dart';
import '/widgets/203%20badge.dart';
import '/widgets/app_big_text.dart';
import '/widgets/main_drawer.dart';
import 'package:provider/provider.dart';

import '../../provider/cart.dart';
import '../../provider/products.dart';
import 'components/product_item.dart';

enum FilterOptions { All, Favotites }

class MainProductScreen extends StatefulWidget {
  const MainProductScreen({Key? key}) : super(key: key);

  @override
  State<MainProductScreen> createState() => _MainProductScreenState();
}

class _MainProductScreenState extends State<MainProductScreen> {
  var _isLoading = false;
  var _showFavs = false;
  var _isInit = true;

  // @override
  // void initState() {
  //   _isLoading = true;
  //   Future.delayed(Duration.zero).then((value) {
  //     Provider.of<Products>(context, listen: false).fetchAndSetProducts();
  //     _isLoading = false;
  //   });
  //   super.initState();
  // }
  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });

      Provider.of<Products>(context).fetchAndSetProducts().then((value) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    var prodData = Provider.of<Products>(context);
    var product = _showFavs ? prodData.favItems : prodData.items;
    return Scaffold(
      key: _scaffoldState,
      appBar: AppBar(
        
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.mainColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => _scaffoldState.currentState!.openDrawer(),
        ),
        actions: [
          PopupMenuButton(
            onSelected: (value) {
              setState(() {
                if (value == FilterOptions.Favotites) {
                  _showFavs = true;
                } else {
                  _showFavs = false;
                }
              });
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                  value: FilterOptions.All,
                  child: AppBigText(text: 'Show All', color: AppColors.mainColor,)),
              PopupMenuItem(
                  value: FilterOptions.Favotites,
                  child: AppBigText(text: 'Show Favorite', color: AppColors.mainColor,)),
            ],
          ),
          Consumer<Cart>(
            child: IconButton(
                onPressed: () {
                  Get.toNamed(RouteHelper.getCartScreen());
                },
                icon: const Icon(Icons.shopping_cart_outlined)),
            builder: (context, cartData, ch) {
              return cartData.cartItem.isNotEmpty
                  ? Badge(
                      color: AppColors.yelowColor,
                      value: cartData.itemsAmount.toString(),
                      child: ch!,
                    )
                  : IconButton(
                      icon: const Icon(Icons.shopping_cart_outlined),
                      onPressed: () {
                        Get.toNamed(RouteHelper.getCartScreen());
                      },
                    );
            },
          )
        ],
        title: AppBigText(
          text: 'Shopy',
          color: Colors.white,
          size: Dimensions.font26,
        ),
        centerTitle: false,
      ),
      drawer: const AppDrawer(),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: AppColors.mainColor,
                backgroundColor: AppColors.yelowColor,
              ),
            )
          : GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  // childAspectRatio: 3 / 2,
                  mainAxisSpacing: Dimensions.height10,
                  crossAxisSpacing: Dimensions.width10),
              itemCount: product.length,
              itemBuilder: (BuildContext context, int index) {
                return ChangeNotifierProvider.value(
                  value: product[index],
                  child: ProductItem(
                    index: index,
                  ),
                );
              },
            ),
    );
  }
}
