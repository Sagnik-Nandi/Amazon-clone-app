import 'package:amazon_clone/common/widgets/custom_button.dart';
import 'package:amazon_clone/constants/global_var.dart';
import 'package:amazon_clone/features/address/screens/address_screen.dart';
import 'package:amazon_clone/features/cart/widgets/cart_product.dart';
import 'package:amazon_clone/features/cart/widgets/cart_subtotal.dart';
import 'package:amazon_clone/features/home/widgets/address_box.dart';
import 'package:amazon_clone/features/search/screens/search_screen.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  static const String routeName = '/cart-screen';
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {

  void navigateToSearchScreen(String query) {
    Navigator.pushNamed(context, SearchScreen.routeName, arguments: query);
  }

  void navigateToAddressScreen(int sum) {
    Navigator.pushNamed(context, AddressScreen.routeName, arguments: sum.toString() );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context, listen: false).user;
    int sum=0;
    user.cart.map((e) => sum+=e['quantity']*e['product']['price'] as int).toList();

    return Scaffold(
      appBar: PreferredSize(
        //used to customize size of appbar
        preferredSize: const Size.fromHeight(60), 
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: GlobalVariables.appBarGradient
            ),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Container(
                  height: 42,
                  margin: const EdgeInsets.only(left: 15),
                  child: Material(
                    borderRadius: const BorderRadius.all(Radius.circular(7)),
                    elevation: 1,
                    child: TextFormField(
                      onFieldSubmitted: navigateToSearchScreen,
                      decoration: InputDecoration(
                        prefixIcon: InkWell(
                          onTap: (){},
                          child: const Padding(
                            padding: EdgeInsets.only(left: 6),
                            child: Icon(
                              Icons.search,
                              color: Colors.black,
                              size: 23,
                            ),
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.only(top:10),
                        border: const OutlineInputBorder(
                          borderRadius:BorderRadius.all(Radius.circular(7)),
                          borderSide: BorderSide.none
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderRadius:BorderRadius.all(Radius.circular(7)),
                          borderSide: BorderSide(color: Colors.black38, width: 1)
                        ),
                        hintText: "Search Amazon",
                        hintStyle: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w400
                        )
                      ),
                    ),
                  )
                ),
              ),
              Container(
                height: 42,
                margin:const EdgeInsets.symmetric(horizontal: 10),
                color: Colors.transparent,
                child: const Icon(Icons.mic, color: Colors.black,size: 25,),
              )
            ],
          ),
        )
      ),
      body: SingleChildScrollView(
        // scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AddressBox(),
            const CartSubtotal(),
            if (user.cart.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8),
                child: CustomButton(
                  text: user.cart.length==1 
                    ? 'Procced to Buy (${user.cart.length} item)'
                    : 'Procced to Buy (${user.cart.length} items)',
                  onTap:()=> navigateToAddressScreen(sum),
                  color: Colors.yellow[600],
                  textColor: Colors.black,
                ),
              ),
            const SizedBox(height: 15,),
            Container(
              color: Colors.black12,
              height:1
            ),
            const SizedBox(height: 5,),
            ListView.builder(
              itemCount: user.cart.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return CartProduct(index: index);
              }
            ),
            if (user.cart.isEmpty)...[
              const SizedBox(height: 270,),
              const Center(
                child: Text(
                  "Your cart is empty!"
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}