import 'dart:convert';
import 'dart:io';

import 'package:amazon_clone/constants/error_handling.dart';
import 'package:amazon_clone/constants/global_var.dart';
import 'package:amazon_clone/constants/utils.dart';
import 'package:amazon_clone/models/product.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
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
}