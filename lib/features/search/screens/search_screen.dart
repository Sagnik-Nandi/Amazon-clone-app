// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:amazon_clone/common/widgets/loading.dart';
import 'package:amazon_clone/constants/global_var.dart';
import 'package:amazon_clone/features/home/widgets/address_box.dart';
import 'package:amazon_clone/features/product_details/screens/product_details_screen.dart';
import 'package:amazon_clone/features/search/services/search_services.dart';
import 'package:amazon_clone/features/search/widget/searched_product.dart';
import 'package:amazon_clone/models/product.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  static const String routeName= '/search-screen';
  final String searchQuery ;
  const SearchScreen({
    super.key,
    required this.searchQuery,
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final searchServices = SearchServices();
  List<Product>? products;
  
  @override
  void initState() {
    super.initState();
    fetchSearchedProducts();
  }

  void fetchSearchedProducts() async {
    products = await searchServices.fetchSearchedProducts(context: context, searchQuery: widget.searchQuery);
    setState((){});
  }

  void navigateToSearchScreen(String query) {
    Navigator.pushReplacementNamed(context, SearchScreen.routeName, arguments: query);
  }

  @override
  Widget build(BuildContext context) {
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
      body: products==null
      ? const Loading()
      : Column(
          children: [
            const AddressBox(),
            const SizedBox(height: 10),
            Expanded(child: ListView.builder(
              itemCount: products!.length,
              itemBuilder: (context, index){
                return GestureDetector(
                  onTap: (){
                    Navigator.pushNamed(
                      context, 
                      ProductDetailsScreen.routeName,
                      arguments: products![index]
                    );
                  },
                  child: SearchedProduct(product: products![index])
                );
              }),
            )
          ],
        )
    );
  }
}