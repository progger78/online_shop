import 'package:flutter/material.dart';
import 'package:online_shop/widgets/app_small_text.dart';

import '../../../utils/utils.dart';

class CustomTextField extends StatelessWidget {
  CustomTextField({
    Key? key,
    required this.label,
    this.textInputAction,
    this.keyboardType,
    this.focusNode,
    this.onFieldSubmitted,
    this.maxLines,
    this.controller,
    this.onSaved,
    this.validator,
    this.initialValue,
  }) : super(key: key);

  final String label;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final FocusNode? focusNode;
  final Function(String)? onFieldSubmitted;
  final Function(String?)? onSaved;
  final int? maxLines;
  final TextEditingController? controller;
  String? Function(String? val)? validator;
  final String? initialValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: Dimensions.width15),
      margin: EdgeInsets.symmetric(
          horizontal: Dimensions.width15, vertical: Dimensions.height10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            Dimensions.radius20,
          ),
          color: Colors.white),
      child: TextFormField(
        
        maxLines: maxLines,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        decoration: InputDecoration(
          labelStyle: TextStyle(color: Colors.black.withOpacity(0.6)),
          errorBorder: InputBorder.none,
          focusedErrorBorder: InputBorder.none,
          errorStyle: TextStyle(fontWeight: FontWeight.w400, ),
          label: Text(label),
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          hintStyle: const TextStyle(color: AppColors.mainColor),
        ),
        focusNode: focusNode,
        onFieldSubmitted: onFieldSubmitted,
        controller: controller,
        onSaved: onSaved,
        validator: validator,
        initialValue: initialValue,
      ),
    );
  }
}
