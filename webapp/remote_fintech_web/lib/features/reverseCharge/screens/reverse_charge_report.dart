import 'dart:convert';

import 'package:fintech_new_web/features/ledgerCodes/provider/ledger_codes_provider.dart';
import 'package:fintech_new_web/features/ledgerCodes/screen/ledger_codes.dart';
import 'package:fintech_new_web/features/ledgerCodes/screen/ledger_details_page.dart';
import 'package:fintech_new_web/features/reverseCharge/provider/reverse_charge_provider.dart';
import 'package:fintech_new_web/features/reverseCharge/screens/add_reverse_charge.dart';
import 'package:fintech_new_web/features/reverseCharge/screens/rcm_info.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

import '../../common/widgets/comman_appbar.dart';
import '../../common/widgets/pop_ups.dart';
import '../../network/service/network_service.dart';
import '../../utility/services/common_utility.dart';

class ReverseChargeReport extends StatefulWidget {
  static String routeName = "ReverseChargeReport";

  const ReverseChargeReport({super.key});

  @override
  State<ReverseChargeReport> createState() => _ReverseChargeReportState();
}

class _ReverseChargeReportState extends State<ReverseChargeReport> {
  @override
  void initState() {
    super.initState();
    ReverseChargeProvider provider =
        Provider.of<ReverseChargeProvider>(context, listen: false);
    provider.getRcmReport(context);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ReverseChargeProvider>(builder: (context, provider, child) {
      return Material(
        child: SafeArea(
            child: Scaffold(
          appBar: PreferredSize(
              preferredSize:
                  Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
              child: const CommonAppbar(title: 'RCM Report')),
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    DataTable(
                      columns: [
                        const DataColumn(label: Text("")),
                        const DataColumn(label: Text("")),
                        const DataColumn(label: Text("")),
                        const DataColumn(label: Text("")),
                        const DataColumn(label: Text("")),
                        const DataColumn(label: Text("")),
                        const DataColumn(label: Text("")),
                        const DataColumn(label: Text("")),
                        DataColumn(
                            label: Row(
                          children: [
                            Container(
                              decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(5),
                                      bottomLeft: Radius.circular(5)),
                                  color: Colors.green),
                              child: IconButton(
                                icon: const Icon(Icons.add),
                                color: Colors.white,
                                tooltip: 'Add',
                                onPressed: () {
                                  context.pushNamed(AddReverseCharge.routeName);
                                },
                              ),
                            ),
                            Container(
                              decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(5),
                                      bottomRight: Radius.circular(5)),
                                  color: Colors.blue),
                              child: IconButton(
                                icon: const Icon(Icons.exit_to_app_outlined),
                                color: Colors.white,
                                tooltip: 'Export',
                                onPressed: () {
                                  downloadJsonToExcel(
                                      provider.rcmRep, "rcm_export");
                                },
                              ),
                            )
                          ],
                        )),
                      ],
                      rows: const [],
                    ),
                    DataTable(
                      columnSpacing: 25,
                      columns: const [
                        DataColumn(
                            label: Text("No",
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text("Bill No. & Date",
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text("Party Name",
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text("ITC Eligible",
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text("Material No.",
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text("Naration",
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text("HSN Code",
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text("Quantity",
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text("Unit",
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text("Rate",
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text("Ass Amount",
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text("Gst Rate",
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text("Gst Amount",
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text("IgstOnIntra",
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text("IGST Amt",
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text("CGST Amt",
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text("SGST Amt",
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text("Total Amt",
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text("Actions",
                                style: TextStyle(fontWeight: FontWeight.bold))),
                      ],
                      rows: provider.rcmRows,
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
