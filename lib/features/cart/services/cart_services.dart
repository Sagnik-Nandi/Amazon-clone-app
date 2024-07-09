import 'dart:convert';

import 'package:amazon_clone/constants/error_handling.dart';
import 'package:amazon_clone/constants/global_var.dart';
import 'package:amazon_clone/constants/utils.dart';
import 'package:amazon_clone/models/product.dart';
import 'package:amazon_clone/models/user.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class CartServices{
  void removeFromCart({
    required BuildContext context,
    required Product product,
  }) async {
    User user= Provider.of<UserProvider>(context, listen: false).user;

    try {
      http.Response res = await http.delete(
        Uri.parse('$uri/api/remove-from-cart'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': user.token
        },
        body: jsonEncode({
          'id':product.id,
        }),
      );

      httpErrorHandler(
        response: res, 
        context: context, 
        onSuccess: (){
          user= user.copyWith(
            cart: jsonDecode(res.body)['cart']
          );
          Provider.of<UserProvider>(context, listen: false).setUserFromModel(user);
        });
    } catch (err) {
      showSnackBar(context, err.toString());
    }
    
  }
}