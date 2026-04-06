import 'package:fintech_new_web/features/colorCode/provider/color_provider.dart';
import 'package:fintech_new_web/features/salesReport/provider/sales_report_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../../common/widgets/comman_appbar.dart';
import '../../common/widgets/pop_ups.dart';
import '../../network/service/network_service.dart';

class YearlyCategorySalesReport extends StatefulWidget {
  static String routeName = "YearlyCategorySalesReport";

  const YearlyCategorySalesReport({super.key});

  @override
  State<YearlyCategorySalesReport> createState() => _YearlyCategorySalesReportState();
}

class _YearlyCategorySalesReportState extends State<YearlyCategorySalesReport> {
  @override
  void initState() {
    SalesReportProvider provider =
    Provider.of<SalesReportProvider>(context, listen: false);
    provider.getYearlyCatSalesReport();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SalesReportProvider>(builder: (context, provider, child) {
      return Material(
        child: SafeArea(
            child: Scaffold(
              appBar: PreferredSize(
                  preferredSize:
                  Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
                  child: const CommonAppbar(title: 'Yearly Category Sales Report')),
              body: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: provider.ysCatReport.isNotEmpty
                      ? DataTable(
                    columnSpacing: 25,
                    columns: const [
                      DataColumn(label: Text("CATEGORY", style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text("SUBCATEGORY", style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text("APRIL", style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text("MAY", style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text("JUNE", style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text("JULY", style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text("AUGUST", style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text("SEPTEMBER", style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text("OCTOBER", style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text("NOVEMBER", style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text("DECEMBER", style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text("JANUARY", style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text("FEBRUARY", style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text("MARCH", style: TextStyle(fontWeight: FontWeight.bold))),
                      // DataColumn(label: Text("TOTAL", style: TextStyle(fontWeight: FontWeight.bold)))
                    ],
                    rows: provider.catRows,
                  )
                      : const SizedBox(),
                ),
              ),
            )),
      );
    });
  }
}
