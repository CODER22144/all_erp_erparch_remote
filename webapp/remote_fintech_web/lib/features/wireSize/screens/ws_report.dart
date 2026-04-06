import 'package:fintech_new_web/features/wireSize/provider/wire_size_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../common/widgets/comman_appbar.dart';
import '../../network/service/network_service.dart';
import '../../utility/services/common_utility.dart';

class WsReport extends StatefulWidget {
  static String routeName = "WsReport";

  const WsReport({super.key});

  @override
  State<WsReport> createState() => _WsReportState();
}

class _WsReportState extends State<WsReport> {
  @override
  void initState() {
    WireSizeProvider provider =
        Provider.of<WireSizeProvider>(context, listen: false);
    provider.getWireSizeReport();
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
              child: const CommonAppbar(title: 'Wire Size Report')),
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: provider.wsReport.isNotEmpty
                  ? DataTable(
                      columns: [
                        const DataColumn(label: Text("Material No.")),
                        const DataColumn(label: Text("Mat. Drawing")),
                        const DataColumn(label: Text("Joint Drawing")),
                        const DataColumn(label: Text("Cost Status")),
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
                            downloadJsonToExcel(
                                provider.wsReport, "wire_size_export");
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
                      rows: provider.wsReport.map((data) {
                        return DataRow(cells: [
                          DataCell(Text('${data['matno'] ?? "-"}')),
                          DataCell(Visibility(
                            visible: data['matDrawing'] != null,
                            child: ElevatedButton(
                                onPressed: () async {
                                  final Uri uri = Uri.parse("${NetworkService.baseUrl}${data['matDrawing'] ?? ""}");
                                  if (await canLaunchUrl(uri)) {
                                    await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
                                  } else {
                                    throw 'Could not launch url';
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blueAccent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(3), // Square shape
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                                ),
                                child: const Text(
                                  "Mat. Drawing",
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                )),
                          )),
                          DataCell(Visibility(
                            visible: data['jointDrawing'] != null,
                            child: ElevatedButton(
                                onPressed: () async {
                                  final Uri uri = Uri.parse("${NetworkService.baseUrl}${data['jointDrawing'] ?? ""}");
                                  if (await canLaunchUrl(uri)) {
                                    await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
                                  } else {
                                    throw 'Could not launch url';
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blueAccent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(3), // Square shape
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                                ),
                                child: const Text(
                                  "Joint Drawing",
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                )),
                          )),

                          DataCell(Text('${data['csId'] ?? "-"}')),
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
