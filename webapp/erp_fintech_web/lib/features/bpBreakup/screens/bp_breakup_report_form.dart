import 'package:fintech_new_web/features/bpBreakup/provider/bp_breakup_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:searchable_paginated_dropdown/searchable_paginated_dropdown.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../common/widgets/comman_appbar.dart';
import '../../network/service/network_service.dart';
import '../../utility/global_variables.dart';

class BpBreakupReportForm extends StatefulWidget {
  static String routeName = 'BpBreakupReportForm';
  const BpBreakupReportForm({super.key});

  @override
  State<BpBreakupReportForm> createState() => _BpBreakupReportFormState();
}

class _BpBreakupReportFormState extends State<BpBreakupReportForm> {
  late BpBreakupProvider provider;

  @override
  void initState() {
    super.initState();
    provider = Provider.of<BpBreakupProvider>(context, listen: false);
    provider.editController.clear();
    provider.editController2.clear();
    provider.getBpCodes();
  }

  bool isLoading = false;
  List<SearchableDropdownMenuItem<String>> materials = [];

  void getMaterialsByBpCode(String? bpCode) async {
    BpBreakupProvider prd =
        Provider.of<BpBreakupProvider>(context, listen: false);
    setState(() {
      isLoading = true;
    });

    provider.editController.text = bpCode!;
    var matDrop = await prd.getMaterials(bpCode);

    setState(() {
      materials = matDrop;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BpBreakupProvider>(builder: (context, provider, child) {
      return Scaffold(
        appBar: PreferredSize(
            preferredSize:
                Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
            child:
                const CommonAppbar(title: "Business Partner Breakup Report")),
        body: SingleChildScrollView(
          child: Center(
            child: Container(
              width: kIsWeb
                  ? GlobalVariables.deviceWidth / 2.0
                  : GlobalVariables.deviceWidth,
              padding: const EdgeInsets.all(10),
              child: Form(
                // key: formKey,
                child: Column(
                  children: [
                    Visibility(
                      visible: provider.bpCodes.isNotEmpty,
                      child: Stack(
                        children: [
                          Container(
                            color: Colors.white,
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            child: SearchableDropdown<String>(
                              isEnabled: true,
                              backgroundDecoration: (child) => Container(
                                height: 40,
                                margin: EdgeInsets.zero,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                      color: Colors.black, width: 0.5),
                                ),
                                child: child,
                              ),
                              items: provider.bpCodes,
                              onChanged: getMaterialsByBpCode,
                              hasTrailingClearIcon: false,
                            ),
                          ),
                          Positioned(
                            left: 10,
                            top: 3,
                            child: Container(
                              color: Colors.white,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 2),
                              child: const Wrap(
                                children: [
                                  Text(
                                    "Business Partner",
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    "*",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isLoading)
                      const CircularProgressIndicator()
                    else
                      Visibility(
                        visible: provider.bpCodes.isNotEmpty,
                        child: Stack(
                          children: [
                            Container(
                              color: Colors.white,
                              margin: const EdgeInsets.only(top: 10),
                              child: SearchableDropdown<String>(
                                isEnabled: true,
                                backgroundDecoration: (child) => Container(
                                  height: 40,
                                  margin: EdgeInsets.zero,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                        color: Colors.black, width: 0.5),
                                  ),
                                  child: child,
                                ),
                                items: materials,
                                onChanged: (value) {
                                  setState(() {
                                    provider.editController2.text = value!;
                                  });
                                },
                                hasTrailingClearIcon: false,
                              ),
                            ),
                            Positioned(
                              left: 10,
                              top: 3,
                              child: Container(
                                color: Colors.white,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 2),
                                child: const Wrap(
                                  children: [
                                    Text(
                                      "Material no.",
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      "*",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 10, top: 10),
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
                          final Uri uri = Uri.parse(
                              "${NetworkService.baseUrl}/get-bp-breakup-report/?bpCode=${provider.editController.text}&matno=${provider.editController2.text}&cid=$cid");
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
