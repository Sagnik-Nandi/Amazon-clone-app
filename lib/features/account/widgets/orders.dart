import 'package:amazon_clone/common/widgets/single_product.dart';
import 'package:amazon_clone/constants/global_var.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';

class Orders extends StatefulWidget {
  const Orders({super.key});

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {

  //temporary list
  List list=[
    "https://images.rawpixel.com/image_800/cHJpdmF0ZS9sci9pbWFnZXMvd2Vic2l0ZS8yMDIyLTExL3JtMzYyLTAxYS1tb2NrdXAuanBn.jpg",
    "https://images.pexels.com/photos/3766180/pexels-photo-3766180.jpeg?cs=srgb&dl=pexels-alexazabache-3766180.jpg&fm=jpg",
    "https://backend.orbitvu.com/sites/default/files/image/sport-shoe-white-background.jpeg",
    "https://images.rawpixel.com/image_800/cHJpdmF0ZS9sci9pbWFnZXMvd2Vic2l0ZS8yMDIyLTExL3JtMzYyLTAxYS1tb2NrdXAuanBn.jpg",
    "https://images.pexels.com/photos/3766180/pexels-photo-3766180.jpeg?cs=srgb&dl=pexels-alexazabache-3766180.jpg&fm=jpg",
    "https://backend.orbitvu.com/sites/default/files/image/sport-shoe-white-background.jpeg",
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
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
            itemCount: list.length,
            itemBuilder: ((context, index){
              return SingleProduct(imageUrl: list[index]);
          })),
        )
      ],
    );
  }
}