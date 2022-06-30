import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/provider/auth.dart';
import '/routes/route_helper.dart';
import '/utils/utils.dart';
import '/widgets/app_big_text.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          padding: EdgeInsets.only(
              left: Dimensions.width15, top: Dimensions.height20),
          alignment: Alignment.centerLeft,
          height: Dimensions.height55 * 2,
          width: double.infinity,
          color: AppColors.mainColor,
          child: AppBigText(
            text: 'Your Shoppy',
            size: Dimensions.font30,
            color: Colors.white,
          ),
        ),
        MyListTile(
          icon: Icons.home_outlined,
          text: 'Main Shop',
          onPressed: () {
            Get.offAndToNamed(RouteHelper.getInitial());
          },
        ),
        const Divider(
          thickness: 1,
        ),
        MyListTile(
          icon: Icons.history,
          text: 'Orders History',
          onPressed: () => Get.offAndToNamed(RouteHelper.getOrdersScreen()),
        ),
        const Divider(
          thickness: 1,
        ),
        MyListTile(
            icon: Icons.shopping_cart_outlined,
            text: 'Shoping Cart',
            onPressed: () => Get.offAndToNamed(RouteHelper.getCartScreen())),
        const Divider(
          thickness: 1,
        ),
        MyListTile(
            icon: Icons.list,
            text: 'Your Products',
            onPressed: () =>
                Get.offAndToNamed(RouteHelper.getUserProductScreen())),
        MyListTile(
            icon: Icons.exit_to_app_outlined,
            text: 'Log Out',
            onPressed: () {
              Navigator.of(context).pop();
              Get.offAndToNamed(RouteHelper.getInitial());
              Provider.of<Auth>(context, listen: false).logOut();
            })
      ]),
    );
  }
}

class MyListTile extends StatelessWidget {
  const MyListTile({
    Key? key,
    required this.icon,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  final IconData icon;
  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
      ),
      title: AppBigText(
        text: text,
        color: AppColors.mainColor,
      ),
      onTap: onPressed,
    );
  }
}
