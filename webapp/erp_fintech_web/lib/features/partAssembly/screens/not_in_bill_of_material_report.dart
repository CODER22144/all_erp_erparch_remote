import 'package:fintech_new_web/features/material/provider/material_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/widgets/comman_appbar.dart';
import '../../utility/services/common_utility.dart';
import '../provider/part_assembly_provider.dart';

class NotInBillOfMaterialReport extends StatefulWidget {
  static String routeName = "NotInBillOfMaterialReport";

  const NotInBillOfMaterialReport({super.key});

  @override
  State<NotInBillOfMaterialReport> createState() => _PartSearchReportState();
}

class _PartSearchReportState extends State<NotInBillOfMaterialReport> {
  @override
  void initState() {
    PartAssemblyProvider provider =
    Provider.of<PartAssemblyProvider>(context, listen: false);
    provider.getNotInBillOfMaterial();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PartAssemblyProvider>(builder: (context, provider, child) {
      return Material(
        child: SafeArea(
            child: Scaffold(
              appBar: PreferredSize(
                  preferredSize:
                  Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
                  child: const CommonAppbar(title: 'Not-In Bill Of Material')),
              body: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: provider.notInBom.isNotEmpty ? Column(
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
                            downloadJsonToExcel(provider.notInBom, "not_in_bill_of_material_export");
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
                          DataColumn(label: Text("SNo.")),
                          DataColumn(label: Text("Material No.")),
                          DataColumn(label: Text("Description")),
                          DataColumn(label: Text("Rate")),
                          DataColumn(label: Text("Unit")),
                          DataColumn(label: Text("Material Type")),
                          DataColumn(label: Text("Material Group")),
                        ],
                        rows: provider.notInBom.map((data) {
                          return DataRow(cells: [
                            DataCell(SizedBox(width:20,child: Text('${data['sno'] ?? "-"}'))),
                            DataCell(Text('${data['matno'] ?? "-"}')),
                            DataCell(Text('${data['matDescription'] ?? "-"}')),
                            DataCell(Align(alignment: Alignment.centerRight,child: Text(parseDoubleUpto2Decimal('${data['prate']}')))),
                            DataCell(Text('${data['puUnit'] ?? "-"}')),
                            DataCell(Text('${data['materialType'] ?? "-"}')),
                            DataCell(Text('${data['mgDescription'] ?? "-"}')),
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
