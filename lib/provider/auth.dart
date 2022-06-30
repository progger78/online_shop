import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:online_shop/models/http_exception.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  String? _userid;
  Timer? _authTime;

  bool get isAuth {
    return token != null;
  }

  String? get userId => _userid;
  String? get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token!;
    }
    return null;
  }

  Future<void> _authenticate(
      String? email, String? password, String? urlSegment) async {
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyB-o02dwnztrbAj586UFi2f-xwgjA-WDyM');

    try {
      final response = await http.post(
        url,
        body: jsonEncode(
          {
            'password': password,
            'email': email,
            'returnSecureToken': true,
          },
        ),
      );

      final responseData = jsonDecode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(message: responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userid = responseData['localId'];
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'])));
      _autoLogOut();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = jsonEncode(
          {'token': _token, 'userId': _userid, 'expiryDate': _expiryDate!.toIso8601String()});
          prefs.setString('userData', userData);
          
    } catch (error) {
      rethrow;
    }
  }

  Future<void> signUp(String? email, String? password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> signIn(String? email, String? password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if(!prefs.containsKey('userData')){
      return false;
    }
    final extractedData = jsonDecode(prefs.getString('userData')!);
    final expiryDate = DateTime.parse(extractedData['expiryDate']);
    if(expiryDate.isBefore(DateTime.now())){
      return false;
    }
    _token = extractedData['token'];
    _userid = extractedData['userId'];
    _expiryDate = expiryDate;

    notifyListeners();
    _autoLogOut();
    return true;
  }

  Future<void> logOut()  async {
    _expiryDate = null;
    _token = null;
    _userid = null;
    if (_authTime != null) {
      _authTime!.cancel();
      _authTime = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();

  }

  void _autoLogOut() {
    if (_authTime != null) {
      _authTime!.cancel();
    }
    final timeToExpiry = _expiryDate!.difference(DateTime.now()).inSeconds;
    _authTime = Timer(Duration(seconds: timeToExpiry), logOut);
  }
  
}
