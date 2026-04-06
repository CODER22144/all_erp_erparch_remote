// ignore_for_file: use_build_context_synchronously
import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:fintech_new_web/features/utility/services/common_utility.dart';
import 'package:fintech_new_web/features/wireSize/provider/wire_size_provider.dart';
import 'package:fintech_new_web/features/wireSize/screens/ws_assembly_report.dart';
import 'package:fintech_new_web/features/wireSize/screens/ws_report.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../common/widgets/comman_appbar.dart';
import '../../network/service/network_service.dart';

class WsAssemblyReportForm extends StatefulWidget {
  static String routeName = "WsAssemblyReportForm";
  const WsAssemblyReportForm({super.key});

  @override
  State<WsAssemblyReportForm> createState() => _WsReportFormState();
}

class _WsReportFormState extends State<WsAssemblyReportForm> {
  @override
  void initState() {
    super.initState();
    WireSizeProvider provider =
        Provider.of<WireSizeProvider>(context, listen: false);
    provider.wireSizeAssemblyReportWidget();
  }

  @override
  Widget build(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    return Consumer<WireSizeProvider>(builder: (context, provider, child) {
      return Scaffold(
        appBar: PreferredSize(
            preferredSize:
                Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
            child: const CommonAppbar(title: 'Wire Size Assembly Report')),
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
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            var cid = prefs.getString("currentLoginCid");
                            String mainURL = "";
                            if (checkForEmptyOrNullString(GlobalVariables
                                    .requestBody[
                                WireSizeProvider.assemblyFeature]['repId'])) {
                              mainURL =
                                  "${NetworkService.baseUrl}/ws-assembly/?matno=${GlobalVariables.requestBody[WireSizeProvider.assemblyFeature]['matno']}&assno=${GlobalVariables.requestBody[WireSizeProvider.assemblyFeature]['assno']}&repId=${GlobalVariables.requestBody[WireSizeProvider.assemblyFeature]['repId']}&cid=$cid";
                            } else {
                              mainURL =
                                  "${NetworkService.baseUrl}/ws-assembly/?matno=${GlobalVariables.requestBody[WireSizeProvider.assemblyFeature]['matno']}&assno=${GlobalVariables.requestBody[WireSizeProvider.assemblyFeature]['assno']}&cid=$cid";
                            }

                            final Uri uri = Uri.parse(mainURL);
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
