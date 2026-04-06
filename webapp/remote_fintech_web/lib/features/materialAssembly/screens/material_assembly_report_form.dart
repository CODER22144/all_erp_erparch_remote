// ignore_for_file: use_build_context_synchronously
import 'package:fintech_new_web/features/materialAssembly/provider/material_assembly_provider.dart';
import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

import '../../common/widgets/comman_appbar.dart';
import '../../network/service/network_service.dart';

class MaterialAssemblyReportForm extends StatefulWidget {
  static String routeName = "MaterialAssemblyReportForm";
  const MaterialAssemblyReportForm({super.key});

  @override
  State<MaterialAssemblyReportForm> createState() =>
      _MaterialAssemblyReportFormState();
}

class _MaterialAssemblyReportFormState extends State<MaterialAssemblyReportForm> {
  @override
  void initState() {
    super.initState();
    MaterialAssemblyProvider provider =
    Provider.of<MaterialAssemblyProvider>(context, listen: false);
    provider.initReport();
  }

  @override
  Widget build(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    return Consumer<MaterialAssemblyProvider>(
        builder: (context, provider, child) {
          return Scaffold(
            appBar: PreferredSize(
                preferredSize:
                Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
                child: const CommonAppbar(title: 'Material Assembly Report')),
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
                                SharedPreferences prefs = await SharedPreferences.getInstance();
                                var cid = prefs.getString("currentLoginCid");
                                final Uri uri = Uri.parse(
                                    "${NetworkService.baseUrl}/mat-assembly-breakup/${GlobalVariables.requestBody[MaterialAssemblyProvider.reportFeature]['matno']}/$cid/");
                                if (await canLaunchUrl(uri)) {
                                  await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
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
