import 'package:fintech_new_web/features/exportOrder/provider/export_order_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../common/widgets/comman_appbar.dart';
import '../../network/service/network_service.dart';
import '../../utility/global_variables.dart';

class ExportOrderReport extends StatefulWidget {
  static String routeName = 'ExportOrderReport';
  const ExportOrderReport({super.key});

  @override
  State<ExportOrderReport> createState() => _ExportOrderReportState();
}

class _ExportOrderReportState extends State<ExportOrderReport> {
  late ExportOrderProvider provider;

  @override
  void initState() {
    super.initState();
    provider = Provider.of<ExportOrderProvider>(context, listen: false);
    provider.editController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExportOrderProvider>(builder: (context, provider, child) {
      return Scaffold(
        appBar: PreferredSize(
            preferredSize:
                Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
            child: const CommonAppbar(title: "Export Order Report")),
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
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: TextFormField(
                        style:
                            const TextStyle(color: Colors.black, fontSize: 14),
                        readOnly: false,
                        controller: provider.editController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          border: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black)),
                          focusedBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey, width: 2),
                          ),
                          label: RichText(
                            text: const TextSpan(
                              text: "Order Id",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                fontWeight: FontWeight.w300,
                              ),
                              children: [
                                TextSpan(
                                    text: "*",
                                    style: TextStyle(color: Colors.red))
                              ],
                            ),
                          ),
                        ),
                        validator: (String? val) {
                          if ((val == null || val.isEmpty)) {
                            return 'This field is Mandatory';
                          }
                        },
                        maxLines: 1,
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
                              "${NetworkService.baseUrl}/get-exp-order-pdf/${provider.editController.text}/$cid/");
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
