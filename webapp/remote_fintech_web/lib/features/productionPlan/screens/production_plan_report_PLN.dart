import 'package:fintech_new_web/features/productionPlan/provider/production_plan_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/widgets/comman_appbar.dart';
import '../../utility/services/common_utility.dart';

class ProductionPlanReportPLN extends StatefulWidget {
  static String routeName = "ProductionPlanReportPLN";

  const ProductionPlanReportPLN({super.key});

  @override
  State<ProductionPlanReportPLN> createState() => _PartSearchReportPLNState();
}

class _PartSearchReportPLNState extends State<ProductionPlanReportPLN> {
  @override
  void initState() {
    ProductionPlanProvider provider =
    Provider.of<ProductionPlanProvider>(context, listen: false);
    provider.getReport();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductionPlanProvider>(builder: (context, provider, child) {
      return Material(
        child: SafeArea(
            child: Scaffold(
              appBar: PreferredSize(
                  preferredSize:
                  Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
                  child: const CommonAppbar(title: 'Production Plan Report')),
              body: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: provider.ppRep.isNotEmpty ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 180,
                        margin: const EdgeInsets.only(top: 10, left: 2),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.all(Radius.circular(5)),
                            ),
                          ),
                          onPressed: () async {
                            downloadJsonToExcel(provider.ppRep, "production_plan_export");
                          },
                          child: const Text(
                            'Export',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ),

                      DataTable(
                        columnSpacing: 20,
                        columns: const [
                          DataColumn(label: Text("Material No.")),
                          DataColumn(label: Text("Qty")),
                          DataColumn(label: Text("Ad. Qty")),
                          DataColumn(label: Text("Issue Qty")),
                        ],
                        rows: provider.ppRep.map((data) {
                          return DataRow(cells: [
                            DataCell(Text('${data['matno'] ?? "-"}')),
                            DataCell(Align(alignment: Alignment.centerRight,child: Text(parseDoubleUpto2Decimal('${data['qty']}')))),
                            DataCell(Align(alignment: Alignment.centerRight,child: Text(parseDoubleUpto2Decimal('${data['adQty']}')))),
                            DataCell(Align(alignment: Alignment.centerRight,child: Text(parseDoubleUpto2Decimal('${data['issueQty']}')))),
                          ]);
                        }).toList(),
                      ),
                    ],
                  ) : const SizedBox(),
                ),
              ),
            )),
      );
    });
  }
}
