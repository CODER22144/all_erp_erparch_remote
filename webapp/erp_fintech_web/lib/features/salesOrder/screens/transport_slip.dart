import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/widgets/comman_appbar.dart';
import '../../network/service/network_service.dart';
import '../../utility/global_variables.dart';

class TransportSlip extends StatefulWidget {
  static String routeName = '/TransportSlip';
  const TransportSlip({super.key});

  @override
  State<TransportSlip> createState() => _TransportSlipState();
}

class _TransportSlipState extends State<TransportSlip> {
  TextEditingController invController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize:
          Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
          child: const CommonAppbar(title: 'Transporter/Acknowledgement Slip')),
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
                      style: const TextStyle(color: Colors.black, fontSize: 14),
                      readOnly: false,
                      controller: invController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        border: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black)),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey, width: 2),
                        ),
                        label: RichText(
                          text: const TextSpan(
                            text: "Invoice No.",
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
                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceEvenly, // Adjust alignment
                    children: [
                      Expanded(
                        // Ensures even spacing and prevents overflow
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 10, right: 5),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: HexColor("#0B6EFE"),
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(5)),
                              ),
                            ),
                            onPressed: () async {
                              SharedPreferences prefs = await SharedPreferences.getInstance();
                              var cid = prefs.getString("currentLoginCid");
                              final Uri uri = Uri.parse(
                                  "${NetworkService.baseUrl}/transporter-slip/${invController.text}/$cid/");
                              if (await canLaunchUrl(uri)) {
                                await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
                              } else {
                                throw 'Could not launch';
                              }
                            },
                            child: const Text(
                              'Transporter Slip',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        // Ensures even spacing and prevents overflow
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 10, left: 5),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: HexColor("#0B6EFE"),
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(5)),
                              ),
                            ),
                            onPressed: () async {
                              SharedPreferences prefs = await SharedPreferences.getInstance();
                              var cid = prefs.getString("currentLoginCid");
                              final Uri uri = Uri.parse(
                                  "${NetworkService.baseUrl}/ack-slip/${invController.text}/$cid/");
                              if (await canLaunchUrl(uri)) {
                                await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
                              } else {
                                throw 'Could not launch';
                              }
                            },
                            child: const Text(
                              'Acknowledgement Slip',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
