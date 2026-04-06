import 'dart:convert';

import 'package:fintech_new_web/features/network/service/network_service.dart';
import 'package:fintech_new_web/features/wireSize/provider/wire_size_provider.dart';
import 'package:fintech_new_web/features/wireSize/screens/wire_size_details.dart';
import 'package:fintech_new_web/features/wireSize/screens/wire_size_details_table.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../../common/widgets/comman_appbar.dart';
import '../../utility/global_variables.dart';

class WireSizeByMatno extends StatefulWidget {
  static String routeName = 'WireSizeByMatno';
  const WireSizeByMatno({super.key});

  @override
  State<WireSizeByMatno> createState() => _WireSizeByMatnoState();
}

class _WireSizeByMatnoState extends State<WireSizeByMatno> {
  @override
  Widget build(BuildContext context) {
    return Consumer<WireSizeProvider>(
        builder: (context, provider, child) {
          return Scaffold(
            appBar: PreferredSize(
                preferredSize:
                Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
                child: const CommonAppbar(title: 'Wire Size Material')),
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
                            controller: provider.materialController,
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
                                  text: "Material No.",
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
                            onChanged: (value) {
                              // GlobalVariables.requestBody[widget.feature][widget.field.id] = value;
                            },
                            inputFormatters: <TextInputFormatter>[
                              // FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9#\$&*!₹%.@_ ]')),
                              LengthLimitingTextInputFormatter(10)
                            ],
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(bottom: 10),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: HexColor("#0B6EFE"),
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(5)))),
                            onPressed: () async {
                              NetworkService networkService = NetworkService();
                              http.StreamedResponse response = await networkService.get("/get-wire-size-details/${provider.materialController.text}/");
                              if(response.statusCode == 200) {
                                List<dynamic> data = jsonDecode(await response.stream.bytesToString());
                                if(data.isEmpty) {
                                  context.pushNamed(WireSizeDetails.routeName);
                                }
                                context.pushNamed(WireSizeDetailsTable.routeName);
                              } else {

                              context.pushNamed(WireSizeDetails.routeName);
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
