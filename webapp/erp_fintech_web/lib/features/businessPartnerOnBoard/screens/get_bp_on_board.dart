import 'dart:convert';

import 'package:fintech_new_web/features/businessPartnerOnBoard/provider/business_partner_on_board_provider.dart';
import 'package:fintech_new_web/features/businessPartnerOnBoard/screens/business_partner_on_board.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../../common/widgets/comman_appbar.dart';
import '../../common/widgets/pop_ups.dart';
import '../../network/service/network_service.dart';
import '../../utility/global_variables.dart';

class GetBpOnBoard extends StatefulWidget {
  static String routeName = 'GetBpOnBoard';
  final bool delete;
  const GetBpOnBoard({super.key, required this.delete});

  @override
  State<GetBpOnBoard> createState() => _GetBpOnBoardState();
}

class _GetBpOnBoardState extends State<GetBpOnBoard> {
  @override
  void initState() {
    super.initState();
    BusinessPartnerOnBoardProvider provider =
        Provider.of<BusinessPartnerOnBoardProvider>(context, listen: false);
    provider.editController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BusinessPartnerOnBoardProvider>(
        builder: (context, provider, child) {
      return Scaffold(
        appBar: PreferredSize(
            preferredSize:
                Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
            child: CommonAppbar(
                title: widget.delete
                    ? "Delete Business Partner OnBoard"
                    : 'Get Business Partner OnBoard')),
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
                              text: "Business Partner",
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
                        inputFormatters: <TextInputFormatter>[
                          LengthLimitingTextInputFormatter(15)
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
                          if (widget.delete) {
                            NetworkService networkService = NetworkService();
                            http.StreamedResponse response =
                                await networkService.post("/get-bp-on-board/",
                                    {"bpCode": provider.editController.text});
                            if (response.statusCode == 200) {
                              _showTablePopup(
                                  context,
                                  jsonDecode(
                                      await response.stream.bytesToString()));
                            }
                          } else {
                            context.pushNamed(BusinessPartnerOnBoard.routeName,
                                queryParameters: {"editing": 'true'});
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

  void _showTablePopup(BuildContext context, List<dynamic> orderBalance) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete OB Material',
              style: TextStyle(fontWeight: FontWeight.w500)),
          content: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DataTable(
                    columns: const [
                      DataColumn(label: Text('Bp Code')),
                      DataColumn(label: Text('GSTIN')),
                      DataColumn(label: Text('BP Name')),
                      DataColumn(label: Text('Address')),
                      DataColumn(label: Text('Phone')),
                      DataColumn(label: Text('Email')),
                      DataColumn(label: Text('Contact Person')),
                      DataColumn(label: Text('Designation')),
                      DataColumn(label: Text('')),
                    ],
                    rows: orderBalance.map((data) {
                      return DataRow(cells: [
                        DataCell(Text('${data['bpCode'] ?? "-"}')),
                        DataCell(Text('${data['bpGSTIN'] ?? "-"}')),
                        DataCell(Text('${data['bpName'] ?? "-"}')),
                        DataCell(Text('${data['bpAdd'] ?? "-"}, ${data['bpAdd'] ?? ""}\n${data['bpCity']  ?? "-"} - ${data['bpState']  ?? "-"}, ${data['bpZipCode']  ?? "-"}')),
                        DataCell(Text('${data['bpPhone'] ?? "-"}')),
                        DataCell(Text('${data['bpEmail'] ?? "-"}')),
                        DataCell(Text('${data['contactPerson'] ?? "-"}')),
                        DataCell(Text('${data['designation'] ?? "-"}')),
                        DataCell(ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)))),
                          onPressed: () async {
                            bool confirmation = await showConfirmationDialogue(
                                context,
                                "Are you sure you want to delete this record?",
                                "SUBMIT",
                                "CANCEL");
                            if (confirmation) {
                              NetworkService networkService = NetworkService();
                              http.StreamedResponse response =
                                  await networkService.post(
                                      "/delete-bp-on-board/",
                                      {"bpCode": '${data['bpCode']}'});
                              if (response.statusCode == 200) {
                                context.pushReplacementNamed(
                                    GetBpOnBoard.routeName, extra: true);
                              }
                            }
                          },
                          child: const Text(
                            'Delete',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w300,
                                color: Colors.white),
                          ),
                        )),
                      ]);
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    // Navigator.pop(context, false);
                    Navigator.of(context, rootNavigator: true).pop(false);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 5),
                    width: GlobalVariables.deviceWidth * 0.15,
                    height: GlobalVariables.deviceHeight * 0.05,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: HexColor("#e0e0e0"),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.grey,
                          blurRadius: 2,
                          offset: Offset(
                            2,
                            3,
                          ),
                        )
                      ],
                    ),
                    child: const Text("CLOSE",
                        style: TextStyle(fontSize: 11, color: Colors.black)),
                  ),
                ),
              ],
            )
          ],
        );
      },
    );
  }
}
