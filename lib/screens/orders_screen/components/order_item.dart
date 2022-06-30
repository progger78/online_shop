import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../provider/orders.dart';
import '../../../utils/utils.dart';
import '../../../widgets/widgets.dart';

class OrderItem extends StatelessWidget {
  const OrderItem({
    Key? key,

    required this.orderInfo,
    required this.index,
  }) : super(key: key);


  final Order orderInfo;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimensions.radius20),
      ),
      elevation: 3,
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              image: const DecorationImage(
                  image: AssetImage(
                    'assets/images/product-placeholder2.png',
                  ),
                  fit: BoxFit.cover),
              color: Colors.amber,
              borderRadius: BorderRadius.circular(
                Dimensions.radius20,
              ),
            ),
            width: Dimensions.width45 * 3,
          ),
          Padding(
            padding: EdgeInsets.only(
                left: Dimensions.width5, top: Dimensions.height10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppBigText(
                  fontWeight: FontWeight.bold,
                  text: '\$${orderInfo.orders[index].amount}',
                  color: Colors.black,
                ),
                AppBigText(
                  text:
                      'Number of items: ${orderInfo.orders[index].itemsAmount}',
                  color: Colors.black,
                ),
                Row(
                  children: [
                    AppBigText(
                      text: DateFormat.yMMMEd().format(
                        orderInfo.orders[index].orderTime,
                      ),
                      color: Colors.black,
                    ),
                    SizedBox(
                      width: Dimensions.width20,
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Row(
                        children: [
                          AppSmallText(
                              text: 'More',
                              color: AppColors.mainColor,
                              size: Dimensions.font22 - 4),
                          Padding(
                            padding:
                                EdgeInsets.only(top: Dimensions.height5 - 2),
                            child: const Icon(
                             Icons.expand_more,
                              color: AppColors.mainColor,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
