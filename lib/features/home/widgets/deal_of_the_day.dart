import 'package:amazon_clone/common/widgets/loading.dart';
import 'package:amazon_clone/features/home/services/home_services.dart';
import 'package:amazon_clone/features/product_details/screens/product_details_screen.dart';
import 'package:amazon_clone/models/product.dart';
import 'package:flutter/material.dart';

class DealOfTheDay extends StatefulWidget {
  const DealOfTheDay({super.key});

  @override
  State<DealOfTheDay> createState() => _DealOfTheDayState();
}

class _DealOfTheDayState extends State<DealOfTheDay> {
  final homeServices = HomeServices();
  Product? product;

  @override
  void initState() {
    super.initState();
    fetchDealOfDay();
  }

  void fetchDealOfDay() async {
    product= await homeServices.fetchDealOfDay(context: context);
    setState(() {});
  }

  void navigateToProductDetails(){
    Navigator.pushNamed(context, ProductDetailsScreen.routeName, arguments: product);
  }

  @override
  Widget build(BuildContext context) {
    return product==null
    ? const Loading()
    : product!.name.isEmpty
      ? const SizedBox()
      : GestureDetector(
        onTap: navigateToProductDetails,
        child: Column(
          children: [
            Container(
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.only(left: 10),
              child: const Text(
                "Deal of the Day",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
            ),
            Image.network(
              product!.images[0],
              height: 235,
              fit: BoxFit.cover,
            ),
            Container(
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.only(left: 15),
              child: Text(
                '\u{20B9}${product!.price}',
                style: const TextStyle(fontSize: 18),
              ),
            ),
            Container(
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.only(left: 15, bottom: 5, right: 40),
              child: Text (
                product!.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: product!.images.map((i)=>Image.network(
                  i,
                  fit: BoxFit.fitHeight,
                  width: 100,
                  height: 100,
                )).toList()
              ),
            ),
            Container(
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.only(left: 15, top: 15, bottom: 15),
              child: Text(
                'See all deals',
                style: TextStyle(color: Colors.cyan[800]),
              )
            ),
          ],
        ),
      );
  }
}