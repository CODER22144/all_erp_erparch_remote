import 'dart:convert';

import 'package:fintech_new_web/features/productionPlan/provider/production_plan_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

import '../../common/widgets/comman_appbar.dart';
import 'package:http/http.dart' as http;
import '../../network/service/network_service.dart';
import '../../utility/global_variables.dart';

class DeleteProductionPlan extends StatefulWidget {
  static String routeName = 'DeleteProductionPlan';
  const DeleteProductionPlan({super.key});

  @override
  State<DeleteProductionPlan> createState() => _DeleteProductionPlanState();
}

class _DeleteProductionPlanState extends State<DeleteProductionPlan> {
  @override
  void initState() {
    super.initState();
    ProductionPlanProvider provider =
        Provider.of<ProductionPlanProvider>(context, listen: false);
    provider.editController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductionPlanProvider>(
        builder: (context, provider, child) {
      return Scaffold(
        appBar: PreferredSize(
            preferredSize:
                Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
            child: const CommonAppbar(title: 'Delete Production Plan')),
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
                              text: "Production Plan ID",
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
                            width: double.infinity,
                            margin: const EdgeInsets.only(bottom: 10),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blueAccent,
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(5)))),
                              onPressed: () async {
                                NetworkService networkService =
                                    NetworkService();
                                http.StreamedResponse response =
                                    await networkService.get(
                                        "/get-production-plan/${provider.editController.text}/");
                                if (response.statusCode == 200) {
                                  _showTablePopup(
                                      context,
                                      jsonDecode(await response.stream
                                          .bytesToString()),
                                      provider);
                                }
                              },
                              child: const Text(
                                'Delete',
                                style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          // Ensures even spacing and prevents overflow
                          child: Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(bottom: 10),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.redAccent,
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(5)))),
                              onPressed: () async {
                                NetworkService networkService =
                                    NetworkService();
                                http.StreamedResponse response =
                                    await networkService.get(
                                        "/get-production-plan/${provider.editController.text}/");
                                if (response.statusCode == 200) {
                                  NetworkService networkService =
                                      NetworkService();
                                  http.StreamedResponse response =
                                      await networkService.post(
                                          "/delete-all-production-plan/", {
                                    "ppid": provider.editController.text
                                  });
                                  if (response.statusCode == 204) {
                                    context.pop();
                                    provider.editController.clear();
                                  }
                                }
                              },
                              child: const Text(
                                'Delete Whole Plan',
                                style: TextStyle(
                                    fontSize: 24,
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
    });
  }

  void _showTablePopup(BuildContext context, List<dynamic> productionPlan,
      ProductionPlanProvider provider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Production Plan',
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
                      DataColumn(label: Text('Plan ID')),
                      DataColumn(label: Text('Date')),
                      DataColumn(label: Text('Material No.')),
                      DataColumn(label: Text('Quantity')),
                      DataColumn(label: Text('Adjusted\nQuantity')),
                      DataColumn(label: Text('Issue\nQuantity')),
                      DataColumn(label: Text('')),
                    ],
                    rows: productionPlan.map((data) {
                      return DataRow(cells: [
                        DataCell(Text('${data['ppId'] ?? "-"}')),
                        DataCell(Text('${data['tDate'] ?? "-"}')),
                        DataCell(Text('${data['matno'] ?? "-"}')),
                        DataCell(Text('${data['qty'] ?? "-"}')),
                        DataCell(Text('${data['adQty'] ?? "-"}')),
                        DataCell(Text('${data['issueQty'] ?? "-"}')),
                        DataCell(ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)))),
                          onPressed: () async {
                            NetworkService networkService = NetworkService();
                            http.StreamedResponse response =
                                await networkService.post(
                                    "/delete-production-plan/",
                                    {"ppid": '${data['id'] ?? "-"}'});
                            if (response.statusCode == 204) {
                              context.pop();
                              provider.editController.clear();
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
