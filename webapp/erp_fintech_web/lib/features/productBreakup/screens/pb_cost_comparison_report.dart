import 'package:fintech_new_web/features/colorCode/provider/color_provider.dart';
import 'package:fintech_new_web/features/productBreakup/provider/product_breakup_provider.dart';
import 'package:fintech_new_web/features/utility/services/common_utility.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../billReceipt/screen/hyperlink.dart';
import '../../common/widgets/comman_appbar.dart';
import '../../common/widgets/pop_ups.dart';
import '../../network/service/network_service.dart';

class PbCostComparisonReport extends StatefulWidget {
  static String routeName = "PbCostComparisonReport";

  const PbCostComparisonReport({super.key});

  @override
  State<PbCostComparisonReport> createState() => _PbCostComparisonReportState();
}

class _PbCostComparisonReportState extends State<PbCostComparisonReport> {
  String cid = "";

  @override
  void initState() {
    ProductBreakupProvider provider = Provider.of<ProductBreakupProvider>(context, listen: false);
    provider.getPbCostComparison();
    setCid();
  }

  void setCid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
    cid = prefs.getString("currentLoginCid")!;
    });

  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductBreakupProvider>(builder: (context, provider, child) {
      return Material(
        child: SafeArea(
            child: Scaffold(
              appBar: PreferredSize(
                  preferredSize:
                  Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
                  child: const CommonAppbar(title: 'Product Breakup Cost Comparison')),
              body: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: provider.pbCostComp.isNotEmpty
                      ? DataTable(
                    columnSpacing: 25,
                    columns: const [
                      DataColumn(label: Text("Material No.", style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text("Description", style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text("MRP", style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text("List Rate", style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text("Target Price", style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text("P.Cost", style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text("Difference", style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text("Diff.(%)", style: TextStyle(fontWeight: FontWeight.bold))),
                    ],
                    rows: provider.pbCostComp.map((data) {
                      return DataRow(cells: [
                        DataCell(Hyperlink(
                            text: data['matno'],
                            url: "/product-breakup/${data['matno']}/$cid/")),
                        DataCell(SizedBox(width: 425,child: Text('${data['chrDescription'] ?? "-"}', maxLines: 2))),
                        DataCell(Align(alignment: Alignment.centerRight,child: Text(parseDoubleUpto2Decimal('${data['mrp'] ?? "-"}')))),
                        DataCell(Align(alignment: Alignment.centerRight,child: Text(parseDoubleUpto2Decimal('${data['listRate'] ?? "-"}')))),
                        DataCell(Align(alignment: Alignment.centerRight,child: Text(parseDoubleUpto2Decimal('${data['targetp'] ?? "-"}')))),
                        DataCell(Align(alignment: Alignment.centerRight,child: Text(parseDoubleUpto2Decimal('${data['tamount'] ?? "-"}')))),
                        DataCell(Align(alignment: Alignment.centerRight,child: Text(parseDoubleUpto2Decimal('${data['diff'] ?? "-"}')))),
                        DataCell(Align(alignment: Alignment.centerRight,child: Text(parseDoubleUpto2Decimal('${data['diffPER'] ?? "-"}')))),

                      ]);
                    }).toList(),
                  )
                      : const SizedBox(),
                ),
              ),
            )),
      );
    });
  }
}
