import 'package:amazon_clone/constants/utils.dart';
import 'package:amazon_clone/features/account/services/account_services.dart';
import 'package:amazon_clone/features/account/widgets/account_button.dart';
import 'package:flutter/material.dart';

class TopButtons extends StatelessWidget {
  const TopButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            AccountButton(content: "Your Orders", onpressed: (){}),
            AccountButton(content: "Buy Again", onpressed: (){})
          ],
        ),
        const SizedBox(height: 10,),
        Row(
          children: [
            AccountButton(content: "Log Out", onpressed: (){
              showAlertDialog(
                context: context, 
                title: "Confirm", 
                content: "Are you sure you want to sign-out?", 
                onPressedYes: AccountServices().logOut , 
                onPressedNo: Navigator.of(context).pop,
              );
            }),
            AccountButton(content: "Your List", onpressed: (){})
          ],
        )
      ],
    );
  }
}