import 'dart:io';

import 'package:amazon_clone/common/widgets/custom_button.dart';
import 'package:amazon_clone/common/widgets/custom_textfield.dart';
import 'package:amazon_clone/constants/global_var.dart';
import 'package:amazon_clone/constants/utils.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class AddProductScreen extends StatefulWidget {
  static const String routeName='/add-product';
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _productNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _quantityController = TextEditingController();

  List<String> categoryDropdown = [
    "Mobiles",
    "Essentials",
    "Appliances",
    "Books",
    "Fashion",
  ];
  String category="Mobiles";

  List<File> images =[];

  void selectImages() async {
    var res = await pickImages();
    setState(() {
      images = res;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _productNameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
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
            "Add Product", 
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          )
        )
      ),
      body: SingleChildScrollView(
        child: Form(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10).copyWith(top: 15),
            child: Column(children: [
              images.isNotEmpty ?
              CarouselSlider(
              items: images.map(
                (i){
                  return Builder(
                    builder:( BuildContext context)=>Image.file(
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
              ) 
            :  GestureDetector(
                onTap: selectImages,
                child: DottedBorder(
                  dashPattern: const [10,4,10,4],
                  strokeWidth: 2,
                  strokeCap: StrokeCap.round,
                  borderType: BorderType.RRect,
                  radius: const Radius.circular(10),
                  color: Colors.black54,
                  child: const SizedBox(
                    width: double.infinity,
                    height: 160,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.folder_open, size: 40,),
                        SizedBox(height: 15,),
                        Text(
                          "Select Product Images",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black38
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30,),
              CustomTextField(controller: _productNameController, hintText: "Product name"),
              const SizedBox(height: 10,),
              CustomTextField(controller: _descriptionController, hintText: "Description", maxLines: 7,),
              const SizedBox(height: 10,),
              CustomTextField(controller: _priceController, hintText: "Price"),
              const SizedBox(height: 10,),
              CustomTextField(controller: _quantityController, hintText: "Quantity"),
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
              CustomButton(text: "Sell", onTap: (){})
            ],),
          ),
        ),
      )
    );
  }
}