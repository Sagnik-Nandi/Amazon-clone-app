import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'package:amazon_clone/constants/error_handling.dart';
import 'package:amazon_clone/constants/global_var.dart';
import 'package:amazon_clone/constants/utils.dart';
import 'package:amazon_clone/models/product.dart';
import 'package:amazon_clone/providers/user_provider.dart';

class SearchServices{
  Future<List<Product>> fetchSearchedProducts({
    required BuildContext context,
    required String searchQuery,
  }) async{
    final token = Provider.of<UserProvider>(context, listen: false).user.token;
    List<Product> products=[];

    try {
      http.Response res = await http.get(
        Uri.parse('$uri/api/products/search/$searchQuery'), 
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token,
        }
      );

      httpErrorHandler(response: res, context: context, onSuccess: (){
        for (int i=0; i<jsonDecode(res.body).length; i++){
          //jsondecode gives back a list
          products.add(
            Product.fromJson(jsonEncode(jsonDecode(res.body)[i]))
          );
        }
      });
      
    } catch (err) {
      showSnackBar(context, err.toString());
    }

    return products;
  }
}