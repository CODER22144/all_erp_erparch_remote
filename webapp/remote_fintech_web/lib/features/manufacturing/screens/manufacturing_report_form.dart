// ignore_for_file: use_build_context_synchronously
import 'package:fintech_new_web/features/manufacturing/provider/manufacturing_provider.dart';
import 'package:fintech_new_web/features/manufacturing/screens/manufacturing_report.dart';
import 'package:fintech_new_web/features/payment/provider/payment_provider.dart';
import 'package:fintech_new_web/features/payment/screens/bill_pending_report.dart';
import 'package:fintech_new_web/features/saleTransfer/provider/sale_transfer_provider.dart';
import 'package:fintech_new_web/features/saleTransfer/screens/payment_pending_report.dart';
import 'package:fintech_new_web/features/saleTransfer/screens/sale_payment_pending_report.dart';
import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

import '../../common/widgets/comman_appbar.dart';

class ManufacturingReportForm extends StatefulWidget {
  static String routeName = "ManufacturingReportForm";
  const ManufacturingReportForm({super.key});

  @override
  State<ManufacturingReportForm> createState() =>
      _ManufacturingReportFormState();
}

class _ManufacturingReportFormState extends State<ManufacturingReportForm> {
  @override
  void initState() {
    super.initState();
    ManufacturingProvider provider =
    Provider.of<ManufacturingProvider>(context, listen: false);
    provider.initReport();
  }

  @override
  Widget build(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    return Consumer<ManufacturingProvider>(
        builder: (context, provider, child) {
          return Scaffold(
            appBar: PreferredSize(
                preferredSize:
                Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
                child: const CommonAppbar(title: 'Manufacturing Report')),
            body: SingleChildScrollView(
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(width: 2, color: Colors.white54)),
                  padding: const EdgeInsets.only(
                      top: 10, bottom: 10, right: 20, left: 20),
                  width: kIsWeb
                      ? GlobalVariables.deviceWidth / 2.0
                      : GlobalVariables.deviceWidth,
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 5, bottom: 5),
                          child: ListView.builder(
                            itemCount: provider.reportWidgetList.length,
                            physics: const ClampingScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return provider.reportWidgetList[index];
                            },
                          ),
                        ),
                        Visibility(
                          visible: provider.reportWidgetList.isNotEmpty,
                          child: Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(bottom: 10),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: HexColor("#0B6EFE"),
                                  shape: const RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(5)))),
                              onPressed: () async {
                                context.pushNamed(ManufacturingReport.routeName);
                              },
                              child: const Text(
                                'Submit',
                                style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }
}
