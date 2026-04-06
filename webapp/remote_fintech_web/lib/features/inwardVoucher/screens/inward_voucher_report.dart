import 'package:fintech_new_web/features/inwardVoucher/screens/create_inward_voucher.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../../common/widgets/comman_appbar.dart';
import '../../utility/global_variables.dart';
import '../../utility/services/common_utility.dart';
import '../provider/inward_voucher_provider.dart';

class InwardVoucherReport extends StatefulWidget {
  static String routeName = "InwardVoucherReport";

  const InwardVoucherReport({super.key});

  @override
  State<InwardVoucherReport> createState() => _InwardVoucherReportState();
}

class _InwardVoucherReportState extends State<InwardVoucherReport> {
  @override
  void initState() {
    super.initState();
    InwardVoucherProvider provider =
    Provider.of<InwardVoucherProvider>(context, listen: false);
    provider.getInwardBillReportTable(context);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<InwardVoucherProvider>(builder: (context, provider, child) {
      return Material(
        child: SafeArea(
            child: Scaffold(
              appBar: PreferredSize(
                  preferredSize:
                  Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
                  child: const CommonAppbar(title: 'Inward Voucher Report')),
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
                                            context.pushNamed(CreateInwardVoucher.routeName);
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
