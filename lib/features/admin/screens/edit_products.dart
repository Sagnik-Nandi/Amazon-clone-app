// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:amazon_clone/common/widgets/custom_button.dart';
import 'package:amazon_clone/constants/utils.dart';
import 'package:amazon_clone/features/admin/services/admin_services.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import 'package:amazon_clone/common/widgets/custom_textfield.dart';
import 'package:amazon_clone/constants/global_var.dart';
import 'package:amazon_clone/models/product.dart';

class EditProductScreen extends StatefulWidget {
  static const String routeName= '/edit-product';
  final Product product;
  const EditProductScreen({
    super.key,
    required this.product,
  });

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _productNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _quantityController = TextEditingController();

  final _editProductFormKey= GlobalKey<FormState>();
  final adminServices= AdminServices();

  List<String> categoryDropdown = [
    "Mobiles",
    "Essentials",
    "Appliances",
    "Books",
    "Fashion",
  ];
  String? category;
  List<dynamic>? images;
  List<File>? moreImages;

  @override
  void dispose() {
    super.dispose();
    _productNameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
  }

  @override
  void initState() {
    super.initState();
    _productNameController.text=widget.product.name;
    _descriptionController.text=widget.product.description;
    _priceController.text=widget.product.price.toString();
    _quantityController.text=widget.product.quantity.toString();
    category=widget.product.category;
    images=widget.product.images ;
  }

  void saveProduct(){
    if(_editProductFormKey.currentState!.validate()){
      adminServices.editProduct(
        context: context, 
        name: _productNameController.text, 
        description: _descriptionController.text, 
        price: num.parse(_priceController.text), 
        quantity: num.parse(_quantityController.text), 
        category: category!, 
        prevImages: images!,
        images: moreImages,
        id: widget.product.id
      );
    }
  }

  void addImages() async {
    var res = await pickImages();
    setState(() {
      moreImages = res;
    });
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
          centerTitle: true,
          title: const Text(
            "Edit Product", 
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          )
        )
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _editProductFormKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                CarouselSlider(
                  items: images!.map(
                    (i){
                      return Builder(
                        builder:( BuildContext context)=>Image.network(
                          i,
                          fit: BoxFit.cover,
                          height: 160,
                        ),
                      );
                    }
                  ).toList(), 
                  options: CarouselOptions(
                    viewportFraction: 1,
                    height: 160,
                  )
                ),
                Container(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    tooltip: "Add product images, changes may take some time",
                    onPressed: addImages, 
                    icon: const Icon(
                      Icons.add_photo_alternate_outlined,
                      size: 35,
                    )
                  ),
                ),
                const SizedBox(height: 10,),
                CustomTextField(
                  controller: _productNameController, 
                  hintText: "Product name",
                ),
                const SizedBox(height: 10,),
                CustomTextField(
                  controller: _descriptionController,
                  hintText: "Description", 
                  maxLines: 7,
                ),
                const SizedBox(height: 10,),
                CustomTextField(
                  controller: _priceController, 
                  hintText: "Price",
                ),
                const SizedBox(height: 10,),
                CustomTextField(
                  controller: _quantityController, 
                  hintText: "Quantity",
                ),
                const SizedBox(height: 10,),
                SizedBox(
                  width: double.infinity,
                  child: DropdownButton(
                    value: category,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: categoryDropdown.map((String item){
                      return DropdownMenuItem(
                        value: item, 
                        child: Text(item)
                      ) ;
                    }).toList(),
                    onChanged: (String? newItem){
                      setState(() {
                        category = newItem!;
                      });
                    },
                  ),
                ),
                CustomButton(text: "Save", onTap: saveProduct),
              ],
            ),
          )
        ),
      ),
    );
  }
}