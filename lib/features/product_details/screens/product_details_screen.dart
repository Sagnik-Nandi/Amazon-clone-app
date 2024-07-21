// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';

import 'package:amazon_clone/common/widgets/custom_button.dart';
import 'package:amazon_clone/common/widgets/stars.dart';
import 'package:amazon_clone/features/cart/screens/cart_screen.dart';
import 'package:amazon_clone/features/home/widgets/carousel_image.dart';
import 'package:amazon_clone/features/product_details/services/product_details_services.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:flutter/material.dart';

import 'package:amazon_clone/constants/global_var.dart';
import 'package:amazon_clone/features/search/screens/search_screen.dart';
import 'package:amazon_clone/models/product.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

class ProductDetailsScreen extends StatefulWidget {
  static const String routeName='/Product-deatils-screen';
  final Product product;
  const ProductDetailsScreen({
    super.key,
    required this.product,
  });

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final productDetailsServices= ProductDetailsServices();
  num avgRating=0; 
  num myRating=0;

  @override
  void initState() {
    super.initState();
    num totalRating=0;
    for(int i=0; i<widget.product.ratings!.length; i++){
      totalRating+=widget.product.ratings![i].rating;
      if(widget.product.ratings![i].userId==Provider.of<UserProvider>(context, listen: false).user.id){
        myRating=widget.product.ratings![i].rating;
      }
    }

    if(widget.product.ratings!.isNotEmpty){
      avgRating=totalRating/(widget.product.ratings!.length);
    }
    
  }

  void addToCart(){
    productDetailsServices.addToCart(context: context, product: widget.product);
  }

  void navigateToSearchScreen(String query) {
    Navigator.pushReplacementNamed(context, SearchScreen.routeName, arguments: query);
  }
  
  void buyNow() {
    productDetailsServices.addToCart(context: context, product: widget.product);
    Navigator.pushNamed(context, CartScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    List<String> available=['Currently unavailable', 'Only 1 left', 'In stock'];
    List<dynamic> colorScheme = [Colors.red[500], Colors.orange[800], Colors.teal];
    var index = min(widget.product.quantity, 2) as int;
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(widget.product.id!),
                  Stars(rating: avgRating.toDouble())
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: Text(
                widget.product.name,
                style: const TextStyle(fontSize: 16)
                ),
            ),
            CarouselImage(images: widget.product.images, height: 300,),
            Container(height:5, color: Colors.black12,),
            Container(
                width: 235,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  available[index],
                  maxLines: 2,
                  style: TextStyle(
                    color: colorScheme[index],
                    fontSize: 17
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: RichText(
                text: TextSpan(
                  text: "Deal Price: ",
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold
                  ),
                  children: [
                    TextSpan(
                      text: '\u{20B9}${widget.product.price}',
                      style: TextStyle(
                        decoration: index==0
                          ? TextDecoration.lineThrough 
                          : TextDecoration.none,
                        color: index==0
                          ? Colors.black26
                          : Colors.red,
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                      )
                    ),
                  ]
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(widget.product.description),
            ),
            if(index!=0) ...[
              Container(height:5, color: Colors.black12,),
              Padding(
                padding: const EdgeInsets.all(10),
                child: CustomButton(
                  onTap: buyNow,
                  text: "Buy Now",
                ),
              ),
              const SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.all(10),
                child: CustomButton(
                  onTap: addToCart,
                  text: "Add to Cart",
                  color: const Color.fromRGBO(254, 216, 19, 1),
                  textColor: Colors.black,
                ),
              ),
            ],
            Container(height:5, color: Colors.black12,),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                'Rate The Product',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 22,
                  fontWeight: FontWeight.bold
                )
              ),
            ),
            RatingBar.builder(
              initialRating: myRating.toDouble(),
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: const EdgeInsets.symmetric(horizontal: 4),
              itemBuilder: (context, i)=>const Icon(
                Icons.star,
                color:GlobalVariables.secondaryColor
              ), 
              onRatingUpdate: (rating){
                productDetailsServices.rateProduct(context: context, product: widget.product, rating: rating);
              }
            )
          ],
        ),
      ),
    );
  }
}