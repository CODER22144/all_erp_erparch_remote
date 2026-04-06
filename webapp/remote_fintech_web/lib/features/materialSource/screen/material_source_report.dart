import 'dart:convert';

import 'package:fintech_new_web/features/materialSource/provider/material_source_provider.dart';
import 'package:fintech_new_web/features/network/service/network_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../../common/widgets/comman_appbar.dart';
import '../../common/widgets/pop_ups.dart';
import '../../utility/global_variables.dart';
import '../../utility/services/common_utility.dart';

class MaterialSourceReport extends StatefulWidget {
  static String routeName = "MaterialSourceReport";

  const MaterialSourceReport({super.key});

  @override
  State<MaterialSourceReport> createState() =>
      _PurchaseOrderReportScreenState();
}

class _PurchaseOrderReportScreenState extends State<MaterialSourceReport> {
  @override
  void initState() {
    super.initState();
    MaterialSourceProvider provider =
        Provider.of<MaterialSourceProvider>(context, listen: false);
    provider.nestedTable();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MaterialSourceProvider>(
        builder: (context, provider, child) {
      return Material(
        child: SafeArea(
            child: Scaffold(
          appBar: PreferredSize(
              preferredSize:
                  Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
              child: const CommonAppbar(title: 'Material Source Report')),
          body: Center(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                        ),
                        onPressed: () async {
                          NetworkService networkService = NetworkService();
                          http.StreamedResponse response =
                              await networkService.post(
                                  "/get-mat-source-export/",
                                  GlobalVariables.requestBody[
                                      MaterialSourceProvider.reportFeature]);
                          if (response.statusCode == 200) {
                            var data = jsonDecode(
                                await response.stream.bytesToString());
                            downloadJsonToExcel(data, "material_source_export");
                          } else {
                            var message = jsonDecode(
                                await response.stream.bytesToString());
                            await showAlertDialog(
                                context, message['message'], "Continue", false);
                          }
                        },
                        child: const Text(
                          'Export',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                      provider.table
                    ],
                  )),
            ),
          ),
        )),
      );
    });
  }
}
