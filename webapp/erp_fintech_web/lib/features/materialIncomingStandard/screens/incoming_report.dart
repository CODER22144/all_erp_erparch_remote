import 'package:fintech_new_web/features/colorCode/provider/color_provider.dart';
import 'package:fintech_new_web/features/materialIncomingStandard/provider/material_incoming_standard_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../../common/widgets/comman_appbar.dart';
import '../../common/widgets/pop_ups.dart';
import '../../network/service/network_service.dart';

class IncomingReport extends StatefulWidget {
  static String routeName = "IncomingReport";

  const IncomingReport({super.key});

  @override
  State<IncomingReport> createState() => _IncomingReportState();
}

class _IncomingReportState extends State<IncomingReport> {
  @override
  void initState() {
    MaterialIncomingStandardProvider provider =
        Provider.of<MaterialIncomingStandardProvider>(context, listen: false);
    provider.getIncomingReadingReport();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MaterialIncomingStandardProvider>(
        builder: (context, provider, child) {
      return Material(
        child: SafeArea(
            child: Scaffold(
          appBar: PreferredSize(
              preferredSize:
                  Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
              child: const CommonAppbar(title: 'Material Incoming Reading')),
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: provider.incReport.isNotEmpty
                  ? DataTable(
                columnSpacing: 30,
                      columns: const [
                        DataColumn(
                            label: Text("GR No.",
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text("Date",
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text("Material No.",
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text("GR Qty",
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text("Size",
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text("Pass",
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text("Defect",
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text("Problem",
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text("Suggestion",
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text("Remark",
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text("UserID",
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: SizedBox()),
                        DataColumn(
                            label: SizedBox()),
                      ],
                      rows: provider.readingRows
                    )
                  : const SizedBox(),
            ),
          ),
        )),
      );
    });
  }
}
