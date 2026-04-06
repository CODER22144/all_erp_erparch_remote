// ignore_for_file: use_build_context_synchronously
import 'dart:convert';

import 'package:fintech_new_web/features/material/provider/material_provider.dart';
import 'package:fintech_new_web/features/material/screen/mat_stock_report.dart';
import 'package:fintech_new_web/features/material/screen/material_rep_report.dart';
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
import '../provider/material_rep_provider.dart';
import 'material_report.dart';

class MatStockReportForm extends StatefulWidget {
  static String routeName = "MatStockReportForm";
  const MatStockReportForm({super.key});

  @override
  State<MatStockReportForm> createState() => _MatStockReportFormState();
}

class _MatStockReportFormState extends State<MatStockReportForm> {
  @override
  void initState() {
    super.initState();
    MaterialProvider provider =
    Provider.of<MaterialProvider>(context, listen: false);
    provider.initStockReportWidget();
  }

  @override
  Widget build(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    return Consumer<MaterialProvider>(builder: (context, provider, child) {
      return Scaffold(
        appBar: PreferredSize(
            preferredSize:
            Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
            child: const CommonAppbar(title: 'Material Stock Report')),
        body: SingleChildScrollView(
          child: Center(
            child: Container(
              width: kIsWeb
                  ? GlobalVariables.deviceWidth / 2.0
                  : GlobalVariables.deviceWidth,
              padding: const EdgeInsets.all(10),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 5, bottom: 5),
                      child: ListView.builder(
                        itemCount: provider.stockReportWidgetList.length,
                        physics: const ClampingScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return provider.stockReportWidgetList[index];
                        },
                      ),
                    ),
                    Visibility(
                      visible: provider.stockReportWidgetList.isNotEmpty,
                      child: Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 10),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: HexColor("#0B6EFE"),
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(5)))),
                          onPressed: () async {
                            context.pushNamed(MatStockReport.routeName);
                          },
                          child: const Text(
                            'Submit',
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
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
