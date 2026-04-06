import 'package:fintech_new_web/features/gr/provider/gr_provider.dart';
import 'package:fintech_new_web/features/obMaterial/provider/ob_material_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/widgets/comman_appbar.dart';
import '../../utility/services/common_utility.dart';

class ObMaterialReport extends StatefulWidget {
  static String routeName = "ObMaterialReport";

  const ObMaterialReport({super.key});

  @override
  State<ObMaterialReport> createState() => _ObMaterialReportState();
}

class _ObMaterialReportState extends State<ObMaterialReport> {
  @override
  void initState() {
    ObMaterialProvider provider = Provider.of<ObMaterialProvider>(context, listen: false);
    provider.getOBalanceReport();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ObMaterialProvider>(builder: (context, provider, child) {
      return Material(
        child: SafeArea(
            child: Scaffold(
              appBar: PreferredSize(
                  preferredSize:
                  Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
                  child: const CommonAppbar(title: 'OB Material Report')),
              body: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: provider.obReport.isNotEmpty
                      ? Column(
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
                            downloadJsonToExcel(provider.obReport, "ob_material_export");
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
                        columnSpacing: 30,
                        columns: const [
                          DataColumn(label: Text("Material No.")),
                          DataColumn(label: Text("Description")),
                          DataColumn(label: Text("Mat Grp.")),
                          DataColumn(label: Text("Basic Rate")),
                          DataColumn(label: Text("Scrap Rate")),
                          DataColumn(label: Text("Unit")),
                          DataColumn(label: Text("RM Type")),
                          DataColumn(label: Text("MRP")),
                          DataColumn(label: Text("OE Rate")),
                        ],
                        rows: provider.obReport.map((data) {
                          return DataRow(cells: [
                            DataCell(Text('${data['matno'] ?? "-"}')),
                            DataCell(Text('${data['chrDescription'] ?? "-"}')),
                            DataCell(Text('${data['materialGroup'] ?? "-"}\n${data['mgDescription'] ?? "-"}')),
                            DataCell(Align(alignment: Alignment.centerRight,child: Text(parseDoubleUpto2Decimal(parseDoubleUpto2Decimal(data['brate']))))),
                            DataCell(Align(alignment: Alignment.centerRight,child: Text(parseDoubleUpto2Decimal(parseDoubleUpto2Decimal(data['srate']))))),
                            DataCell(Text('${data['muUnit'] ?? "-"}')),
                            DataCell(Text('${data['rmType'] ?? "-"}')),
                            DataCell(Align(alignment: Alignment.centerRight,child: Text(parseDoubleUpto2Decimal(parseDoubleUpto2Decimal(data['mrp']))))),
                            DataCell(Align(alignment: Alignment.centerRight,child: Text(parseDoubleUpto2Decimal(parseDoubleUpto2Decimal(data['oerate']))))),
                          ]);
                        }).toList(),
                      ),
                    ],
                  )
                      : const SizedBox(),
                ),
              ),
            )),
      );
    });
  }
}
