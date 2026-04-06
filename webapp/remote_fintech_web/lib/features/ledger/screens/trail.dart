// ignore_for_file: use_build_context_synchronously
import 'package:fintech_new_web/features/ledger/provider/ledger_provider.dart';
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

class Trial extends StatefulWidget {
  static String routeName = "/Trial";
  const Trial({super.key});

  @override
  State<Trial> createState() => _TrialState();
}

class _TrialState extends State<Trial> {
  @override
  void initState() {
    super.initState();
    LedgerProvider provider =
        Provider.of<LedgerProvider>(context, listen: false);
    provider.initTrialWidget();
  }

  @override
  Widget build(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    return Consumer<LedgerProvider>(builder: (context, provider, child) {
      return Scaffold(
        appBar: PreferredSize(
            preferredSize:
                Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
            child: const CommonAppbar(title: 'Trial Report')),
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
                            context.pushReplacementNamed(Trial.routeName);

                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            var cid = prefs.getString("currentLoginCid");

                            String url =
                                "${NetworkService.baseUrl}/trial/?fromDate=${GlobalVariables.requestBody[LedgerProvider.trialReportFeature]['fromDate']}&toDate=${GlobalVariables.requestBody[LedgerProvider.trialReportFeature]['toDate']}&cid=$cid";

                            if (GlobalVariables.requestBody[LedgerProvider
                                    .trialReportFeature]['agCode'] !=
                                null) {
                              url =
                                  "$url&agCode=${GlobalVariables.requestBody[LedgerProvider.trialReportFeature]['agCode']}";
                            }
                            final Uri uri = Uri.parse(url);
                            if (await canLaunchUrl(uri)) {
                              await launchUrl(uri,
                                  mode: LaunchMode.inAppBrowserView);
                            } else {
                              throw 'Could not launch';
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
