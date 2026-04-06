// ignore_for_file: use_build_context_synchronously
import 'dart:convert';

import 'package:fintech_new_web/features/common/widgets/pop_ups.dart';
import 'package:fintech_new_web/features/paymentInward/provider/payment_inward_provider.dart';
import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../common/widgets/comman_appbar.dart';

class PaymentInwardPost extends StatefulWidget {
  static String routeName = "paymentInwardPost";
  const PaymentInwardPost({super.key});

  @override
  State<PaymentInwardPost> createState() => _PaymentInwardPostState();
}

class _PaymentInwardPostState extends State<PaymentInwardPost> {
  TextEditingController dateController = TextEditingController();
  DateTime? _selectedDate;

  String dDate = "";

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
        dDate = DateFormat('MM-dd-yyyy').format(pickedDate);
        dateController.text = DateFormat('dd-MM-yyyy').format(pickedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    return Consumer<PaymentInwardProvider>(builder: (context, provider, child) {
      return Scaffold(
        appBar: PreferredSize(
            preferredSize:
                Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
            child: const CommonAppbar(title: 'Payment Inward Post')),
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
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: TextFormField(
                        controller: dateController,
                        style:
                            const TextStyle(color: Colors.black, fontSize: 12),
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          suffixIcon: dateController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    // Clear the text field and trigger onChanged
                                    setState(() {
                                      dateController.text = "";
                                    });
                                  },
                                )
                              : null, // No icon when the field is empty

                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          border: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)),
                          focusedBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 2),
                          ),
                          label: RichText(
                            text: const TextSpan(
                              text: "Trans. Date",
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
                        readOnly: true,
                        onTap: () => _selectDate(context),
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
                          var data = await provider.getBankStatementByDate(dDate);
                          _showTablePopup(
                              context, data, provider);
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

  void _showTablePopup(BuildContext context, List<dynamic> orderBalance,
      PaymentInwardProvider provider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Bank Statement',
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
                      DataColumn(label: Text('MOP')),
                      DataColumn(label: Text('Party Code')),
                      DataColumn(label: Text('Bank Code')),
                      DataColumn(label: Text('Deposit')),
                      DataColumn(label: Text('Naration'))
                    ],
                    rows: orderBalance.map((data) {
                      return DataRow(cells: [
                        DataCell(Text('${data['mop'] ?? "-"}')),
                        DataCell(Text('${data['lcode'] ?? "-"}')),
                        DataCell(Text('${data['bankCode'] ?? "-"}')),
                        DataCell(Text('${data['deposit'] ?? "-"}')),
                        DataCell(Text('${data['naration'] ?? "-"}')),
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
                      color: Colors.redAccent,
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
                InkWell(
                  onTap: () async {
                    http.StreamedResponse result =
                        await provider.postPaymentInward(dDate);
                    var message =
                        jsonDecode(await result.stream.bytesToString());
                    if (result.statusCode == 200) {
                      context.pop();
                      context.pop();
                    } else if (result.statusCode == 400) {
                      await showAlertDialog(context,
                          message['message'].toString(), "Continue", false);
                    } else if (result.statusCode == 500) {
                      await showAlertDialog(
                          context, message['message'], "Continue", false);
                    } else {
                      await showAlertDialog(
                          context, message['message'], "Continue", false);
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 5),
                    width: GlobalVariables.deviceWidth * 0.15,
                    height: GlobalVariables.deviceHeight * 0.05,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
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
                    child: const Text("POST",
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
