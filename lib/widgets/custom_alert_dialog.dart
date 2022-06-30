import 'package:flutter/material.dart';

import '../utils/dimensions.dart';
import 'app_big_text.dart';
import 'app_small_text.dart';

class CustomAlertDialog extends StatelessWidget {
  const CustomAlertDialog({
    Key? key, required this.context, required this.content, this.title,
  }) : super(key: key);

  final BuildContext context;
  
  final String content;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimensions.radius25)),
      title:  Text(title ?? 'Something went wrong'),
      content: AppBigText(
        text: content,
        color: Colors.black,
      ),
      actions: [
        FlatButton(
          onPressed: () => Navigator.of(context).pop(),
          child: AppSmallText(
            text: 'Okay',
            color: Colors.red,
            size: Dimensions.font22,
          ),
        )
      ],
    );
  }
}
