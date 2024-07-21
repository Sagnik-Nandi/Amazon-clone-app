import 'package:amazon_clone/common/widgets/loading.dart';
import 'package:amazon_clone/common/widgets/single_product.dart';
import 'package:amazon_clone/constants/global_var.dart';
import 'package:amazon_clone/features/account/services/account_services.dart';
import 'package:amazon_clone/features/order_details/screens/order_details_screen.dart';
import 'package:amazon_clone/models/order.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';

class Orders extends StatefulWidget {
  const Orders({super.key});

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  final accountServices = AccountServices();
  List<Order>? orders;

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  void fetchOrders() async{
    orders = await accountServices.fetchOrderDetails(context: context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return orders==null
    ? const Loading()
    : Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.only(left:15),
              child: const Text(
                "Your Orders",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18, 
                  fontWeight: FontWeight.w600
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(right: 15),
              child: Text(
                "See all",
                style: TextStyle(color: GlobalVariables.selectedNavBarColor),
                )
            )
            
          ],
        ),
        Container(
          height: 170,
          padding: const EdgeInsets.only(left:10, top: 20, right: 0),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: orders!.length,
            itemBuilder: ((context, index){
              return GestureDetector(
                onTap: () => Navigator.pushNamed(
                  context, 
                  OrderDetailsScreen.routeName, 
                  arguments: orders![index]
                ),
                child: SingleProduct(
                  imageUrl: orders![index].items[0].images[0]
                )
              );
          })),
        )
      ],
    );
  }
}