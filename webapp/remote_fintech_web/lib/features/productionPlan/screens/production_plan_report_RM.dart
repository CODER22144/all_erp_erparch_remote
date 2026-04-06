import 'package:fintech_new_web/features/productionPlan/provider/production_plan_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/widgets/comman_appbar.dart';
import '../../utility/services/common_utility.dart';

class ProductionPlanReportRm extends StatefulWidget {
  static String routeName = "ProductionPlanReportRm";
  const ProductionPlanReportRm({super.key});

  @override
  State<ProductionPlanReportRm> createState() => _ProductionPlanReportRmState();
}

class _ProductionPlanReportRmState extends State<ProductionPlanReportRm> {
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
                          DataColumn(label: Text("Description")),
                          DataColumn(label: Text("Qty")),
                          DataColumn(label: Text("Unit")),
                          DataColumn(label: Text("Material Type")),
                        ],
                        rows: provider.ppRep.map((data) {
                          return DataRow(cells: [
                            DataCell(Text('${data['matno'] ?? "-"}')),
                            DataCell(Text('${data['matDescription'] ?? "-"}')),
                            DataCell(Align(alignment: Alignment.centerRight,child: Text(parseDoubleUpto2Decimal('${data['qty']}')))),
                            DataCell(Text('${data['puUnit'] ?? "-"}')),
                            DataCell(Text('${data['materialType'] ?? "-"}')),
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
