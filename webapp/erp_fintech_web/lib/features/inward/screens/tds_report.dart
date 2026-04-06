import 'dart:convert';

import 'package:fintech_new_web/features/billReceipt/screen/hyperlink.dart';
import 'package:fintech_new_web/features/inward/provider/inward_provider.dart';
import 'package:fintech_new_web/features/reOrderBalanceMaterial/provider/re_order_balance_material_provider.dart';
import 'package:fintech_new_web/features/utility/services/common_utility.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:hexcolor/hexcolor.dart';

import '../../common/widgets/comman_appbar.dart';
import '../../common/widgets/pop_ups.dart';
import '../../network/service/network_service.dart';
import '../../utility/global_variables.dart';

class TdsReport extends StatefulWidget {
  static String routeName = "TdsReport";

  const TdsReport({super.key});

  @override
  State<TdsReport> createState() => _TdsReportState();
}

class _TdsReportState extends State<TdsReport> {
  @override
  void initState() {
    InwardProvider provider =
    Provider.of<InwardProvider>(context, listen: false);
    provider.getTdsReport();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<InwardProvider>(
        builder: (context, provider, child) {
          return Material(
            child: SafeArea(
                child: Scaffold(
                  appBar: PreferredSize(
                      preferredSize:
                      Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
                      child: const CommonAppbar(title: 'TDS Report')),
                  body: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Visibility(
                        visible: provider.tdsReport.isNotEmpty,
                        child: Column(
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
                                  downloadJsonToExcel(provider.tdsReport, "tds_export");
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
                              columnSpacing: 26,
                              columns: const [
                                DataColumn(label: Text("TransId")),
                                DataColumn(label: Text("Party Name")),
                                DataColumn(label: Text("Bill No.")),
                                DataColumn(label: Text("Bill Date")),
                                DataColumn(label: Text("Section")),
                                DataColumn(label: Text("Amount")),
                                DataColumn(label: Text("Discount\nAmount")),
                                DataColumn(label: Text("Tax\nAmount")),
                                DataColumn(label: Text("Cess\nAmount")),
                                DataColumn(label: Text("IGST\nAmount")),
                                DataColumn(label: Text("CGST\nAmount")),
                                DataColumn(label: Text("SGST\nAmount")),
                                DataColumn(label: Text("Round Off.")),
                                DataColumn(label: Text("Total\nAmount")),

                                DataColumn(label: Text("TDS Code")),
                                DataColumn(label: Text("TDS Rate")),
                                DataColumn(label: Text("TDS Amount")),
                              ],
                              rows: provider.rows,
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
