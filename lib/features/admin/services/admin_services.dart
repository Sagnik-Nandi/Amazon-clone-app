import 'dart:convert';
import 'dart:io';

import 'package:amazon_clone/constants/error_handling.dart';
import 'package:amazon_clone/constants/global_var.dart';
import 'package:amazon_clone/constants/utils.dart';
import 'package:amazon_clone/features/admin/models/sales.dart';
import 'package:amazon_clone/models/order.dart';
import 'package:amazon_clone/models/product.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class AdminServices{
  void sellProduct({
    required BuildContext context,
    required String name,
    required String description,
    required num price,
    required num quantity,
    required String category,
    required List<File> images,
  }) async {
    final token = Provider.of<UserProvider>(context, listen: false).user.token;

    try {
      // Cloudinary stores the images
      // mongodb stores only the image urls

      final cloudinary = CloudinaryPublic('dkdwpotx5', 'unpxckbx');
      List<String> imageUrls=[];

      for (int i=0; i<images.length; i++){
        CloudinaryResponse res = await cloudinary.uploadFile(CloudinaryFile.fromFile(images[i].path, folder: name));
        imageUrls.add(res.secureUrl);
      }

      Product product= Product(
        name: name, 
        description: description, 
        price: price, 
        quantity: quantity, 
        category: category, 
        images: imageUrls, 
      );

      http.Response res = await http.post(
        Uri.parse('$uri/admin/add-product'), 
        body:product.toJson(),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token,
        }
      );
      //error handling for the response which does not get caught in the catch block
      httpErrorHandler(response: res, context: context, onSuccess: (){
        showSnackBar(context, "Product added successfully");
        Navigator.pop(context);
        // back to products page
      });
      
    } catch (err) {
      showSnackBar(context, err.toString());
    }
  }

  //Change product details
  void editProduct({
    required BuildContext context,
    required String name,
    required String description,
    required num price,
    required num quantity,
    required String category,
    required dynamic id,
    required List<dynamic> prevImages,
    List<File>? images,
  }) async {
    final token = Provider.of<UserProvider>(context, listen: false).user.token;

    try {
      // Cloudinary stores the images
      // mongodb stores only the image urls

      final cloudinary = CloudinaryPublic('dkdwpotx5', 'unpxckbx');
      List<dynamic> imageUrls=prevImages;

      if(images!=null){
        for (int i=0; i<images.length; i++){
          CloudinaryResponse res = await cloudinary.uploadFile(CloudinaryFile.fromFile(images[i].path, folder: name));
          imageUrls.add(res.secureUrl);
        }
      }

      http.Response res = await http.post(
        Uri.parse('$uri/admin/edit-product'), 
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token,
        },
        body:jsonEncode({
          'name': name,
          'description':description,
          'price': price,
          'quantity': quantity,
          'category': category,
          'images': imageUrls,
          'id': id,
        }),
      );
      //error handling for the response which does not get caught in the catch block
      httpErrorHandler(response: res, context: context, onSuccess: (){
        showSnackBar(context, "Product updated successfully");
        Navigator.pop(context);
        // back to products page
      });
      
    } catch (err) {
      showSnackBar(context, err.toString());
    }
  }

  //Get all products
  Future<List<Product>> getProducts(BuildContext context) async{
    final token = Provider.of<UserProvider>(context, listen: false).user.token;
    List<Product> products=[];

    try {
      http.Response res = await http.get(
        Uri.parse('$uri/admin/get-products'), 
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

  //Delete product
  void deleteProduct({
    required BuildContext context, 
    required Product product,
    required VoidCallback onSuccess,
  }) async{
    final token = Provider.of<UserProvider>(context, listen: false).user.token;

    try {
      http.Response res = await http.post(
        Uri.parse('$uri/admin/remove-product'), 
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token,
        },
        body: jsonEncode({'id': product.id}),
      );

      httpErrorHandler(response: res, context: context, onSuccess: onSuccess);

    } catch (err) {
      showSnackBar(context, err.toString());
    }
  }

  //Get all orders
  Future<List<Order>> getOrders(BuildContext context) async{
    final token = Provider.of<UserProvider>(context, listen: false).user.token;
    List<Order> orders=[];

    try {
      http.Response res = await http.get(
        Uri.parse('$uri/admin/get-orders'), 
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token,
        }
      );

      httpErrorHandler(response: res, context: context, onSuccess: (){
        for (int i=0; i<jsonDecode(res.body).length; i++){
          //jsondecode gives back a list
          orders.add(
            Order.fromJson(jsonEncode(jsonDecode(res.body)[i]))
          );
        }
      });

    } catch (err) {
      showSnackBar(context, err.toString());
    }
    return orders;
  }

  void updateOrderStatus({
    required BuildContext context,
    required num currentState,
    required Order order,
    required VoidCallback onSuccess,
  }) async{
    final token = Provider.of<UserProvider>(context, listen: false).user.token;
    
    try {
      http.Response res = await http.post(
        Uri.parse('$uri/admin/update-order-status'),
        headers:  <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token,
        },
        body: jsonEncode({
          'id': order.id
        })
      );

      httpErrorHandler(
        response: res, 
        context: context, 
        onSuccess: onSuccess
      );
    } catch (err) {
      showSnackBar(context, err.toString());
    }
  }

  Future<Map<String, dynamic>> getEarnings(BuildContext context) async{
    final token = Provider.of<UserProvider>(context, listen: false).user.token;
    List<Sales> sales=[];
    int totalEarnings=0;

    try {
      http.Response res = await http.get(
        Uri.parse('$uri/admin/analytics'), 
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token,
        }
      );
      httpErrorHandler(
        response: res, 
        context: context, 
        onSuccess: () {
          var data = jsonDecode(res.body);
          totalEarnings = data['totalEarnings'];
          sales = [
            Sales('Mobiles', data['mobileEarnings']),
            Sales('Essentials', data['essentialEarnings']),
            Sales('Appliances', data['applianceEarnings']),
            Sales('Books', data['bookEarnings']),
            Sales('Fashions', data['fashionEarnings']),
          ];
        }
      );

    } catch (err) {
      showSnackBar(context, err.toString());
    }

    return{
      'totalEarnings': totalEarnings,
      'sales': sales,
    };
  }
}