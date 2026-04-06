import 'package:fintech_new_web/features/resources/provider/resource_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../common/widgets/comman_appbar.dart';
import '../../network/service/network_service.dart';

class ResourceReport extends StatefulWidget {
  static String routeName = "ResourceReport";

  const ResourceReport({super.key});

  @override
  State<ResourceReport> createState() => _ResourceReportState();
}

class _ResourceReportState extends State<ResourceReport> {
  @override
  void initState() {
    super.initState();
    ResourceProvider provider =
    Provider.of<ResourceProvider>(context, listen: false);
    provider.getResourceReport();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ResourceProvider>(builder: (context, provider, child) {
      return Material(
        child: SafeArea(
            child: Scaffold(
              appBar: PreferredSize(
                  preferredSize:
                  Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
                  child: const CommonAppbar(title: 'Resources Report')),
              body: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text("Name")),
                        DataColumn(label: Text("Login Id")),
                        DataColumn(label: Text("Designation")),
                        DataColumn(label: Text("Address")),
                        DataColumn(label: Text("State")),
                        DataColumn(label: Text("Country")),
                        DataColumn(label: Text("Pincode")),
                        DataColumn(label: Text("Contact No.")),
                        DataColumn(label: Text("Alternate Contact No.")),
                        DataColumn(label: Text("Email")),
                        DataColumn(label: Text("Alternate Email")),
                        DataColumn(label: Text("isLeader")),
                        DataColumn(label: Text("Leader Id")),
                        DataColumn(label: Text("Status")),
                        DataColumn(label: Text("Photo")),
                      ],
                      rows: provider.resources.map((data) {
                        return DataRow(cells: [
                          DataCell(Text('${data['resName'] ?? "-"}')),
                          DataCell(Text('${data['resLoginUserId'] ?? "-"}')),
                          DataCell(Text('${data['resDesignation'] ?? "-"}')),
                          DataCell(Text('${data['resAddress'] ?? "-"} ${data['resAddress1'] ?? ""}')),
                          DataCell(Text('${data['sname'] ?? "-"}')),
                          DataCell(Text('${data['c_name'] ?? "-"}')),
                          DataCell(Text('${data['resPinCode'] ?? "-"}')),
                          DataCell(Text('${data['resContactNo'] ?? "-"}')),
                          DataCell(Text('${data['resAltContactNo'] ?? "-"}')),
                          DataCell(Text('${data['resEmail'] ?? "-"}')),
                          DataCell(Text('${data['resAltEmail'] ?? "-"}')),
                          DataCell(Text('${data['isLeader'] ?? "-"}')),
                          DataCell(Text('${data['leaderId'] ?? "-"}')),
                          DataCell(Text('${data['resStatus'] ?? "-"}')),
                          DataCell(ElevatedButton(
                              onPressed: () async {
                                final Uri uri = Uri.parse("${NetworkService.baseUrl}${data['resPhotoUrl'] ?? ""}");
                                if (await canLaunchUrl(uri)) {
                                  await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
                                } else {
                                  throw 'Could not launch ${data['resPhotoUrl']}';
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: HexColor("#0038a8"),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(3), // Square shape
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                              ),
                              child: const Text(
                                "Photo",
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ))),

                        ]);
                      }).toList(),
                    ),
                  ),
                ),
              ),
            )),
      );
    });
  }
}
