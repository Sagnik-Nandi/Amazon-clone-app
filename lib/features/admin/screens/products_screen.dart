import 'package:amazon_clone/common/widgets/loading.dart';
import 'package:amazon_clone/common/widgets/single_product.dart';
import 'package:amazon_clone/features/admin/screens/add_product.dart';
import 'package:amazon_clone/features/admin/screens/edit_products.dart';
import 'package:amazon_clone/features/admin/services/admin_services.dart';
import 'package:amazon_clone/models/product.dart';
import 'package:flutter/material.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  List<Product>? productList;
  final adminServices = AdminServices();

  @override
  void initState() {
    super.initState();
    fetchAllProducts();
  }

  void fetchAllProducts() async{
    productList = await adminServices.getProducts(context);
    setState(() {});
  }

  void deleteProduct(Product product, int index) async{
    adminServices.deleteProduct(
      context: context, 
      product: product, 
      onSuccess: (){
        productList!.remove(product);
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return productList==null 
    ? const Loading() 
    : Scaffold(
      body: productList!.isEmpty
      ? const Center(child: Text("No products to show !"),)
      : Padding(
        padding: const EdgeInsets.all(6),
        child: GridView.builder(
          itemCount: productList!.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2), 
          itemBuilder: (context, index){
            final productData=productList![index];
            return Column(children: [
              SizedBox(
                height: 140,
                child: SingleProduct(
                  imageUrl: productData.images[0],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Text(
                      productData.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, EditProductScreen.routeName, arguments: productData);
                    }, 
                    icon: const Icon(Icons.edit_outlined)
                  ),
                  IconButton(
                    onPressed: () => deleteProduct(productData, index), 
                    icon: const Icon(Icons.delete_outline)
                  )
                ],
              )
            ],
            );
          }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.pushNamed(context, AddProductScreen.routeName);
        },
        tooltip: "Add a product",
        shape: const CircleBorder(),
        backgroundColor: const Color.fromARGB(255, 29, 201, 192),
        foregroundColor: Colors.black,
        child: const Icon(Icons.add,),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}