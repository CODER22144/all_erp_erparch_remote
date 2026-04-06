import 'package:fintech_new_web/features/gstReturn/provider/gst_return_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/widgets/comman_appbar.dart';
import '../../utility/services/common_utility.dart';

class B2bNoMatchReport extends StatefulWidget {
  static String routeName = "2BB2bNoMatchReport";
  const B2bNoMatchReport({super.key});

  @override
  State<B2bNoMatchReport> createState() => _B2bNoMatchReportState();
}

class _B2bNoMatchReportState extends State<B2bNoMatchReport> {

  @override
  void initState() {
    super.initState();
    GstReturnProvider provider =
    Provider.of<GstReturnProvider>(context, listen: false);
    provider.getB2bNoMatchReport(context);
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
                  child: const CommonAppbar(title: '2BB2B No Match')),
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
                              downloadJsonToExcel(provider.b2bNoMatch['b2bdet'], "b2b_no_match_export");
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

                        Visibility(
                          visible: provider.b2bNoMatch.isNotEmpty,
                          child: DataTable(
                            columnSpacing: 30,
                            columns: const [
                              DataColumn(label: Text("TransId")),
                              DataColumn(label: Text("Match Id")),
                              DataColumn(label: Text("Trade Name")),
                              DataColumn(label: Text("Doc No.")),
                              DataColumn(label: Text("Doc Date")),
                              DataColumn(label: Text("Filing Date")),
                              DataColumn(label: Text("Rev")),
                              DataColumn(label: Text("Value")),
                              DataColumn(label: Text("Tax Value")),
                              DataColumn(label: Text("IGST")),
                              DataColumn(label: Text("CGST")),
                              DataColumn(label: Text("SGST")),
                              DataColumn(label: Text("Cess")),
                              DataColumn(label: Text("")),
                            ],
                            rows: provider.b2bRows,
                          ),
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
