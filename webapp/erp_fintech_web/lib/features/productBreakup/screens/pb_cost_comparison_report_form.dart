// ignore_for_file: use_build_context_synchronously

import 'package:fintech_new_web/features/materialIncomingStandard/provider/material_incoming_standard_provider.dart';
import 'package:fintech_new_web/features/productBreakup/provider/product_breakup_provider.dart';
import 'package:fintech_new_web/features/productBreakup/screens/pb_cost_comparison_report.dart';
import 'package:fintech_new_web/features/salesReport/provider/sales_report_provider.dart';
import 'package:fintech_new_web/features/salesReport/screens/yearly_report.dart';
import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

import '../../common/widgets/comman_appbar.dart';

class PbCostComparisonReportForm extends StatefulWidget {
  static String routeName = "/PbCostComparisonReportForm";
  const PbCostComparisonReportForm({super.key});

  @override
  State<PbCostComparisonReportForm> createState() =>
      _PbCostComparisonReportFormState();
}

class _PbCostComparisonReportFormState
    extends State<PbCostComparisonReportForm> {
  @override
  void initState() {
    super.initState();
    ProductBreakupProvider provider =
        Provider.of<ProductBreakupProvider>(context, listen: false);
    provider.initCostComparisonReport();
  }

  @override
  Widget build(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    return Consumer<ProductBreakupProvider>(
        builder: (context, provider, child) {
      return Scaffold(
        appBar: PreferredSize(
            preferredSize:
                Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
            child:
                const CommonAppbar(title: 'Product Breakup Cost Comparison')),
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
                        itemCount: provider.reportWidgetList.length,
                        physics: const ClampingScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return provider.reportWidgetList[index];
                        },
                      ),
                    ),
                    Visibility(
                      visible: provider.reportWidgetList.isNotEmpty,
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
                            context.pushNamed(PbCostComparisonReport.routeName);
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
