import 'package:fintech_new_web/features/inward/provider/inward_provider.dart';
import 'package:fintech_new_web/features/inward/screens/inward.dart';
import 'package:fintech_new_web/features/salesOrderNew/provider/sales_order_new_provider.dart';
import 'package:fintech_new_web/features/salesOrderNew/screens/sales_order_new_details.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../../common/widgets/comman_appbar.dart';
import '../../utility/services/common_utility.dart';

class SalesOrderNewReport extends StatefulWidget {
  static String routeName = "SalesOrderNewReport";

  const SalesOrderNewReport({super.key});

  @override
  State<SalesOrderNewReport> createState() => _SalesOrderNewReportState();
}

class _SalesOrderNewReportState extends State<SalesOrderNewReport> {
  @override
  void initState() {
    super.initState();
    SalesOrderNewProvider provider =
        Provider.of<SalesOrderNewProvider>(context, listen: false);
    provider.getSalesOrderNewReport(context);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SalesOrderNewProvider>(builder: (context, provider, child) {
      return Material(
        child: SafeArea(
            child: Scaffold(
          appBar: PreferredSize(
              preferredSize:
                  Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
              child: const CommonAppbar(title: 'Sale Report')),
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
                      visible: provider.salesRep.isNotEmpty,
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
                                    context.pushNamed(
                                        SalesOrderNewDetails.routeName);
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
                                  icon: const Icon(Icons.exit_to_app_outlined),
                                  color: Colors.white,
                                  tooltip: 'Export',
                                  onPressed: () {
                                    downloadJsonToExcel(
                                        provider.salesRep, "sale_export");
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
