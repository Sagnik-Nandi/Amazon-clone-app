// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:community_charts_flutter/community_charts_flutter.dart' as charts;
import 'package:flutter/material.dart';

import 'package:amazon_clone/features/admin/models/sales.dart';

class CategoryProductChart extends StatelessWidget {
  final List<charts.Series<Sales, String>> seriesList;
  const CategoryProductChart({
    super.key,
    required this.seriesList,
  });

  @override
  Widget build(BuildContext context) {
    return charts.BarChart(
      seriesList,
      animate: true,
    );
  }
}
