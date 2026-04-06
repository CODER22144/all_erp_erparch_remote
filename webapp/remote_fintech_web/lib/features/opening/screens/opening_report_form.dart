// ignore_for_file: use_build_context_synchronously
import 'package:fintech_new_web/features/carrier/provider/carrier_provider.dart';
import 'package:fintech_new_web/features/carrier/screens/carrier_report.dart';
import 'package:fintech_new_web/features/dlChallan/provider/dl_challan_provider.dart';
import 'package:fintech_new_web/features/dlChallan/screens/dl_challan_report.dart';
import 'package:fintech_new_web/features/jobWorkOut/screens/job_workout_report.dart';
import 'package:fintech_new_web/features/opening/provider/opening_provider.dart';
import 'package:fintech_new_web/features/opening/screens/opening_report.dart';
import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

import '../../common/widgets/comman_appbar.dart';

class OpeningReportForm extends StatefulWidget {
  static String routeName = "OpeningReportForm";
  const OpeningReportForm({super.key});

  @override
  State<OpeningReportForm> createState() =>
      _OpeningReportFormState();
}

class _OpeningReportFormState extends State<OpeningReportForm> {
  @override
  void initState() {
    super.initState();
    OpeningProvider provider =
    Provider.of<OpeningProvider>(context, listen: false);
    provider.initReport();
  }

  @override
  Widget build(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    return Consumer<OpeningProvider>(
        builder: (context, provider, child) {
          return Scaffold(
            appBar: PreferredSize(
                preferredSize:
                Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
                child: const CommonAppbar(title: 'Opening Report')),
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
                                      BorderRadius.all(Radius.circular(1)))),
                              onPressed: () async {
                                context.pushNamed(OpeningReport.routeName);
                              },
                              child: const Text(
                                'Submit',
                                style: TextStyle(
                                    fontSize: 16,
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
