import 'package:fintech_new_web/features/businessPartnerObMaterial/provider/bp_ob_material_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/widgets/comman_appbar.dart';
import '../../utility/services/common_utility.dart';

class BpObReport extends StatefulWidget {
  static String routeName = "BpObReport";

  const BpObReport({super.key});

  @override
  State<BpObReport> createState() => _BpObReportState();
}

class _BpObReportState extends State<BpObReport> {
  @override
  void initState() {
    BpObMaterialProvider provider = Provider.of<BpObMaterialProvider>(context, listen: false);
    provider.getBpOBMaterialReport();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BpObMaterialProvider>(builder: (context, provider, child) {
      return Material(
        child: SafeArea(
            child: Scaffold(
              appBar: PreferredSize(
                  preferredSize:
                  Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
                  child: const CommonAppbar(title: 'Business Partner OB Material Report')),
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
                            downloadJsonToExcel(provider.obReport, "business_partner_ob_material_export");
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
                          DataColumn(label: Text("Partner Code")),
                          DataColumn(label: Text("Partner Name")),
                          DataColumn(label: Text("Material No.")),
                          DataColumn(label: Text("Description")),
                          DataColumn(label: Text("Basic Rate")),
                          DataColumn(label: Text("Unit")),
                        ],
                        rows: provider.obReport.map((data) {
                          return DataRow(cells: [
                            DataCell(Text('${data['bpCode'] ?? "-"}')),
                            DataCell(Text('${data['bpName'] ?? "-"}')),
                            DataCell(Text('${data['matno'] ?? "-"}')),
                            DataCell(Text('${data['chrDescription'] ?? "-"}')),
                            DataCell(Align(alignment: Alignment.centerRight,child: Text(parseDoubleUpto2Decimal(parseDoubleUpto2Decimal(data['brate']))))),
                            DataCell(Text('${data['muUnit'] ?? "-"}')),
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
