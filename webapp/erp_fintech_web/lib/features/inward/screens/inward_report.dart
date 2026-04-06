import 'package:fintech_new_web/features/inward/provider/inward_provider.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../common/widgets/comman_appbar.dart';
import '../../utility/global_variables.dart';
import '../../utility/services/common_utility.dart';

class InwardReport extends StatefulWidget {
  static String routeName = "InwardReport";

  const InwardReport({super.key});

  @override
  State<InwardReport> createState() => _InwardReportState();
}

class _InwardReportState extends State<InwardReport> {
  @override
  void initState() {
    super.initState();
    InwardProvider provider =
    Provider.of<InwardProvider>(context, listen: false);
    provider.getInwardBillReportTable(context);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<InwardProvider>(builder: (context, provider, child) {
      return Material(
        child: SafeArea(
            child: Scaffold(
              appBar: PreferredSize(
                  preferredSize:
                  Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
                  child: const CommonAppbar(title: 'Inward Bill Report')),
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
                              downloadJsonToExcel(provider.exportInward, "inward_bill_export");
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

                        provider.table
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
