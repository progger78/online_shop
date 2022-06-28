import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/provider/products.dart';
import '/routes/route_helper.dart';
import '/screens/edit_product_screen/edit_product_screen.dart';
import '/utils/utils.dart';
import '/widgets/app_big_text.dart';
import '/widgets/app_icon.dart';
import '/widgets/main_drawer.dart';
import 'package:provider/provider.dart';


class UserProductScreen extends StatelessWidget {
  UserProductScreen({Key? key}) : super(key: key);
  final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

  Future<void> refreshData(
    BuildContext context,
  ) async {
    await Provider.of<Products>(context, listen: false).fetchAndSetProducts();
  }

  @override
  Widget build(BuildContext context) {
    var productData = Provider.of<Products>(context);
    return Scaffold(
      key: _scaffoldState,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.mainColor,
        centerTitle: false,
        leading: IconButton(
          onPressed: () => _scaffoldState.currentState!.openDrawer(),
          icon: const Icon(
            Icons.menu,
            color: Colors.white,
          ),
        ),
        title: AppBigText(
          text: 'Your Products',
          color: Colors.white,
          size: Dimensions.font26,
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: Dimensions.width15),
            child: AppIcon(
              icon: Icons.add,
              iconColor: AppColors.mainColor,
              backgorundColor: Colors.white,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const EditProductScreen()),
                );
              },
            ),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: RefreshIndicator(
        color: AppColors.yelowColor,
        backgroundColor: AppColors.mainColor,
        onRefresh: () => refreshData(context),
        child: Padding(
          padding: EdgeInsets.only(top: Dimensions.height10),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              // childAspectRatio: 1,
            ),
            itemCount: productData.items.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: EdgeInsets.all(Dimensions.height5),
                child: Container(
                  padding: EdgeInsets.only(bottom: Dimensions.height15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.radius15),
                    color: Colors.red,
                    image: DecorationImage(
                        image: NetworkImage(
                          productData.items[index].imageUrl,
                        ),
                        fit: BoxFit.cover),
                  ),
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      AppIcon(
                          onPressed: () {
                            Get.toNamed(
                                RouteHelper.getEditProductScreen(index));
                          },
                          icon: Icons.edit,
                          iconColor: Colors.white,
                          backgorundColor: AppColors.mainColor),
                      AppIcon(
                          onPressed: () {
                            Provider.of<Products>(context, listen: false)
                                .removeProduct(productData.items[index].id!);
                          },
                          icon: Icons.delete,
                          iconColor: Colors.white,
                          backgorundColor: AppColors.yelowColor)
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
