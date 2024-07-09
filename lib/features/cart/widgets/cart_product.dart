// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:amazon_clone/features/cart/services/cart_services.dart';
import 'package:amazon_clone/features/product_details/services/product_details_services.dart';
import 'package:amazon_clone/models/product.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartProduct extends StatefulWidget {
  final int index;
  const CartProduct({
    super.key,
    required this.index,
  });

  @override
  State<CartProduct> createState() => _CartProductState();
}

class _CartProductState extends State<CartProduct> {
  final productDetailServices= ProductDetailsServices();
  final cartServices = CartServices();

  void increaseQuantity(Product product){
    productDetailServices.addToCart(context: context, product: product);
  }

  void decreaseQuantity(Product product){
    cartServices.removeFromCart(context: context, product: product);
  }

  @override
  Widget build(BuildContext context) {
    final cartItem = Provider.of<UserProvider>(context, listen:false).user.cart[widget.index];
    final product = Product.fromMap(cartItem['product']);

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(children: [
            Image.network(
              product.images[0], 
              fit: BoxFit.cover, 
              height: 135, 
              width:135,
            ),
            Column(children: [
              Container(
                width: 235,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  product.name,
                  maxLines: 2,
                  overflow: TextOverflow.fade,
                  style: const TextStyle(color: Colors.black, fontSize: 16),
                ),
              ),
              Container(
                width: 235,
                padding: const EdgeInsets.only(left: 10, top: 5),
                child: const Text("Eligible for FREE Shipping")
              ),
              Container(
                width: 235,
                padding: const EdgeInsets.only(left: 10, top: 5),
                child: Text(
                  '\u{20B9}${product.price}',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                width: 235,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: const Text(
                  'In Stock',
                  maxLines: 2,
                  style: TextStyle(color: Colors.teal,),
                ),
              ),
            ],)
          ],),
        ),
        Container(
          margin: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black12,
                    width: 1.5
                  ),
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.black12
                ),
                child: Row(
                  children: [
                    InkWell(
                      onTap: ()=> decreaseQuantity(product),
                      child: Container(
                        width: 35,
                        height: 32,
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.remove,
                          size: 18,
                        ),
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      width: 35,
                      height: 32,
                      alignment: Alignment.center,
                      child: Text(
                        cartItem['quantity'].toString()
                      )
                    ),
                    InkWell(
                      onTap: () => increaseQuantity(product),
                      child: Container(
                        width: 35,
                        height: 32,
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.add,
                          size: 18,
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}