import 'package:amazon_clone/common/widgets/loading.dart';
import 'package:amazon_clone/common/widgets/single_product.dart';
import 'package:amazon_clone/features/admin/services/admin_services.dart';
import 'package:amazon_clone/features/order_details/screens/order_details_screen.dart';
import 'package:amazon_clone/models/order.dart';
import 'package:flutter/material.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  List<Order>? orders;
  final adminServices = AdminServices();

  final List<String> orderStatus=[
    'Pending',
    'Shipped',
    'Arrived',
    'Out for Delivery',
    'Delivered'
  ];

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  void fetchOrders() async {
    orders=await adminServices.getOrders(context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return orders == null 
    ? const Loading()
    : orders!.isEmpty 
      ? const Center(child: Text("No orders to show !"),)
      : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            child: const Text(
              "Orders received",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2), 
            shrinkWrap: true,
            itemCount: orders!.length,
            itemBuilder: (context, i) {
              final orderData = orders![i];
              return GestureDetector(
                onTap: ()=> Navigator.pushNamed(
                  context, 
                  OrderDetailsScreen.routeName,
                  arguments: orderData
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 190,
                      child: SingleProduct(imageUrl: orderData.items[0].images[0],),
                    ),
                    Text(
                      orderStatus[orderData.status as int],
                      style: TextStyle(),
                    )
                  ],
                ),
              );
            }
          ),
        ],
      );
  }
}