// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';

import 'package:amazon_clone/common/widgets/custom_button.dart';
import 'package:amazon_clone/constants/global_var.dart';
import 'package:amazon_clone/features/admin/services/admin_services.dart';
import 'package:amazon_clone/features/search/screens/search_screen.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:amazon_clone/models/order.dart';
import 'package:provider/provider.dart';

class OrderDetailsScreen extends StatefulWidget {
  static const String routeName='/order-details';
  final Order order;
  const OrderDetailsScreen({
    super.key,
    required this.order,
  });

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  final adminServices = AdminServices();
  int currentState=0;

  void navigateToSearchScreen(String query) {
    Navigator.pushNamed(context, SearchScreen.routeName, arguments: query);
  }

  //ONLY FOR ADMIN !!
  void updateOrderStatus(){
    adminServices.updateOrderStatus(
      context: context, 
      currentState: currentState, 
      order: widget.order, 
      onSuccess: (){
        setState(() {
          currentState+=1;
          //OR
          //currentState=widget.order.status as int;
        });
      }
    );
  }

  @override
  void initState() {
    super.initState();
    currentState=widget.order.status as int;
  }

  @override
  Widget build(BuildContext context) {
    final userType=Provider.of<UserProvider>(context, listen: false).user.type;

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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'View Order Details',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order Date:      ${DateFormat().format(
                        DateTime.fromMillisecondsSinceEpoch(
                          widget.order.orderedAt as int)
                        ) 
                      }'
                    ),
                    Text(
                      'Order ID:          ${widget.order.id}'
                    ),
                    Text(
                      'Order Total:      \u{20B9}${widget.order.totalPrice.toDouble()}'
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10,),
              const Text(
                'Purchase Details',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black12),
                ),
                child: Column(
                  children: [
                    for(int i=0; i<widget.order.items.length; i++) 
                    //dont use braces, this is a collection of widgets
                      Row(children: [
                        Image.network(
                          widget.order.items[i].images[0],
                          fit: BoxFit.fitHeight,
                          height: 120,
                          width: 120,
                        ),
                        const SizedBox(width: 5,),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.order.items[i].name,
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                'Qty: ${widget.order.quantity[i]}',
                              )
                            ],
                          ),
                        )
                      ],)
                  ],
                )
              ),
              const SizedBox(height: 10,),
              const Text(
                'Tracking',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black12),
                ),
                child: Stepper(
                  currentStep: min(currentState,3),
                  controlsBuilder: (context, details) => 
                    userType=='admin' && currentState<=3
                    ? CustomButton(text: 'Done', onTap: updateOrderStatus)
                    : const SizedBox(),
                  steps: [
                    Step(
                      title: const Text('Ordered'), 
                      content: const Text('Your order is being processed'),
                      isActive: currentState>=0,
                      state: currentState>0 
                        ? StepState.complete
                        : StepState.indexed
                    ),
                    Step(
                      title: const Text('Shipped'), 
                      content: const Text('Your package has been shipped and will soon arrive at your nearest facility'),
                      isActive: currentState>=1,
                      state: currentState>1
                        ? StepState.complete
                        : StepState.indexed
                    ),
                    Step(
                      title: const Text('Arrived'), 
                      content: const Text('Your package has arrived and will be delivered very soon'),
                      isActive: currentState>=2,
                      state: currentState>2
                        ? StepState.complete
                        : StepState.indexed
                    ),
                    Step(
                      title: currentState==3
                        ? const Text('Out for delivery')
                        : const Text('Delivered'), 
                      content:  currentState==3
                        ? const Text('Your package is out for delivery')
                        : const Text('Order was delivered'),
                      isActive: currentState>=3,
                      state: currentState>=3
                        ? StepState.complete
                        : StepState.indexed
                    ),
                  ]
                )
              )
            ],
          ),
        ),
      )
    );
  }
}