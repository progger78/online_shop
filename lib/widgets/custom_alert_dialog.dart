import 'package:flutter/material.dart';

import '../utils/dimensions.dart';
import 'app_big_text.dart';
import 'app_small_text.dart';

class CustomAlertDialog extends StatelessWidget {
  const CustomAlertDialog({
    Key? key, required this.context, required this.content,
  }) : super(key: key);

  final BuildContext context;
  
  final String content;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimensions.radius25)),
      title: const Text('Something happened :('),
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
