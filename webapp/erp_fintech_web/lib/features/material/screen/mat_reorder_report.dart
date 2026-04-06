import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/widgets/comman_appbar.dart';
import '../../utility/services/common_utility.dart';
import '../provider/material_provider.dart';

class MatReorderReport extends StatefulWidget {
  static const String routeName = "MatReorderReport";

  const MatReorderReport({super.key});

  @override
  State<MatReorderReport> createState() => _MatReorderReportState();
}

class _MatReorderReportState extends State<MatReorderReport> {
  @override
  void initState() {
    super.initState();
    MaterialProvider provider =
    Provider.of<MaterialProvider>(context, listen: false);
    provider.getMaterialMinMaxReport();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MaterialProvider>(builder: (context, provider, child) {
      return Material(
        child: SafeArea(
            child: Scaffold(
              appBar: PreferredSize(
                  preferredSize:
                  Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
                  child: const CommonAppbar(title: 'Material Min/Max')),
              body: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Visibility(
                      visible: provider.matReorderRep.isNotEmpty,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 5),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(5)),
                              ),
                            ),
                            onPressed: () async {
                              downloadJsonToExcel(provider.matReorderRep, "material_min_max_export");
                            },
                            child: const Text(
                              'Export',
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                          ),
                          const SizedBox(height: 10),
                          DataTable(
                            columns: const [
                              DataColumn(label: Text("Material No.")),
                              DataColumn(label: Text("Description")),
                              DataColumn(label: Text("Min Level")),
                              DataColumn(label: Text("Max Level")),
                              DataColumn(label: Text("Qty In Stock")),
                              DataColumn(label: Text("PoBalQty")),
                            ],
                            rows: provider.matReorderRep.map((data) {
                              return DataRow(cells: [
                                DataCell(Text('${data['matno'] ?? "-"}')),
                                DataCell(Text('${data['matDescription'] ?? "-"}')),
                                DataCell(Align(alignment: Alignment.centerRight,child: Text('${data['minLevel'] ?? "-"}'))),
                                DataCell(Align(alignment: Alignment.centerRight,child: Text('${data['maxLevel'] ?? "-"}'))),
                                DataCell(Align(alignment: Alignment.centerRight,child: Text('${data['qtyinstock'] ?? "-"}'))),
                                DataCell(Align(alignment: Alignment.centerRight,child: Text('${data['pobalqty'] ?? "-"}'))),
                              ]);
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )),
      );
    });
  }
}
