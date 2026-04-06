import 'package:fintech_new_web/features/material/provider/material_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/widgets/comman_appbar.dart';
import '../../utility/services/common_utility.dart';
import '../provider/part_assembly_provider.dart';

class PartSearchReport extends StatefulWidget {
  static String routeName = "PartSearchReport";

  const PartSearchReport({super.key});

  @override
  State<PartSearchReport> createState() => _PartSearchReportState();
}

class _PartSearchReportState extends State<PartSearchReport> {
  @override
  void initState() {
    PartAssemblyProvider provider =
    Provider.of<PartAssemblyProvider>(context, listen: false);
    provider.getPartSearch();
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
                  child: const CommonAppbar(title: 'Part Search')),
              body: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: provider.searchReport.isNotEmpty ? Column(
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
                            downloadJsonToExcel(provider.searchReport, "part_search_export");
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
                          DataColumn(label: Text("Material no.")),
                          DataColumn(label: Text("Qty")),
                          DataColumn(label: Text("RM Type"))
                        ],
                        rows: provider.searchReport.map((data) {
                          return DataRow(cells: [
                            DataCell(Text('${data['matno'] ?? "-"}')),
                            DataCell(Text('${data['qty'] ?? "-"}')),
                            DataCell(Text('${data['rmType'] ?? "-"}')),
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
