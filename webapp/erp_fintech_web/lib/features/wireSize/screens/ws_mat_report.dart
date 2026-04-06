import 'package:fintech_new_web/features/wireSize/provider/wire_size_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/widgets/comman_appbar.dart';
import '../../network/service/network_service.dart';
import '../../utility/services/common_utility.dart';

class WsMatReport extends StatefulWidget {
  static String routeName = "WsMatReport";

  const WsMatReport({super.key});

  @override
  State<WsMatReport> createState() => _WsMatReportState();
}

class _WsMatReportState extends State<WsMatReport> {
  @override
  void initState() {
    WireSizeProvider provider =
        Provider.of<WireSizeProvider>(context, listen: false);
    provider.getWsMaterialRep();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WireSizeProvider>(builder: (context, provider, child) {
      return Material(
        child: SafeArea(
            child: Scaffold(
          appBar: PreferredSize(
              preferredSize:
                  Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
              child: const CommonAppbar(title: 'Wire Size Material')),
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: provider.wsMatReport.isNotEmpty
                  ? DataTable(
                      columns: [
                        const DataColumn(label: Text("Part No.")),
                        const DataColumn(label: Text("Qty")),
                        const DataColumn(label: Text("Unit")),
                        DataColumn(
                            label: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                            ),
                          ),
                          onPressed: () async {
                            downloadJsonToExcel(provider.wsMatReport,
                                "wire_size_material_export");
                          },
                          child: const Text(
                            'Export',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        )),
                      ],
                      rows: provider.wsMatReport.map((data) {
                        return DataRow(cells: [
                          DataCell(Text('${data['partno'] ?? "-"}')),
                          DataCell(Text('${data['qty'] ?? "-"}')),
                          DataCell(Text('${data['muUnit'] ?? "-"}')),
                          const DataCell(SizedBox()),
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
