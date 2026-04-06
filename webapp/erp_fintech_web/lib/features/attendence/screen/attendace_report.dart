import 'package:fintech_new_web/features/attendence/provider/attendance_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/widgets/comman_appbar.dart';

class AttendanceReport extends StatefulWidget {
  static String routeName = "attendanceReport";

  const AttendanceReport({super.key});

  @override
  State<AttendanceReport> createState() => _AttendanceReportState();
}

class _AttendanceReportState extends State<AttendanceReport> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AttendanceProvider>(builder: (context, provider, child) {
      return Material(
        child: SafeArea(
            child: Scaffold(
          appBar: PreferredSize(
              preferredSize:
                  Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
              child: const CommonAppbar(title: 'Attendance Report')),
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text("User ID")),
                    DataColumn(label: Text("Check-In Date")),
                    DataColumn(label: Text("Time In")),
                    DataColumn(label: Text("Time Out")),
                    DataColumn(label: Text("Check-In Location")),
                    DataColumn(label: Text("Check-Out Location")),
                  ],
                  rows: provider.attendanceReport.map((data) {
                    return DataRow(cells: [
                      DataCell(Text('${data['userId']}')),
                      DataCell(Text('${data['checkInDate']}')),
                      DataCell(Text('${data['TimeIn']}')),
                      DataCell(Text('${data['TimeOut']}')),
                      DataCell(Text('${data['geoCheckIn']}')),
                      DataCell(Text("${data['geoCheckOut']}"))
                    ]);
                  }).toList(),
                ),
              ),
            ),
          ),
        )),
      );
    });
  }
}
