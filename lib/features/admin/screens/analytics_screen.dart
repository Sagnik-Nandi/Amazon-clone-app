import 'package:amazon_clone/common/widgets/loading.dart';
import 'package:amazon_clone/features/admin/models/sales.dart';
import 'package:amazon_clone/features/admin/services/admin_services.dart';
import 'package:amazon_clone/features/admin/widgets/category_product_chart.dart';
import 'package:community_charts_flutter/community_charts_flutter.dart' as charts;
import 'package:flutter/material.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  final adminServices = AdminServices();
  int? totalSales;
  List<Sales>? earnings;

  @override
  void initState() {
    super.initState();
    getEarnings();
  }

  void getEarnings()async {
    var earningData= await adminServices.getEarnings(context);
    totalSales= earningData['totalEarnings'];
    earnings = earningData['sales'];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return earnings==null ||totalSales ==null
      ? const Loading()
      : earnings!.isEmpty ||totalSales ==0
        ? const Center(child: Text("No sales to show !"),)
        : Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              child: const Text(
                "Sales earned",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox( height: 170,),
            Text(
              '\u{20B9}${totalSales!.toDouble()}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold
              ),
            ),
            Container(
              height: 250,
              padding: const EdgeInsets.only(left: 8),
              child: CategoryProductChart(seriesList: [
                charts.Series(
                  id:'Sales', 
                  data: earnings!, 
                  domainFn: (Sales sales,_)=> sales.label, 
                  measureFn: (Sales sales,_)=> sales.earning
                ),
              ]),
            )
          ],
        );
  }
}