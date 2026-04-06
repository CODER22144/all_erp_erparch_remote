import 'package:fintech_new_web/features/gstReturn/provider/gst_return_provider.dart';
import 'package:fintech_new_web/features/material/provider/material_provider.dart';
import 'package:fintech_new_web/features/utility/services/common_utility.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/widgets/comman_appbar.dart';

class B2bNotInReport extends StatefulWidget {
  static String routeName = "B2bNotInReport";

  const B2bNotInReport({super.key});

  @override
  State<B2bNotInReport> createState() => _B2bNotInReportState();
}

class _B2bNotInReportState extends State<B2bNotInReport> {
  @override
  void initState() {
    GstReturnProvider provider =
    Provider.of<GstReturnProvider>(context, listen: false);
    provider.getB2bNotInReport();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GstReturnProvider>(builder: (context, provider, child) {
      return Material(
        child: SafeArea(
            child: Scaffold(
              appBar: PreferredSize(
                  preferredSize:
                  Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
                  child: const CommonAppbar(title: '2BB2B Not-In')),
              body: SingleChildScrollView(
                scrollDirection: Axis.vertical,
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
                            downloadJsonToExcel(provider.b2bNotIn['b2bdet'], "b2b_not_in_export");
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
                          DataColumn(label: Text("TransID")),
                          DataColumn(label: Text("Trans Date")),
                          DataColumn(label: Text("Party Name")),
                          DataColumn(label: Text("GSTIN")),
                          DataColumn(label: Text("Bill No.")),
                          DataColumn(label: Text("Bill Date")),
                          DataColumn(label: Text("Tax Amount")),
                          DataColumn(label: Text("Gst Amount")),
                          DataColumn(label: Text("Total Amount"))
                        ],
                        rows: provider.b2bNotInRows,
                      ),
                    ],
                  ),
                ),
              ),
            )),
      );
    });
  }
}
