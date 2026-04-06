import 'package:fintech_new_web/features/dbNote/provider/dbnote_provider.dart';
import 'package:fintech_new_web/features/salesOrder/provider/sales_order_provider.dart';
import 'package:fintech_new_web/features/utility/services/common_utility.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/widgets/comman_appbar.dart';
import '../../network/service/network_service.dart';

class DbNoteReport extends StatefulWidget {
  static String routeName = "DbNoteReport";

  const DbNoteReport({super.key});

  @override
  State<DbNoteReport> createState() => _DbNoteReportState();
}

class _DbNoteReportState extends State<DbNoteReport> {

  @override
  void initState() {
    super.initState();
    DbNoteProvider provider =
    Provider.of<DbNoteProvider>(context, listen: false);
    provider.getDbNoteReport();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DbNoteProvider>(builder: (context, provider, child) {
      return Material(
        child: SafeArea(
            child: Scaffold(
              appBar: PreferredSize(
                  preferredSize:
                  Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
                  child: const CommonAppbar(title: 'Debit Note Report')),
              body: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columnSpacing: 25,
                      columns: const [
                        DataColumn(label: Text("Doc. No")),
                        DataColumn(label: Text("Doc. Date")),
                        DataColumn(label: Text("Party Code")),
                        DataColumn(label: Text("Party Address")),
                        DataColumn(label: Text("Zipcode")),
                        DataColumn(label: Text("GSTIN")),

                        DataColumn(label: Text("DR | DA")),
                        DataColumn(label: Text("Credit Code")),
                        DataColumn(label: Text("Supply Type")),


                        DataColumn(label: Text("Qty")),
                        DataColumn(label: Text("Amount")),
                        DataColumn(label: Text("Discount")),
                        DataColumn(label: Text("Ass. Amount")),
                        DataColumn(label: Text("Igst Amount")),
                        DataColumn(label: Text("Cgst Amount")),
                        DataColumn(label: Text("Sgst Amount")),
                        DataColumn(label: Text("Gst Amount")),
                        DataColumn(label: Text("Total Amount")),
                      ],
                      rows: provider.rows,
                    ),
                  ),
                ),
              ),
            )),
      );
    });
  }
}
