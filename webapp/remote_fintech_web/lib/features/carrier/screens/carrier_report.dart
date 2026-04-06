import 'dart:convert';

import 'package:fintech_new_web/features/carrier/provider/carrier_provider.dart';
import 'package:fintech_new_web/features/carrier/screens/carrier.dart';
import 'package:fintech_new_web/features/carrier/screens/carrier_info.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

import '../../common/widgets/comman_appbar.dart';
import '../../common/widgets/pop_ups.dart';
import '../../network/service/network_service.dart';
import '../../utility/services/common_utility.dart';

class CarrierReport extends StatefulWidget {
  static String routeName = "CarrierReport";

  const CarrierReport({super.key});

  @override
  State<CarrierReport> createState() => _CarrierReportState();
}

class _CarrierReportState extends State<CarrierReport> {
  @override
  void initState() {
    super.initState();
    CarrierProvider provider =
    Provider.of<CarrierProvider>(context, listen: false);
    provider.getAllCarriers();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CarrierProvider>(builder: (context, provider, child) {
      return Material(
        child: SafeArea(
            child: Scaffold(
              appBar: PreferredSize(
                  preferredSize:
                  Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
                  child: const CommonAppbar(title: 'Carrier Report')),
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
                          columns: [
                            const DataColumn(label: Text("")),
                            const DataColumn(label: Text("")),
                            const DataColumn(label: Text("")),
                            const DataColumn(label: Text("")),
                            const DataColumn(label: Text("")),
                            const DataColumn(label: Text("")),
                            const DataColumn(label: Text("")),
                            const DataColumn(label: Text("")),
                            DataColumn(
                                label: Row(
                                  children: [
                                    Container(
                                      decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(5),
                                              bottomLeft: Radius.circular(5)),
                                          color: Colors.green),
                                      child: IconButton(
                                        icon: const Icon(Icons.add),
                                        color: Colors.white,
                                        tooltip: 'Add',
                                        onPressed: () {
                                          context.pushNamed(Carrier.routeName);
                                        },
                                      ),
                                    ),
                                    Container(
                                      decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(5),
                                              bottomRight: Radius.circular(5)),
                                          color: Colors.blue),
                                      child: IconButton(
                                        icon: const Icon(Icons.exit_to_app_outlined),
                                        color: Colors.white,
                                        tooltip: 'Export',
                                        onPressed: () {
                                          downloadJsonToExcel(provider.carriers,
                                              "carrier_export");
                                        },
                                      ),
                                    )
                                  ],
                                )),
                          ],
                          rows: const [],
                        ),
                        DataTable(
                          columns: const [
                            DataColumn(label: Text("Car Id", style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text("Carrier Name", style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text("GSTIN", style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text("Address", style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text("City", style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text("State", style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text("Zipcode", style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text("Contact Person", style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text("Phone", style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text("Actions", style: TextStyle(fontWeight: FontWeight.bold))),
                          ],
                          rows: provider.carriers.map((data) {
                            return DataRow(cells: [
                              DataCell(Text('${data['carId'] ?? "-"}')),
                              DataCell(Text('${data['carName'] ?? "-"}')),
                              DataCell(Text('${data['carGSTIN'] ?? "-"}')),
                              DataCell(Text('${data['carAdd'] ?? "-"} ${data['carAdd1'] ?? ""}')),
                              DataCell(Text('${data['carCity'] ?? "-"}')),
                              DataCell(Text('${data['carStateName'] ?? "-"}')),
                              DataCell(Text('${data['carZipCode'] ?? "-"}')),
                              DataCell(Text('${data['carCPerson'] ?? "-"}')),
                              DataCell(Text('${data['carPhone'] ?? "-"}')),
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
                                          color: Colors.green),
                                      child: IconButton(
                                        icon: const Icon(Icons.info_outline),
                                        color: Colors.white,
                                        tooltip: 'Info',
                                        onPressed: () {
                                          context.pushNamed(CarrierInfo.routeName);
                                        },
                                      ),
                                    ),
                                    Container(
                                      color: Colors.blue,
                                      child: IconButton(
                                        icon: const Icon(Icons.edit),
                                        color: Colors.white,
                                        tooltip: 'Update',
                                        onPressed: () {
                                          provider.editController.text = '${data['carId']}';
                                          context.pushNamed(Carrier.routeName,
                                              queryParameters: {
                                                "editing": 'true',
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
                                              "Are you sure you want to delete this ledger?",
                                              "SUBMIT",
                                              "CANCEL");
                                          if (confirmation) {
                                            NetworkService networkService =
                                            NetworkService();
                                            http.StreamedResponse response =
                                            await networkService.post(
                                                "/delete-carrier/",
                                                {"carId": '${data['carId']}'});
                                            if (response.statusCode == 204) {
                                              provider.getAllCarriers();
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
