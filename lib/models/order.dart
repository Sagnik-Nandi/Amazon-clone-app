// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:amazon_clone/models/product.dart';

class Order {
  final String id;
  final List<Product> items;
  final List<num> quantity;
  final String address;
  final num totalPrice;
  final String userId;
  final num orderedAt;
  final num status;
  Order({
    required this.id,
    required this.items,
    required this.quantity,
    required this.address,
    required this.totalPrice,
    required this.userId,
    required this.orderedAt,
    required this.status,
  });
  

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'items': items.map((x) => x.toMap()).toList(),
      'quantity': quantity,
      'address': address,
      'totalPrice': totalPrice,
      'userId': userId,
      'orderedAt': orderedAt,
      'status': status,
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['_id'] as String,
      items: List<Product>.from((map['items']).map((x) => Product.fromMap(x['product']),),),
      quantity: List<num>.from((map['items']).map((x) => x['quantity'])),
      address: map['address'] as String,
      totalPrice: map['totalPrice'] as num,
      userId: map['userId'] as String,
      orderedAt: map['orderedAt'] as num,
      status: map['status'] as num,
    );
  }

  String toJson() => json.encode(toMap());

  factory Order.fromJson(String source) => Order.fromMap(json.decode(source) as Map<String, dynamic>);
}
