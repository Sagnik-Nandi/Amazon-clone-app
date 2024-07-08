// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:amazon_clone/models/rating.dart';

class Product {
  final String name;
  final String description;
  final num price;
  final num quantity;
  final String category;
  final List<dynamic> images;
  final List<Rating>? ratings;
  final String? id;

  Product({
    required this.name,
    required this.description,
    required this.price,
    required this.quantity,
    required this.category,
    required this.images,
    this.ratings,
    this.id,
  });

  //rating

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'description': description,
      'price': price,
      'quantity': quantity,
      'category': category,
      'images': images,
      'id': id,
      'ratings': ratings
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      name: map['name'] as String,
      description: map['description'] as String,
      price: map['price'] as num,
      quantity: map['quantity'] as num,
      category: map['category'] as String,
      images: List<dynamic>.from((map['images'] as List<dynamic>)),
      id: map['_id'] != null ? map['_id'] as String : null,
      ratings: map['ratings'] != null 
          ? List<Rating>.from(
              map['ratings']?.map(
                (x)=> Rating.fromMap(x)
              )
            ) 
          : null
    );
  }

  String toJson() => json.encode(toMap());

  factory Product.fromJson(String source) => Product.fromMap(json.decode(source) as Map<String, dynamic>);
}
