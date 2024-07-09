import 'package:amazon_clone/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartSubtotal extends StatelessWidget {
  const CartSubtotal({super.key});

  @override
  Widget build(BuildContext context) {
    final user= Provider.of<UserProvider>(context, listen:false).user;
    int sum=0;
    user.cart.map((e) => sum+=e['quantity']*e['product']['price'] as int).toList();

    return Container(
      margin: const EdgeInsets.all(10),
      child: RichText(
        text: TextSpan(
          text: 'Subtotal ',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 20
          ),
          children: <TextSpan>[
            TextSpan(
              text: ' \u{20B9}$sum',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold
              )
            ),
          ]
        ),
      ),
    );
  }
}