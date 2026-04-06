import 'package:fintech_new_web/features/salesOrder/provider/sales_order_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/widgets/comman_appbar.dart';
import '../../utility/services/common_utility.dart';

class SalesReport extends StatefulWidget {
  static String routeName = "SalesReport";

  const SalesReport({super.key});

  @override
  State<SalesReport> createState() => _SalesReportState();
}

class _SalesReportState extends State<SalesReport> {

  @override
  void initState() {
    super.initState();
    SalesOrderProvider provider =
    Provider.of<SalesOrderProvider>(context, listen: false);
    provider.getSalesReport();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SalesOrderProvider>(builder: (context, provider, child) {
      return Material(
        child: SafeArea(
            child: Scaffold(
              appBar: PreferredSize(
                  preferredSize:
                  Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
                  child: const CommonAppbar(title: 'Sales Report')),
              body: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
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
                              downloadJsonToExcel(provider.salesReport, "sales_export");
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
                            DataColumn(label: Text("Invoice No.")),
                            DataColumn(label: Text("Date")),
                            DataColumn(label: Text("Business Partner")),
                            DataColumn(label: Text("City")),
                            DataColumn(label: Text("State")),
                            DataColumn(label: Text("Supply Type")),
                            DataColumn(label: Text("Supplier Type")),
                            DataColumn(label: Text("Is IGST ?")),
                            DataColumn(label: Text("Amount")),
                            DataColumn(label: Text("GST Amount")),
                            DataColumn(label: Text("Total Amount")),
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
