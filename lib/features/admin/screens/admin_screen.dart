import 'package:amazon_clone/constants/global_var.dart';
import 'package:amazon_clone/features/admin/screens/products_screen.dart';
import 'package:flutter/material.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  int _page=0;
  final double bottomBarWidth=42;
  final double topBorderWidth=5;

  List <Widget> pages = [
    const ProductsScreen(),
    const Center(child: Text('Analytics page')),
    const Center(child: Text('Cart page'))
  ];

  void updatePage(int page){
    setState(() {
      _page=page;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        //used to customize size of appbar
        preferredSize: const Size.fromHeight(50), 
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: GlobalVariables.appBarGradient
            ),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                alignment: Alignment.topLeft,
                child: const Image(
                  width: 120,
                  height: 45,
                  color: Colors.black,
                  image: AssetImage('assets/images/amazon_in.png'),),
              ),
              const Text(
                'Admin',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w700
                ),
              )
            ],
          ),
        )
      ),
      body: pages[_page],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _page,
        selectedItemColor: GlobalVariables.selectedNavBarColor,
        unselectedItemColor: GlobalVariables.unselectedNavBarColor,
        backgroundColor: GlobalVariables.backgroundColor,
        iconSize: 28,
        onTap: updatePage,
        items: [
          //PRODUCTS
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

          //ANALYTICS
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
              Icons.analytics_outlined
            ),
          ), 
          label: ''
          ),

           //ORDERS
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
            child: const Icon(
              Icons.all_inbox_outlined
            ),
          ), 
          label: ''
          ),
        ],
      ),
    );
  }
}