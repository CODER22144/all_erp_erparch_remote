// ignore_for_file: use_build_context_synchronously
import 'dart:convert';

import 'package:fintech_new_web/features/invenReq/provider/inven_req_provider.dart';
import 'package:fintech_new_web/features/invenReq/screens/req_details_row_field.dart';
import 'package:fintech_new_web/features/jobWorkOut/provider/job_work_out_provider.dart';
import 'package:fintech_new_web/features/salesOrder/screens/sales_order_details_row_field.dart';
import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../common/widgets/comman_appbar.dart';
import '../../common/widgets/pop_ups.dart';

class AddReqDetails extends StatefulWidget {
  static String routeName = "/AddReqDetails";

  const AddReqDetails({super.key});
  @override
  AddReqDetailsState createState() => AddReqDetailsState();
}

class AddReqDetailsState extends State<AddReqDetails>
    with SingleTickerProviderStateMixin {
  List<List<String>> tableRows = [];
  var formKey = GlobalKey<FormState>();
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    InvenReqProvider provider =
        Provider.of<InvenReqProvider>(context, listen: false);
    provider.initWidget('M');
    // Add one empty row at the beginning
    tableRows.add(['', '']);
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  // Function to add a new row
  void addRow() {
    setState(() {
      tableRows.add(['', '']);
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
    return Consumer<InvenReqProvider>(builder: (context, provider, child) {
      return Scaffold(
        appBar: PreferredSize(
            preferredSize:
                Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
            child: const CommonAppbar(title: 'Inventory Requirement - Manual')),
        body: Center(
          child: Column(
            children: [
              TabBar(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: tabController,
                  isScrollable: false,
                  tabs: const [
                    Tab(text: "Requirement"),
                    Tab(text: "Details"),
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
                                      onPressed: () async {
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 10),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: HexColor("#0B6EFE"),
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5)))),
                                onPressed: () async {
                                  http.StreamedResponse result =
                                  await provider
                                      .addRequirementDetails(tableRows);
                                  var message = jsonDecode(
                                      await result.stream.bytesToString());
                                  if (result.statusCode == 200) {
                                    context.pushReplacementNamed(
                                        AddReqDetails.routeName);
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
                              for (int i = 0; i < tableRows.length; i++)
                                ReqDetailsRowField(
                                    index: i,
                                    tableRows: tableRows,
                                    deleteRow: deleteRow),
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
