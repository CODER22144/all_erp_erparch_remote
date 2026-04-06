// ignore_for_file: use_build_context_synchronously
import 'package:fintech_new_web/features/productionPlan/provider/production_plan_provider.dart';
import 'package:fintech_new_web/features/productionPlan/screens/production_plan_AS.dart';
import 'package:fintech_new_web/features/productionPlan/screens/production_plan_report_PLN.dart';
import 'package:fintech_new_web/features/productionPlan/screens/production_plan_report_RM.dart';
import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

import '../../common/widgets/comman_appbar.dart';

class ProductionPlanReportForm extends StatefulWidget {
  static String routeName = "ProductionPlanReportForm";
  const ProductionPlanReportForm({super.key});

  @override
  State<ProductionPlanReportForm> createState() =>
      _ProductionPlanReportFormState();
}

class _ProductionPlanReportFormState extends State<ProductionPlanReportForm> {

  Map<String, String> routes = {};


  @override
  void initState() {
    super.initState();
    ProductionPlanProvider provider =
        Provider.of<ProductionPlanProvider>(context, listen: false);
    provider.initReportWidget();

    routes = {
      "PLN" : ProductionPlanReportPLN.routeName,
      "RM" : ProductionPlanReportRm.routeName,
      "AS" : ProductionPlanReportAs.routeName
    };
  }

  @override
  Widget build(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    return Consumer<ProductionPlanProvider>(
        builder: (context, provider, child) {
      return Scaffold(
        appBar: PreferredSize(
            preferredSize:
                Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
            child: const CommonAppbar(title: 'Production Plan Report')),
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
                      padding: const EdgeInsets.only(top: 5, bottom: 5),
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
                            context.pushNamed(routes[GlobalVariables.requestBody[ProductionPlanProvider.reportFeature]['repId']]!);
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
