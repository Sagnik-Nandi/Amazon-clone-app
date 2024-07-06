import 'package:amazon_clone/common/widgets/bottom_bar.dart';
import 'package:amazon_clone/features/admin/screens/add_product.dart';
import 'package:amazon_clone/features/auth/screens/auth_screen.dart';
import 'package:amazon_clone/features/home/screens/category_screen.dart';
import 'package:amazon_clone/features/home/screens/home_screen.dart';
import 'package:amazon_clone/features/search/screens/search_screen.dart';
import 'package:flutter/material.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case AuthScreen.routeName: //routeName
      return MaterialPageRoute(
          settings: routeSettings, builder: (_) => const AuthScreen());
    case HomeScreen.routeName: //routeName
      return MaterialPageRoute(
          settings: routeSettings, builder: (_) => const HomeScreen());
    case BottomBar.routeName: //routeName
      return MaterialPageRoute(
          settings: routeSettings, builder: (_) => const BottomBar());
    case AddProductScreen.routeName: //routeName
      return MaterialPageRoute(
          settings: routeSettings, builder: (_) => const AddProductScreen());
    
    case CategoryScreen.routeName: 
    var category= routeSettings.arguments as String;//routeName
      return MaterialPageRoute(
          settings: routeSettings, builder: (_) => CategoryScreen(
            category: category,
          )
      );

    case SearchScreen.routeName: 
    var searchQuery= routeSettings.arguments as String;//routeName
      return MaterialPageRoute(
          settings: routeSettings, builder: (_) => SearchScreen(
            searchQuery: searchQuery,
          )
      );
      
    default:
      return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => const Scaffold(
                body: Center(child: Text("Screen does not exist")),
              ));
  }
}
