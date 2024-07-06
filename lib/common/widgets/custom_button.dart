// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:amazon_clone/constants/global_var.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final Color? color;
  final Color? textColor;
  const CustomButton({
    super.key,
    required this.text,
    required this.onTap,
    this.color=GlobalVariables.secondaryColor,
    this.textColor=Colors.white
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: color,
        foregroundColor: textColor,
        minimumSize: const Size(double.infinity, 50),
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}
