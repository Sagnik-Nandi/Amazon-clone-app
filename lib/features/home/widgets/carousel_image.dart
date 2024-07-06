// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class CarouselImage extends StatelessWidget {
  final List<dynamic> images ;
  final double height;
  const CarouselImage({
    super.key,
    required this.images,
    this.height=200,
  });

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      items: images.map(
        (i){
          return Builder(
            builder:( BuildContext context)=>Image.network(
              i,
              fit: BoxFit.fitHeight,
              height: height,
            ),
          );
        }
      ).toList(), 
      options: CarouselOptions(
        viewportFraction: 1,
        height: height,
      )
    );
  }
}
