import 'package:amazon_clone/constants/global_var.dart';
import 'package:amazon_clone/features/account/screens/account_screen.dart';
import 'package:amazon_clone/features/home/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;

class BottomBar extends StatefulWidget {
  static const String routeName='/actual-home';
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _page=0;
  final double bottomBarWidth=42;
  final double topBorderWidth=5;

  List <Widget> pages = [
    const HomeScreen(),
    const AccountScreen(),
    const Scaffold(body: Center(child: Text('Cart page')))
  ];

  void updatePage(int page){
    setState(() {
      _page=page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_page],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _page,
        selectedItemColor: GlobalVariables.selectedNavBarColor,
        unselectedItemColor: GlobalVariables.unselectedNavBarColor,
        backgroundColor: GlobalVariables.backgroundColor,
        iconSize: 28,
        onTap: updatePage,
        items: [
          //HOME
          BottomNavigationBarItem(icon: Container(
            width: bottomBarWidth,
            decoration: BoxDecoration(
              border: Border(top: BorderSide(
                color: _page==0 
                  ? GlobalVariables.selectedNavBarColor 
                  : GlobalVariables.backgroundColor,
                width: topBorderWidth
              ) )
            ),
            child: const Icon(
              Icons.home_outlined
            ),
          ), 
          label: ''
          ),

          //ACCOUNT
          BottomNavigationBarItem(icon: Container(
            width: bottomBarWidth,
            decoration: BoxDecoration(
              border: Border(top: BorderSide(
                color: _page==1 
                  ? GlobalVariables.selectedNavBarColor 
                  : GlobalVariables.backgroundColor,
                width: topBorderWidth
              ) )
            ),
            child: const Icon(
              Icons.person_outline_outlined
            ),
          ), 
          label: ''
          ),

          //CART
          BottomNavigationBarItem(icon: Container(
            width: bottomBarWidth,
            decoration: BoxDecoration(
              border: Border(top: BorderSide(
                color: _page==2 
                  ? GlobalVariables.selectedNavBarColor 
                  : GlobalVariables.backgroundColor,
                width: topBorderWidth
              ) )
            ),
            child: const badges.Badge(
              badgeStyle: badges.BadgeStyle(
                elevation: 0, 
                badgeColor: Colors.white
              ),
              badgeContent: Text('2'),
              child: Icon(
                Icons.shopping_cart_outlined
              ),
            ),
          ), 
          label: ''
          )
        ],
      ),
    );
  }
}