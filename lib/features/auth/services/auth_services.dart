import 'dart:convert';
import 'package:amazon_clone/common/widgets/bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:amazon_clone/constants/error_handling.dart';
import 'package:amazon_clone/constants/utils.dart';
// import 'package:amazon_clone/features/home/screens/home_screen.dart';
import 'package:amazon_clone/models/user.dart';
import 'package:amazon_clone/constants/global_var.dart';
import 'package:amazon_clone/providers/user_provider.dart';

class AuthService {
  
  //sign up user

  void signUpUser({
    required BuildContext context,
    required String email,
    required String name,
    required String password,
  }) async {
    try {
      User user= User( 
        id: '', 
        name: name, 
        email: email, 
        password: password, 
        address:'', 
        type:'', 
        token:''
      );

      http.Response res = await http.post(
        Uri.parse('$uri/api/signup'), 
        body:user.toJson(),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        }
      );
      //error handling for the response which does not get caught in the catch block
      httpErrorHandler(response: res, context: context, onSuccess: (){
        showSnackBar(context, "Account created! Login with the same credentials");
      });

    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  //sign in user
  void signInUser({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try{
      http.Response res = await http.post(
        Uri.parse('$uri/api/signin'), 
        body:jsonEncode({
          "email" : email,
          "password": password
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        }
      );

      httpErrorHandler(response: res, context: context, onSuccess: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        Provider.of<UserProvider>(context, listen: false).setUser((res.body));
        await prefs.setString('x-auth-token', jsonDecode(res.body)['token']);
        Navigator.pushNamedAndRemoveUntil(context, BottomBar.routeName, (route)=>false);
      });
  
    }catch(err){
      showSnackBar(context, err.toString());
    }
  }


  //get User data
  void getUserData({
    required BuildContext context,
  }) async {
    try{
      SharedPreferences prefs= await SharedPreferences.getInstance();
      String? token = prefs.getString('x-auth-token');

      if(token==null){
        prefs.setString('x-auth-token', '');
      }
      //validate token
      http.Response res = await http.post(
        Uri.parse('$uri/api/validate'), 
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token!,
        }
      );

      var verified = jsonDecode(res.body);

      if(verified){
        //get user data
        http.Response data = await http.get(
          Uri.parse('$uri/'), 
          headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token,
          }
        );

        var userProvider= Provider.of<UserProvider>(context, listen: false);
        userProvider.setUser(data.body);
      }
  
    }catch(err){
      showSnackBar(context, err.toString());
    }
  }
}