import 'package:fintech_new_web/features/partAssembly/provider/part_assembly_provider.dart';
import 'package:fintech_new_web/features/utility/services/common_utility.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/widgets/comman_appbar.dart';

class WorkInProgressReport extends StatefulWidget {
  static const String routeName = "WorkInProgressReport";

  const WorkInProgressReport({super.key});

  @override
  State<WorkInProgressReport> createState() => _WorkInProgressReportState();
}

class _WorkInProgressReportState extends State<WorkInProgressReport> {
  @override
  void initState() {
    super.initState();
    PartAssemblyProvider provider =
        Provider.of<PartAssemblyProvider>(context, listen: false);
    provider.getWorkInProgress();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PartAssemblyProvider>(builder: (context, provider, child) {
      return Material(
        child: SafeArea(
            child: Scaffold(
          appBar: PreferredSize(
              preferredSize:
                  Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
              child: const CommonAppbar(title: 'Work In Progress Report')),
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Visibility(
                  visible: provider.wip.isNotEmpty,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [Container(
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
                          downloadJsonToExcel(provider.wip, "work_in_process_export");
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
                      columnSpacing: 30,
                      columns: const [
                        DataColumn(label: Text("Material No.")),
                        DataColumn(label: Text("Production")),
                        DataColumn(label: Text("Hold")),
                        DataColumn(label: Text("PACK")),
                        DataColumn(label: Text("Total Qty")),
                        DataColumn(label: Text("Amount")),
                      ],
                      rows: provider.rows,
                    ),
                  ],
                  ),
                ),
              ),
            ),
          ),
        )),
      );
    });
  }
}
