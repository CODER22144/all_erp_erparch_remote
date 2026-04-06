import 'dart:convert';

import 'package:fintech_new_web/features/financialYear/screens/add_financial_year.dart';
import 'package:fintech_new_web/features/forms/provider/form_provider.dart';
import 'package:fintech_new_web/features/forms/screens/update_form.dart';
import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

import '../../common/widgets/comman_appbar.dart';
import '../../common/widgets/pop_ups.dart';
import '../../network/service/network_service.dart';

class FormReport extends StatefulWidget {
  static String routeName = "FormReport";

  const FormReport({super.key});

  @override
  State<FormReport> createState() => _FormReportState();
}

class _FormReportState extends State<FormReport> {
  @override
  void initState() {
    super.initState();
    FormProvider provider = Provider.of<FormProvider>(context, listen: false);
    provider.getAllForms();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FormProvider>(builder: (context, provider, child) {
      return Material(
        child: SafeArea(
            child: Scaffold(
          appBar: PreferredSize(
              preferredSize:
                  Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
              child: const CommonAppbar(title: 'Json Forms')),
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    DataTable(
                      columns: const [
                        DataColumn(
                            label: Text("Form ID",
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text("Form Description",
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text("Form Data",
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text("Actions",
                                style: TextStyle(fontWeight: FontWeight.bold))),
                      ],
                      rows: provider.formsRep.map((data) {
                        return DataRow(cells: [
                          DataCell(Text('${data['form_id'] ?? "-"}')),
                          DataCell(Text('${data['form_description'] ?? "-"}')),
                          DataCell(SizedBox(
                              width: GlobalVariables.deviceWidth / 3,
                              child: Text(
                                '${data['form_data'] ?? "-"}',
                                maxLines: 4,
                              ))),
                          DataCell(Align(
                            alignment: Alignment.centerRight,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(5),
                                          bottomLeft: Radius.circular(5)),
                                      color: Colors.blue),
                                  child: IconButton(
                                    icon: const Icon(Icons.edit),
                                    color: Colors.white,
                                    tooltip: 'Update',
                                    onPressed: () {
                                      provider.editController.text =
                                          '${data['form_id']}';
                                      context.pushNamed(
                                          UpdateForm.routeName,
                                          queryParameters: {
                                            "details": jsonEncode(data),
                                          });
                                    },
                                  ),
                                ),
                                Container(
                                  decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(5),
                                          bottomRight: Radius.circular(5)),
                                      color: Colors.red),
                                  child: IconButton(
                                    icon: const Icon(Icons.delete),
                                    color: Colors.white,
                                    tooltip: 'Delete',
                                    onPressed: () async {
                                      bool confirmation =
                                          await showConfirmationDialogue(
                                              context,
                                              "Are you sure you want to delete this Financial Year?",
                                              "SUBMIT",
                                              "CANCEL");
                                      if (confirmation) {
                                        NetworkService networkService =
                                            NetworkService();
                                        http.StreamedResponse response =
                                            await networkService.post(
                                                "/delete-fy/",
                                                {"Fy": '${data['Fy']}'});
                                        if (response.statusCode == 204) {
                                          provider.getAllForms();
                                        } else if (response.statusCode == 400) {
                                          var message = jsonDecode(
                                              await response.stream
                                                  .bytesToString());
                                          await showAlertDialog(
                                              context,
                                              message['message'].toString(),
                                              "Continue",
                                              false);
                                        } else if (response.statusCode == 500) {
                                          var message = jsonDecode(
                                              await response.stream
                                                  .bytesToString());
                                          await showAlertDialog(
                                              context,
                                              message['message'],
                                              "Continue",
                                              false);
                                        } else {
                                          var message = jsonDecode(
                                              await response.stream
                                                  .bytesToString());
                                          await showAlertDialog(
                                              context,
                                              message['message'],
                                              "Continue",
                                              false);
                                        }
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          )),
                        ]);
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        )),
      );
    });
  }
}
