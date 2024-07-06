import 'package:amazon_clone/common/widgets/loading.dart';
import 'package:amazon_clone/common/widgets/single_product.dart';
import 'package:amazon_clone/constants/global_var.dart';
import 'package:amazon_clone/features/home/services/home_services.dart';
import 'package:amazon_clone/features/product_details/screens/product_details_screen.dart';
import 'package:amazon_clone/models/product.dart';
import 'package:flutter/material.dart';

class CategoryScreen extends StatefulWidget {
  static const String routeName='/category-screen';
  final String category;
  const CategoryScreen({super.key, required this.category});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final homeServices= HomeServices();
  List<Product>? products;

  @override
  void initState() {
    super.initState();
    fetchCategoryProducts();
  }

  fetchCategoryProducts() async {
    products= await homeServices.fetchCategoryProducts(context: context, category: widget.category);
    setState((){});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        //used to customize size of appbar
        preferredSize: const Size.fromHeight(50), 
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: GlobalVariables.appBarGradient
            ),
          ),
          title: Text(
            widget.category,
            style: const TextStyle(color: Colors.black),
          )
        )
      ),
      body: products==null
      ? const Loading()
      : Column(children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            alignment: Alignment.topLeft,
            child: Text(
              "Keep shopping for ${widget.category}",
              style: const TextStyle(color: Colors.black, fontSize: 20),
            ),
          ),
          SizedBox(
            height: 175,
            child: GridView.builder(
              padding: const EdgeInsets.only(left: 15),
              scrollDirection: Axis.horizontal,
              itemCount: products!.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1, 
                childAspectRatio: 1.4, 
                mainAxisSpacing:10 
              ), 
              itemBuilder: (context, index){
                final product = products![index];
                return GestureDetector(
                  onTap: ()=>{
                    Navigator.pushNamed(context, ProductDetailsScreen.routeName, arguments: product)
                  },
                  child: Column(
                    children: [
                      SizedBox(
                        height: 130,
                        child: SingleProduct(imageUrl: product.images[0])
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        padding: const EdgeInsets.only(left: 0, top: 5, right: 15),
                        child:Text(
                          product.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        )
                      )
                    ],
                  ),
                );
              }
            ),
          )
        ],
      ),
    );
  }
}