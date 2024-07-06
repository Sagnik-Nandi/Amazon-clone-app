// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:amazon_clone/common/widgets/stars.dart';
import 'package:flutter/material.dart';

import 'package:amazon_clone/models/product.dart';

class SearchedProduct extends StatelessWidget {
  final Product product;
  const SearchedProduct({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
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
                child: const Stars(rating: 4,)
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
        )
      ],
    );
  }
}
