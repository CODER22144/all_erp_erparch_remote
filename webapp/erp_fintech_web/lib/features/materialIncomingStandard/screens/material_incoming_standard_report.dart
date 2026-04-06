import 'package:fintech_new_web/features/materialIncomingStandard/provider/material_incoming_standard_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../../common/widgets/comman_appbar.dart';
import '../../common/widgets/pop_ups.dart';
import '../../network/service/network_service.dart';

class MaterialIncomingStandardReport extends StatefulWidget {
  static String routeName = "MaterialIncomingStandardReport";

  const MaterialIncomingStandardReport({super.key});

  @override
  State<MaterialIncomingStandardReport> createState() =>
      _MaterialIncomingStandardReportState();
}

class _MaterialIncomingStandardReportState
    extends State<MaterialIncomingStandardReport> {
  @override
  void initState() {
    super.initState();
    MaterialIncomingStandardProvider provider =
        Provider.of<MaterialIncomingStandardProvider>(context, listen: false);
    provider.getMaterialIncomingStandardReport(context);
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
              child: const CommonAppbar(
                  title: 'Material Incoming Standard Report')),
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text("Material No.", style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text("Serial No.", style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text("Test Type", style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text("Inspect Item", style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text("Instrument Name", style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text("Standard Limit", style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text("Lower Limit", style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text("Higher Limit", style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text("")),
                  ],
                  rows: provider.dataRows,
                ),
              ),
            ),
          ),
        )),
      );
    });
  }
}
