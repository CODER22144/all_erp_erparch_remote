// ignore_for_file: use_build_context_synchronously
import 'package:fintech_new_web/features/ledger/provider/ledger_provider.dart';
import 'package:fintech_new_web/features/ledger/screens/ledger_report.dart';
import 'package:fintech_new_web/features/reports/provider/report_provider.dart';
import 'package:fintech_new_web/features/reports/screens/trial_balance_report.dart';
import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../common/widgets/comman_appbar.dart';
import '../../network/service/network_service.dart';

class TrialBalanceReportForm extends StatefulWidget {
  static String routeName = "/TrialBalanceReportForm";
  const TrialBalanceReportForm({super.key});

  @override
  State<TrialBalanceReportForm> createState() => _TrialBalanceReportFormState();
}

class _TrialBalanceReportFormState extends State<TrialBalanceReportForm> {
  @override
  void initState() {
    super.initState();
    ReportProvider provider =
        Provider.of<ReportProvider>(context, listen: false);
    provider.initReportWidget();
  }

  @override
  Widget build(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    return Consumer<ReportProvider>(builder: (context, provider, child) {
      return Scaffold(
        appBar: PreferredSize(
            preferredSize:
                Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
            child: const CommonAppbar(title: 'Trial Balance Report')),
        body: SingleChildScrollView(
          child: Center(
            child: Container(
              width: kIsWeb
                  ? GlobalVariables.deviceWidth / 2.0
                  : GlobalVariables.deviceWidth,
              padding: const EdgeInsets.all(10),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 5, bottom: 5),
                      child: ListView.builder(
                        itemCount: provider.widgetList.length,
                        physics: const ClampingScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return provider.widgetList[index];
                        },
                      ),
                    ),
                    Visibility(
                      visible: provider.widgetList.isNotEmpty,
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
                            context.pushNamed(TrialBalanceReport.routeName);
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
