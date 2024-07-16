import 'dart:convert';

import 'package:amazon_clone/constants/error_handling.dart';
import 'package:amazon_clone/constants/global_var.dart';
import 'package:amazon_clone/constants/utils.dart';
import 'package:amazon_clone/models/user.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class AddressServices{
  void saveUserAddress({
    required BuildContext context,
    required String address,
  }) async{
    User user= Provider.of<UserProvider>(context, listen: false).user;

    try {
      http.Response res = await http.post(
        Uri.parse('$uri/api/save-address'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': user.token
        },
        body: jsonEncode({
          'address':address,
        }),
      );

      httpErrorHandler(
        response: res, 
        context: context, 
        onSuccess: (){
          user= user.copyWith(
            address: jsonDecode(res.body)['address']
          );
          Provider.of<UserProvider>(context, listen: false).setUserFromModel(user);
        });
    } catch (err) {
      showSnackBar(context, err.toString());
    }
  }

  void placeOrder({
    required BuildContext context,
    required String address,
    required double total
  }) async{
    User user= Provider.of<UserProvider>(context, listen: false).user;

    try {
      http.Response res = await http.post(
        Uri.parse('$uri/api/order-products'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': user.token
        },
        body: jsonEncode({
          'cart': user.cart,
          'address':address,
          'totalPrice': total
        }),
      );

      httpErrorHandler(
        response: res, 
        context: context, 
        onSuccess: (){
          showSnackBar(context, "Your order has been placed!");
          user= user.copyWith(
            cart: []
          );
          Provider.of<UserProvider>(context, listen: false).setUserFromModel(user);
        });
    } catch (err) {
      showSnackBar(context, err.toString());
    }
  }
}