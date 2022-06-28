import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:online_shop/routes/route_helper.dart';

import 'package:online_shop/utils/utils.dart';
import 'package:online_shop/widgets/app_big_text.dart';
import 'package:online_shop/widgets/app_small_text.dart';
import 'package:provider/provider.dart';

import '../../provider/products.dart';
import '../../widgets/custom_alert_dialog.dart';
import 'components/custom_text_field.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({Key? key, this.pageId}) : super(key: key);

  final int? pageId;

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imgUrlFocusNode = FocusNode();
  final _imgUrlController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var _isLoading = false;
  var _editedProduct = Product(
      id: null,
      price: 0,
      imageUrl: '',
      description: '',
      title: '',
      isFavorite: false);
  var _isInit = true;
  var _initValues = {
    'title': '',
    'price': '',
    'description': '',
    'imageUrl': ''
  };
  @override
  void initState() {
    _imgUrlFocusNode.addListener(_updateState);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit && widget.pageId != null) {
      _editedProduct =
          Provider.of<Products>(context, listen: false).items[widget.pageId!];
      _initValues = {
        'title': _editedProduct.title,
        'price': _editedProduct.price.toString(),
        'description': _editedProduct.description,
        'imageUrl': ''
      };
      _imgUrlController.text = _editedProduct.imageUrl;
    }
    _isInit = false;

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imgUrlFocusNode.removeListener(_updateState);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imgUrlFocusNode.dispose();
    _imgUrlController.dispose();
    super.dispose();
  }

  void _updateState() {
    if (!_imgUrlFocusNode.hasFocus) {
      if (!_imgUrlController.text.startsWith('http') &&
              !_imgUrlController.text.startsWith('https') ||
          !_imgUrlController.text.endsWith('.png') &&
              !_imgUrlController.text.endsWith('.jpg') &&
              !_imgUrlController.text.endsWith('.jpeg')) {
        return;
      }

      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    var isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    if (_editedProduct.id != null) {
      try {
        await Provider.of<Products>(context, listen: false)
            .updateProduct(_editedProduct.id!, _editedProduct);
      } catch (error) {
        await showDialog<void>(
          context: context,
          builder: (ctx) => CustomAlertDialog(
            context: ctx,
            content: 'Could not update information...',
          ),
        );
      }
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editedProduct);
      } catch (error) {
        await showDialog<void>(
          context: context,
          builder: (ctx) => CustomAlertDialog(
            context: ctx,
            content: 'Could not add new product...',
          ),
        );
      }
    }
    setState(
      () {
        _isLoading = false;
        Get.offAndToNamed(RouteHelper.userProductScreen);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.mainColor,
        title: AppBigText(
          text: 'Edit Product',
          size: Dimensions.font26,
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: AppColors.mainColor,
                backgroundColor: AppColors.yelowColor,
              ),
            )
          : Form(
              key: _formKey,
              child: ListView(
                children: [
                  CustomTextField(
                    initialValue: _initValues['title'],
                    label: 'Title',
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) =>
                        FocusScope.of(context).requestFocus(_priceFocusNode),
                    onSaved: (value) {
                      _editedProduct = Product(
                          id: _editedProduct.id,
                          title: value!,
                          description: _editedProduct.description,
                          price: _editedProduct.price,
                          imageUrl: _editedProduct.imageUrl,
                          isFavorite: _editedProduct.isFavorite);
                    },
                    validator: (value) {
                      if (value != null && value.isEmpty) {
                        return 'Title should not be empty';
                      }
                      return null;
                    },
                  ),
                  CustomTextField(
                    initialValue: _initValues['price'],
                    label: 'Price',
                    textInputAction: TextInputAction.next,
                    focusNode: _priceFocusNode,
                    keyboardType: const TextInputType.numberWithOptions(
                        signed: true, decimal: true),
                    onFieldSubmitted: (_) => FocusScope.of(context)
                        .requestFocus(_descriptionFocusNode),
                    onSaved: (value) {
                      _editedProduct = Product(
                          id: _editedProduct.id,
                          title: _editedProduct.title,
                          description: _editedProduct.description,
                          price: double.parse(value!),
                          imageUrl: _editedProduct.imageUrl,
                          isFavorite: _editedProduct.isFavorite);
                    },
                    validator: (value) {
                      if (value != null && value.isEmpty) {
                        return 'Price should not be empty';
                      }
                      if (value != null && double.tryParse(value) == null) {
                        return 'Please, input a valid number';
                      }
                      if (value != null && double.parse(value) <= 0) {
                        return 'Price should be more than 0';
                      }

                      return null;
                    },
                  ),
                  CustomTextField(
                    initialValue: _initValues['description'],
                    maxLines: 3,
                    label: 'Description',
                    keyboardType: TextInputType.multiline,
                    focusNode: _descriptionFocusNode,
                    onSaved: (value) {
                      _editedProduct = Product(
                          id: _editedProduct.id,
                          title: _editedProduct.title,
                          description: value!,
                          price: _editedProduct.price,
                          imageUrl: _editedProduct.imageUrl,
                          isFavorite: _editedProduct.isFavorite);
                    },
                    validator: (value) {
                      if (value != null && value.isEmpty) {
                        return 'Description should not be empty';
                      }
                      if (value != null && value.length < 10) {
                        return 'Description should be 20 characters at least';
                      }
                      return null;
                    },
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(
                            left: Dimensions.width15,
                            top: Dimensions.height5,
                            bottom: Dimensions.height5),
                        height: Dimensions.height45 * 3,
                        width: Dimensions.width45 * 3,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(
                              Dimensions.width20,
                            ),
                            image: _imgUrlController.text.isEmpty
                                ? const DecorationImage(
                                    image: AssetImage(
                                        'assets/images/placeholder.png'),
                                    fit: BoxFit.cover)
                                : DecorationImage(
                                    image: NetworkImage(_imgUrlController.text),
                                    fit: BoxFit.cover)),
                      ),
                      Expanded(
                        child: CustomTextField(
                          label: 'Image URL',
                          focusNode: _imgUrlFocusNode,
                          keyboardType: TextInputType.url,
                          controller: _imgUrlController,
                          onFieldSubmitted: (_) => _saveForm(),
                          onSaved: (value) {
                            _editedProduct = Product(
                                id: _editedProduct.id,
                                title: _editedProduct.title,
                                description: _editedProduct.description,
                                price: _editedProduct.price,
                                imageUrl: value!,
                                isFavorite: _editedProduct.isFavorite);
                          },
                          validator: (value) {
                            if (value != null && value.isEmpty) {
                              return 'Image URL should not be empty';
                            }
                            if (value != null &&
                                    !value.startsWith('http') &&
                                    !value.startsWith('https') ||
                                value != null &&
                                    !value.endsWith('.png') &&
                                    !value.endsWith('.jpg') &&
                                    !value.endsWith('.jpeg')) {
                              return 'Please input correct image URL';
                            }
                            return null;
                          },
                        ),
                      )
                    ],
                  ),
                  TextButton(
                    onPressed: _saveForm,
                    child: AppSmallText(
                      text: 'Save Product',
                      size: Dimensions.font22,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
