import 'package:flutter/material.dart';


import '../../../utils/utils.dart';
import '../../../widgets/widgets.dart';

class OrdersAppBar extends StatelessWidget {
  const OrdersAppBar({
    Key? key,
    required GlobalKey<ScaffoldState> scaffoldState,
  }) : _scaffoldState = scaffoldState, super(key: key);

  final GlobalKey<ScaffoldState> _scaffoldState;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      child: Container(
        width: double.maxFinite,
        height: Dimensions.height55 * 2,
        color: AppColors.mainColor,
        child: Padding(
          padding: EdgeInsets.only(
              left: Dimensions.width15,
              top: Dimensions.height25 + 5,
              right: Dimensions.width15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  _scaffoldState.currentState!.openDrawer();
                },
                icon: Icon(
                  Icons.menu,
                  color: Colors.white,
                  size: Dimensions.height45 - 10,
                ),
              ),
              AppBigText(
                  text: 'Your Orders',
                  color: Colors.white,
                  size: Dimensions.font26)
            ],
          ),
        ),
      ),
    );
  }
}
