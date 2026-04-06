import 'dart:convert';

import 'package:flutter/material.dart';
import '../../common/widgets/comman_appbar.dart';
import '../../utility/services/common_utility.dart';

class AdvanceReqReport extends StatefulWidget {
  static String routeName = "AdvanceReqReport";
  final String reportData;
  const AdvanceReqReport({super.key, required this.reportData});

  @override
  State<AdvanceReqReport> createState() => _AdvanceReqReportState();
}

class _AdvanceReqReportState extends State<AdvanceReqReport> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
          child: Scaffold(
        appBar: PreferredSize(
            preferredSize:
                Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
            child: const CommonAppbar(title: 'Advance Requirement')),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  const DataColumn(label: Text("Material No.")),
                  const DataColumn(label: Text("Required Qty")),
                  const DataColumn(label: Text("Stock Qty")),
                  const DataColumn(label: Text("Balance Qty")),
                  DataColumn(
                      label: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                    ),
                    onPressed: () async {
                      downloadJsonToExcel(jsonDecode(widget.reportData),
                          "advance_requirement_export");
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
                rows: List<dynamic>.from(jsonDecode(widget.reportData)).map((data) {
                  return DataRow(cells: [
                    DataCell(Text('${data['matno'] ?? "-"}')),
                    DataCell(Align(
                        alignment: Alignment.centerRight,
                        child: Text(parseDoubleUpto2Decimal(data['rqty'])))),
                    DataCell(Align(
                        alignment: Alignment.centerRight,
                        child: Text(parseDoubleUpto2Decimal(data['qtyinstock'])))),
                    DataCell(Align(
                        alignment: Alignment.centerRight,
                        child: Text(parseDoubleUpto2Decimal(data['bqty'])))),
                    const DataCell(SizedBox())
                  ]);
                }).toList(),
              ),
            ),
          ),
        ),
      )),
    );
  }
}
