// ignore_for_file: use_build_context_synchronously
import 'dart:convert';

import 'package:fintech_new_web/features/dbNote/provider/dbnote_provider.dart';
import 'package:fintech_new_web/features/prTaxInvoice/provider/pr_tax_invoice_provider.dart';
import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../common/widgets/comman_appbar.dart';
import '../../common/widgets/pop_ups.dart';
import '../../home.dart';
import 'pr_tax_invoice_row_fields.dart';

class PrTaxInvoiceDetails extends StatefulWidget {
  static String routeName = "/prtaxInvoice";

  const PrTaxInvoiceDetails({super.key});
  @override
  State<PrTaxInvoiceDetails> createState() => PrTaxInvoiceDetailsState();
}

class PrTaxInvoiceDetailsState extends State<PrTaxInvoiceDetails>
    with SingleTickerProviderStateMixin {
  List<List<String>> tableRows = [];
  var formKey = GlobalKey<FormState>();
  late TabController tabController;

  bool checkRatePercentage = false;
  bool checkDiscAmount = false;

  double amount = 0;
  double discAmount = 0;
  double cessAmount = 0;
  double gstAmount = 0;
  double totalAmount = 0;

  TextEditingController discAmountController = TextEditingController(text: '0');
  TextEditingController discRateController = TextEditingController(text: '0');
  TextEditingController hsnController = TextEditingController();

  @override
  void initState() {
    super.initState();
    PrTaxInvoiceProvider provider =
    Provider.of<PrTaxInvoiceProvider>(context, listen: false);
    provider.initWidget();
    // Add one empty row at the beginning
    tableRows.add(['', '','', '', '','','', '0', 'N', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0']);
    tabController = TabController(length: 2, vsync: this);
    provider.getDiscountType();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  // Function to add a new row
  void addRow() {
    setState(() {
      tableRows.add(['', '', '', '', '','','', '0', 'N', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0']);
    });
  }

  // Function to delete a row
  void deleteRow(int index) {
    setState(() {
      tableRows.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PrTaxInvoiceProvider>(builder: (context, provider, child) {
      return Scaffold(
        appBar: PreferredSize(
            preferredSize:
            Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
            child: const CommonAppbar(title: 'PR Tax Invoice')),
        body: Center(
          child: Column(
            children: [
              TabBar(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: tabController,
                  isScrollable: false,
                  tabs: const [
                    Tab(text: "PR Tax"),
                    Tab(text: "Invoice Details"),
                  ]),
              Expanded(
                  child: TabBarView(
                      physics: const NeverScrollableScrollPhysics(),
                      controller: tabController,
                      children: [
                        SingleChildScrollView(
                          child: Center(
                            child: Container(
                              width: kIsWeb
                                  ? GlobalVariables.deviceWidth / 2
                                  : GlobalVariables.deviceWidth,
                              padding: const EdgeInsets.all(10),
                              child: Form(
                                key: formKey,
                                child: Column(
                                  children: [
                                    Padding(
                                      padding:
                                      const EdgeInsets.only(top: 5, bottom: 5),
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
                                      child: SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: HexColor("#1abc9c"),
                                              shape: const RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(5)))),
                                          onPressed: () {
                                            if (formKey.currentState!.validate()) {
                                              tabController.animateTo(1);
                                            }
                                          },
                                          child: const Text('Next ->',
                                              style: TextStyle(
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white)),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        SingleChildScrollView(
                          child: Center(
                            child: SizedBox(
                              width: kIsWeb
                                  ? GlobalVariables.deviceWidth / 2
                                  : GlobalVariables.deviceWidth,
                              child: Column(
                                children: [
                                  const SizedBox(height: 10),
                                  for (int i = 0; i < tableRows.length; i++)
                                    PrTaxInvoiceRowFields(
                                        index: i,
                                        tableRows: tableRows,
                                        discountType: provider.discountType,
                                        deleteRow: deleteRow),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment
                                        .spaceEvenly, // Space buttons evenly
                                    children: [
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: HexColor("#0B6EFE"),
                                            shape: const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5)))),
                                        onPressed: () async {
                                          http.StreamedResponse result =
                                          await provider
                                              .processFormInfo(tableRows);
                                          var message = jsonDecode(
                                              await result.stream.bytesToString());
                                          if (result.statusCode == 200) {
                                            context
                                                .pushReplacementNamed(PrTaxInvoiceDetails.routeName);
                                          } else if (result.statusCode == 400) {
                                            await showAlertDialog(
                                                context,
                                                message['message'].toString(),
                                                "Continue",
                                                false);
                                          } else if (result.statusCode == 500) {
                                            await showAlertDialog(
                                                context,
                                                message['message'],
                                                "Continue",
                                                false);
                                          } else {
                                            await showAlertDialog(
                                                context,
                                                message['message'],
                                                "Continue",
                                                false);
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
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: HexColor("#0B6EFE"),
                                            shape: const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5)))),
                                        onPressed: addRow,
                                        child: const Text('Add Row',
                                            style: TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white)),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ]))
            ],
          ),
        ),
      );
    });
  }
}
