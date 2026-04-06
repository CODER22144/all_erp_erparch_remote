import 'dart:convert';

import 'package:fintech_new_web/features/material/provider/material_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/widgets/comman_appbar.dart';
import '../../utility/services/common_utility.dart';

class QueryReport extends StatefulWidget {
  static String routeName = "QueryReport";
  final String details;
  const QueryReport({super.key, required this.details});

  @override
  State<QueryReport> createState() => _QueryReportState();
}

class _QueryReportState extends State<QueryReport> {

  @override
  Widget build(BuildContext context) {
    var data = jsonDecode(widget.details);
    final headers = List<String>.from(data['headers']);
    final rows = List<Map<String, dynamic>>.from(data['data']);

    return Scaffold(
      appBar: AppBar(title: const Text("Query Report")),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal, // allow horizontal scroll
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () {
                  downloadJsonToExcel(
                      rows, "query_export");
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(1),
                  ),
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(200, 50),
                ),
                child: const Text('Export',
                    style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
              DataTable(
                headingRowColor: WidgetStateProperty.all(Colors.grey[300]),
                columns: headers
                    .map((header) => DataColumn(label: Text(header)))
                    .toList(),
                rows: rows
                    .map(
                      (row) => DataRow(
                    cells: headers
                        .map(
                          (header) => DataCell(Text(row[header].toString())),
                    )
                        .toList(),
                  ),
                )
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
