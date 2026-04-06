// ignore_for_file: use_build_context_synchronously
import 'dart:convert';

import 'package:fintech_new_web/features/attendence/provider/attendance_provider.dart';
import 'package:fintech_new_web/features/billPayable/provider/bill_payable_provider.dart';
import 'package:fintech_new_web/features/billReceivable/provider/bill_receivable_provider.dart';
import 'package:fintech_new_web/features/bpPayNTaxInfo/provider/bpTaxInfoProvider.dart';
import 'package:fintech_new_web/features/visitInfo/provider/visit_info_provider.dart';
import 'package:fintech_new_web/features/visitInfo/screens/visit_info_report.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../common/widgets/comman_appbar.dart';
import '../../common/widgets/pop_ups.dart';
import '../../home.dart';
import '../../utility/global_variables.dart';

class GetVisitInfoReport extends StatefulWidget {
  static String routeName = "/get-visit-report";
  const GetVisitInfoReport({super.key});

  @override
  State<GetVisitInfoReport> createState() => _GetVisitInfoReportState();
}

class _GetVisitInfoReportState extends State<GetVisitInfoReport> {
  @override
  void initState() {
    super.initState();
    VisitInfoProvider provider =
        Provider.of<VisitInfoProvider>(context, listen: false);
    provider.initReportWidget();
  }

  @override
  Widget build(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    return Consumer<VisitInfoProvider>(builder: (context, provider, child) {
      return Scaffold(
        appBar: PreferredSize(
            preferredSize:
                Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
            child: const CommonAppbar(title: 'Initiate Visit Info Report')),
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
                            if (formKey.currentState!.validate()) {
                              http.StreamedResponse result =
                                  await provider.getVisitReport();
                              var data = jsonDecode(
                                  await result.stream.bytesToString());
                              if (result.statusCode == 200) {
                                provider.setReport(data);
                                context.pushNamed(VisitInfoReport.routeName);
                              } else if (result.statusCode == 400) {
                                await showAlertDialog(
                                    context,
                                    data['message'].toString(),
                                    "Continue",
                                    false);
                              } else if (result.statusCode == 500) {
                                await showAlertDialog(context, data['message'],
                                    "Continue", false);
                              } else {
                                await showAlertDialog(context, data['message'],
                                    "Continue", false);
                              }
                            }
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
