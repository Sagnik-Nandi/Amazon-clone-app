// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: avoid_print

import 'package:amazon_clone/constants/utils.dart';
import 'package:amazon_clone/features/address/services/address_services.dart';
import 'package:flutter/material.dart';
import 'package:pay/pay.dart';
import 'package:provider/provider.dart';

import 'package:amazon_clone/common/widgets/custom_textfield.dart';
import 'package:amazon_clone/constants/global_var.dart';
import 'package:amazon_clone/constants/payment_config.dart';
import 'package:amazon_clone/providers/user_provider.dart';

class AddressScreen extends StatefulWidget {
  static const String routeName= '/address';
  final String totalAmount;
  const AddressScreen({
    super.key,
    required this.totalAmount,
  });

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final flatBuildingController = TextEditingController();
  final areaController = TextEditingController();
  final pinCodeController = TextEditingController();
  final cityController = TextEditingController();
  final _addresFormKey = GlobalKey<FormState>();

  String addressToBeUsed ='';
  List<PaymentItem> paymentItems = [];
  final addressServices = AddressServices();

  @override
  void initState() {
    super.initState();
    paymentItems.add(
      PaymentItem(
        amount: widget.totalAmount, 
        label: "Total Amount", 
        status: PaymentItemStatus.final_price
      )
    );
  }

  @override
  void dispose() {
    super.dispose();
    flatBuildingController.dispose();
    areaController.dispose();
    pinCodeController.dispose();
    cityController.dispose();
  }

  void onGpayResult(res){
    if(Provider.of<UserProvider>(context, listen: false).user.address.isEmpty){
      addressServices.saveUserAddress(
        context: context, 
        address: addressToBeUsed
      );
    }
    addressServices.placeOrder(
      context: context, 
      address: addressToBeUsed, 
      total: double.parse(widget.totalAmount)
    );
  }

  void payPressed(String addressFromProvider){
    addressToBeUsed=''; 
    //if you press pay button twice then it removes the pre-existing value
    
    bool useForm = flatBuildingController.text.isNotEmpty 
      || areaController.text.isNotEmpty 
      || pinCodeController.text.isNotEmpty 
      || cityController.text.isNotEmpty;
    if(useForm){
      if(_addresFormKey.currentState!.validate()){
        addressToBeUsed = "${flatBuildingController.text}, ${areaController.text}, ${cityController.text}-${pinCodeController.text}";
      } else {
        throw Exception("Please enter all the values");
      }
    } else if (addressFromProvider.isNotEmpty){
      addressToBeUsed=addressFromProvider;
    } else {
      showSnackBar(context, "ERROR");
    }
  }

  @override
  Widget build(BuildContext context) {
    final address = Provider.of<UserProvider>(context, listen: false).user.address;
    // const address= 'Amar Kuthi, Flat no C/4,Junbedia Bypass, Bankura-722101';

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
        )
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              if(address.isNotEmpty)
                Column(
                  children: [
                    const SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: Text(
                        'Please Choose Delivery Address',
                        style: TextStyle(
                          color: Colors.black45,
                          fontWeight: FontWeight.bold,
                          fontSize: 22
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black12
                        )
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          address, 
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20,),
                    const Text(
                      "OR",
                      style: TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 20,)
                  ],
                ),
              if(address.isEmpty)
                const SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: Text(
                    'Please Enter Delivery Address',
                    style: TextStyle(
                      color: Colors.black45,
                      fontWeight: FontWeight.bold,
                      fontSize: 22
                    ),
                  ),
                ),
              Form(
                key: _addresFormKey,
                child: Column(children: [
                  CustomTextField(
                    controller: flatBuildingController,
                    hintText: "Flat, House no, Building",
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  CustomTextField(
                    controller: areaController,
                    hintText: "Area, Street",
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  CustomTextField(
                    controller: pinCodeController,
                    hintText: "Pin code",
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  CustomTextField(
                    controller: cityController,
                    hintText: "Town/City",
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                ]),
              ),
              
              GooglePayButton(
                paymentConfiguration: PaymentConfiguration.fromJsonString(
                    defaultGooglePay),
                paymentItems: paymentItems,
                onPaymentResult: onGpayResult,
                
                theme: GooglePayButtonTheme.dark,
                type: GooglePayButtonType.buy,
                margin: const EdgeInsets.only(top: 15.0),
                height: 50,
                loadingIndicator: const Center(
                  child: CircularProgressIndicator(),
                ),
                onError: (Object? error) {
                  print("error: ${error!.toString()}");
                },
                childOnError: const Text('errror'),
                onPressed: () => payPressed(address),
              ),
            ],
          ),
        ),
      ),
    );
  }
}