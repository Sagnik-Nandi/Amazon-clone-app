import 'dart:convert';

import 'package:amazon_clone/constants/error_handling.dart';
import 'package:amazon_clone/constants/global_var.dart';
import 'package:amazon_clone/constants/utils.dart';
import 'package:amazon_clone/models/order.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class AccountServices{
  Future<List<Order>> fetchOrderDetails({
    required BuildContext context,
  }) async {
    final String token = Provider.of<UserProvider>(context, listen: false).user.token;
    List<Order> orderList=[];

    try {
      http.Response res = await http.get(
        Uri.parse("$uri/api/fetch-orders"),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token
        },
      );
      
      httpErrorHandler(
        response: res, 
        context: context, 
        onSuccess: (){
          for(int i=0; i<jsonDecode(res.body).length; i++){
            orderList.add(
              Order.fromJson(
                jsonEncode(jsonDecode(res.body)[i])
              )
            );
          }
        });
    } catch (err) {
      showSnackBar(context, err.toString());
    }
    return orderList;
  }
}