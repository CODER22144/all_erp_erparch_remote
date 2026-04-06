import 'package:fintech_new_web/features/businessPartnerOnBoard/provider/business_partner_on_board_provider.dart';
import 'package:fintech_new_web/features/gr/provider/gr_provider.dart';
import 'package:fintech_new_web/features/obMaterial/provider/ob_material_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/widgets/comman_appbar.dart';
import '../../utility/services/common_utility.dart';

class BpOnBoardReport extends StatefulWidget {
  static String routeName = "BpOnBoardReport";

  const BpOnBoardReport({super.key});

  @override
  State<BpOnBoardReport> createState() => _BpOnBoardReportState();
}

class _BpOnBoardReportState extends State<BpOnBoardReport> {
  @override
  void initState() {
    BusinessPartnerOnBoardProvider provider = Provider.of<BusinessPartnerOnBoardProvider>(context, listen: false);
    provider.getBpOnBoardReport();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BusinessPartnerOnBoardProvider>(builder: (context, provider, child) {
      return Material(
        child: SafeArea(
            child: Scaffold(
              appBar: PreferredSize(
                  preferredSize:
                  Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
                  child: const CommonAppbar(title: 'Business Partner OnBoard Report')),
              body: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: provider.bpOnBoardReport.isNotEmpty
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
                            downloadJsonToExcel(provider.bpOnBoardReport, "business_partner_on_board_export");
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
                          DataColumn(label: Text("Partner Name")),
                          DataColumn(label: Text("GSTIN")),
                          DataColumn(label: Text("Address")),
                          DataColumn(label: Text("Phone")),
                          DataColumn(label: Text("WhatsApp")),
                          DataColumn(label: Text("Email")),
                          DataColumn(label: Text("Contact Person")),
                          DataColumn(label: Text("Designation")),
                        ],
                        rows: provider.bpOnBoardReport.map((data) {
                          return DataRow(cells: [
                            DataCell(Text('${data['bpCode'] ?? "-"} - ${data['bpName'] ?? "-"}', maxLines: 2)),
                            DataCell(Text('${data['bpGSTIN'] ?? "-"}')),
                            DataCell(Text('${data['bpAdd'] ?? "-"}, ${data['bpAdd1'] ?? ""}\n${data['bpCity'] ?? ""} - ${data['bpStateName'] ?? "-"}, ${data['bpCountryName'] ?? "-"}', maxLines: 3,)),
                            DataCell(Text('${data['bpPhone'] ?? "-"}')),
                            DataCell(Text('${data['bpWhatsApp'] ?? "-"}')),
                            DataCell(Text('${data['bpEmail'] ?? "-"}')),
                            DataCell(Text('${data['contactPerson'] ?? "-"}')),
                            DataCell(Text('${data['designation'] ?? "-"}'))
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
