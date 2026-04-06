import 'package:fintech_new_web/features/jobWorkOutClear/provider/job_work_out_clear_provider.dart';
import 'package:fintech_new_web/features/materialAssembly/provider/material_assembly_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/widgets/comman_appbar.dart';
import '../../utility/services/common_utility.dart';

class MatAssemblyComparisonReport extends StatefulWidget {
  static String routeName = "MatAssemblyComparisonReport";

  const MatAssemblyComparisonReport({super.key});

  @override
  State<MatAssemblyComparisonReport> createState() =>
      _MatAssemblyComparisonReportState();
}

class _MatAssemblyComparisonReportState
    extends State<MatAssemblyComparisonReport> {
  @override
  void initState() {
    super.initState();
    MaterialAssemblyProvider provider =
        Provider.of<MaterialAssemblyProvider>(context, listen: false);
    provider.getMatAssemblyComparison();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MaterialAssemblyProvider>(
        builder: (context, provider, child) {
      return Material(
        child: SafeArea(
            child: Scaffold(
          appBar: PreferredSize(
              preferredSize:
                  Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
              child: const CommonAppbar(title: 'Material Assembly Comparison')),
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
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
                          downloadJsonToExcel(provider.matComp, "material_assembly_comparison_export");
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
                      columns: const [
                        DataColumn(label: Text("Material No.", style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text("Description", style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text("Raw Material. Type", style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text("Rate", style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text("MRP", style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text("Total Amount", style: TextStyle(fontWeight: FontWeight.bold))),
                      ],
                      rows: provider.matComp.map((data) {
                        return DataRow(cells: [
                          DataCell(Text('${data['matno'] ?? "-"}')),
                          DataCell(Text('${data['chrDescription'] ?? "-"}')),
                          DataCell(Text('${data['rmType'] ?? "-"}')),
                          DataCell(Align(
                              alignment: Alignment.centerRight,
                              child: Text(parseDoubleUpto2Decimal('${data['prate'] ?? "-"}')))),
                          DataCell(Align(
                              alignment: Alignment.centerRight,
                              child: Text(parseDoubleUpto2Decimal('${data['mrp'] ?? "-"}')))),
                          DataCell(Align(
                              alignment: Alignment.centerRight,
                              child: Text(parseDoubleUpto2Decimal('${data['tamount'] ?? "-"}')))),
                        ]);
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        )),
      );
    });
  }
}
