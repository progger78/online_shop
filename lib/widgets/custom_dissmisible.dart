import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/orders.dart';
import '../utils/utils.dart';
import 'app_big_text.dart';
import 'app_small_text.dart';

class CustomDismissible extends StatelessWidget {
  const CustomDismissible({
    Key? key,
    required this.isExpanded,
    required this.index,
    required this.orderInfo,
    required this.child,
  }) : super(key: key);

  final bool isExpanded;
  final int index;
  final Order orderInfo;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
        key: ValueKey(orderInfo.orders.toList()[index].id),
        direction: DismissDirection.endToStart,
        confirmDismiss: (direction) {
          return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              content: const AppSmallText(
                text: 'Do you want to delete the order?',
                color: Colors.black,
              ),
              title: AppBigText(
                text: 'Are you sure?',
                color: Colors.black,
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop(true);
                  },
                  child: const AppSmallText(
                    text: 'Yes',
                    color: Colors.red,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop(false);
                  },
                  child: const AppSmallText(
                    text: 'No',
                    color: AppColors.mainColor,
                  ),
                ),
              ],
            ),
          );
        },
        background: Container(
          color: Colors.red,
          alignment: Alignment.centerRight,
          padding: EdgeInsets.only(right: Dimensions.width45 - 10),
          child: Icon(
            Icons.delete,
            size: Dimensions.height45,
            color: Colors.white,
          ),
        ),
        onDismissed: (direction) async {
          await Provider.of<Order>(context, listen: false)
              .deleteOrder(orderInfo.orders[index].id);
        },
        child: child);
  }
}
