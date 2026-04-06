import 'package:fintech_new_web/features/obalance/provider/oblance_provider.dart';
import 'package:fintech_new_web/features/salesOrder/provider/sales_order_provider.dart';
import 'package:fintech_new_web/features/utility/services/common_utility.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/widgets/comman_appbar.dart';

class ObalanceReport extends StatefulWidget {
  static String routeName = "ObalanceReport";

  const ObalanceReport({super.key});

  @override
  State<ObalanceReport> createState() => _ObalanceReportState();
}

class _ObalanceReportState extends State<ObalanceReport> {
  @override
  void initState() {
    super.initState();
    OBalanceProvider provider =
    Provider.of<OBalanceProvider>(context, listen: false);
    provider.getOBalanceReport();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OBalanceProvider>(builder: (context, provider, child) {
      return Material(
        child: SafeArea(
            child: Scaffold(
              appBar: PreferredSize(
                  preferredSize:
                  Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
                  child: const CommonAppbar(title: 'OBalance Report')),
              body: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: [
                        const DataColumn(label: Text("Trans Id")),
                        const DataColumn(label: Text("Balance Type")),
                        const DataColumn(label: Text("Part Code")),
                        const DataColumn(label: Text("Part Name")),
                        const DataColumn(label: Text("Bill No.")),
                        const DataColumn(label: Text("Bill Date")),
                        const DataColumn(label: Text("Naration")),
                        const DataColumn(label: Text("Bal Id")),
                        const DataColumn(label: Text("Debit")),
                        const DataColumn(label: Text("Credit")),
                        DataColumn(label: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.all(Radius.circular(5)),
                            ),
                          ),
                          onPressed: () async {
                            downloadJsonToExcel(provider.obalanceReport, "obalance_export");
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
