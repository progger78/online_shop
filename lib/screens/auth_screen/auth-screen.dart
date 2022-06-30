import 'package:flutter/material.dart';
import 'package:online_shop/models/http_exception.dart';
import 'package:online_shop/provider/auth.dart';

import 'package:online_shop/utils/utils.dart';
import 'package:online_shop/widgets/app_big_text.dart';
import 'package:online_shop/widgets/custom_alert_dialog.dart';
import 'package:provider/provider.dart';

enum AuthMode { Signup, Login }

class AuthScreen extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    // final transformConfig = Matrix4.rotationZ(-8 * pi / 180);
    // transformConfig.translate(-10.0);
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color.fromARGB(255, 145, 237, 255).withOpacity(0.5),
                  const Color.fromRGBO(255, 188, 117, 1).withOpacity(0.9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: const [0, 1],
              ),
            ),
          ),
          SingleChildScrollView(
            child: SizedBox(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    child: Container(
                        margin: EdgeInsets.only(bottom: Dimensions.height20),
                        padding: EdgeInsets.symmetric(
                            vertical: Dimensions.height10 - 2,
                            horizontal: Dimensions.height70 + 5),
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(Dimensions.radius20),
                          color: AppColors.mainColor,
                          boxShadow: const [
                            BoxShadow(
                              blurRadius: 8,
                              color: Colors.black26,
                              offset: Offset(0, 2),
                            )
                          ],
                        ),
                        child: AppBigText(
                          text: 'Your Shop',
                          size: Dimensions.font26,
                        )),
                  ),
                  Flexible(
                    flex: deviceSize.width > 600 ? 2 : 1,
                    child: const AuthCard(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({
    Key? key,
  }) : super(key: key);

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  final Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  var _isLoading = false;
  final _passwordController = TextEditingController();

  void _showErrorDialog(String errorMessage) {
    showDialog(
        context: context,
        builder: (ctx) => CustomAlertDialog(
              context: ctx,
              title: 'Could not authenticate you',
              content: errorMessage,
            ));
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (_authMode == AuthMode.Login) {
        await Provider.of<Auth>(context, listen: false)
            .signIn(_authData['email'], _authData['password']);
      } else {
        await Provider.of<Auth>(context, listen: false)
            .signUp(_authData['email'], _authData['password']);
      }
    } on HttpException catch (error) {
      var errorMessage = 'Authentication failed...';
      switch (error.toString()) {
        case 'EMAIL_EXISTS':
          errorMessage = 'Email is alredy exists.';
          break;
        case 'INVALID_EMAIL':
          errorMessage = 'Email is invalid.';
          break;
        case 'USER_NOT_FOUND':
          errorMessage = 'User not found.';
          break;
        case 'EMAIL_NOT_FOUND':
          errorMessage = 'Email not found.';
          break;
        case 'WEAK_PASSWORD':
          errorMessage = 'Weak Password, try another one.';
          break;
        case 'INVALID_PASSWORD':
          errorMessage = 'Invalid password, try again.';
          break;
      }
      _showErrorDialog(errorMessage);
    } catch (error) {
      const errorMessage = 'Could not authenticate you, please try later';
      _showErrorDialog(errorMessage);
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimensions.radius15 - 5),
      ),
      elevation: 8.0,
      child: Container(
        height: _authMode == AuthMode.Signup ? 320 : 260,
        constraints:
            BoxConstraints(minHeight: _authMode == AuthMode.Signup ? 320 : 260),
        width: deviceSize.width * 0.75,
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  cursorColor: AppColors.mainColor,
                  decoration: const InputDecoration(
                    labelText: 'E-Mail',
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: AppColors.mainColor)),
                    enabledBorder: InputBorder.none,
                    hintStyle: TextStyle(color: Colors.black54),
                    labelStyle: TextStyle(
                      color: Colors.black45,
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || !value.contains('@')) {
                      return 'Invalid email!';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authData['email'] = value!;
                  },
                ),
                TextFormField(
                  cursorColor: AppColors.mainColor,
                  style: const TextStyle(color: Colors.black),
                  decoration: const InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: AppColors.mainColor)),
                    enabledBorder: InputBorder.none,
                    hintStyle: TextStyle(color: Colors.black54),
                    labelStyle: TextStyle(
                      color: Colors.black45,
                    ),
                    labelText: 'Password',
                  ),
                  obscureText: true,
                  controller: _passwordController,
                  validator: (value) {
                    if (value == null || value.length < 5) {
                      return 'Password is too short!';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authData['password'] = value!;
                  },
                ),
                if (_authMode == AuthMode.Signup)
                  TextFormField(
                    cursorColor: AppColors.mainColor,
                    enabled: _authMode == AuthMode.Signup,
                    decoration: const InputDecoration(
                      labelText: 'Confirm Password',
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.mainColor)),
                      enabledBorder: InputBorder.none,
                      hintStyle: TextStyle(color: Colors.black54),
                      labelStyle: TextStyle(
                        color: Colors.black45,
                      ),
                    ),
                    obscureText: true,
                    validator: _authMode == AuthMode.Signup
                        ? (value) {
                            if (value != _passwordController.text) {
                              return 'Passwords do not match!';
                            }
                            return null;
                          }
                        : null,
                  ),
                SizedBox(
                  height: Dimensions.height20,
                ),
                if (_isLoading)
                  const CircularProgressIndicator()
                else
                  RaisedButton(
                    onPressed: _submit,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: EdgeInsets.symmetric(
                        horizontal: Dimensions.width25 + 5,
                        vertical: Dimensions.height10 - 2),
                    color: AppColors.mainColor,
                    textColor: Colors.white,
                    child:
                        Text(_authMode == AuthMode.Login ? 'LOGIN' : 'SIGN UP'),
                  ),
                FlatButton(
                  onPressed: _switchAuthMode,
                  padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.width25 + 5,
                      vertical: Dimensions.height5 - 1),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  textColor: Theme.of(context).primaryColor,
                  child: AppBigText(
                      size: Dimensions.font16,
                      text:
                          '${_authMode == AuthMode.Login ? 'SIGNUP' : 'LOGIN'} INSTEAD',
                      color: const Color.fromARGB(255, 191, 137, 0)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
