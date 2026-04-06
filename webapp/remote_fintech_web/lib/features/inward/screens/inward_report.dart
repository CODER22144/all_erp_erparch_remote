import 'package:fintech_new_web/features/inward/provider/inward_provider.dart';
import 'package:fintech_new_web/features/inward/screens/inward.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../../common/widgets/comman_appbar.dart';
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
                  child: const CommonAppbar(title: 'Inward Report')),
              body: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Visibility(
                          visible: provider.exportInward.isNotEmpty,
                          child: DataTable(
                            columns: [
                              const DataColumn(label: Text("")),
                              const DataColumn(label: Text("")),
                              const DataColumn(label: Text("")),
                              const DataColumn(label: Text("")),
                              const DataColumn(label: Text("")),
                              DataColumn(
                                  label: Row(
                                    children: [
                                      Container(
                                        decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(5),
                                                bottomLeft: Radius.circular(5)),
                                            color: Colors.green),
                                        child: IconButton(
                                          icon: const Icon(Icons.add),
                                          color: Colors.white,
                                          tooltip: 'Add',
                                          onPressed: () {
                                            context.pushNamed(InwardDetails.routeName);
                                          },
                                        ),
                                      ),
                                      Container(
                                        decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(5),
                                                bottomRight: Radius.circular(5)),
                                            color: Colors.blue),
                                        child: IconButton(
                                          icon:
                                          const Icon(Icons.exit_to_app_outlined),
                                          color: Colors.white,
                                          tooltip: 'Export',
                                          onPressed: () {
                                            downloadJsonToExcel(
                                                provider.exportInward, "inward_export");
                                          },
                                        ),
                                      )
                                    ],
                                  )),
                            ],
                            rows: const [],
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
