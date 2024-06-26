import 'package:flutter/material.dart';

class AccountButton extends StatelessWidget {
  final String content;
  final VoidCallback onpressed;
  const AccountButton({super.key, required this.content, required this.onpressed});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        height: 40,
        child: OutlinedButton( 
          style: ElevatedButton.styleFrom(
            side: const BorderSide(
              color: Colors.black12,
              width: 1.5
            ),
            backgroundColor: Colors.black.withOpacity(0.06),
          ),
          onPressed: onpressed,
          child: Text(
            content, 
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.normal
            ),
          ),
        ),
      ),
    );
  }
}