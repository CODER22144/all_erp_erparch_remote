// ignore_for_file: use_build_context_synchronously
import 'package:fintech_new_web/features/material/provider/material_provider.dart';
import 'package:fintech_new_web/features/reOrderBalanceMaterial/provider/re_order_balance_material_provider.dart';
import 'package:fintech_new_web/features/reOrderBalanceMaterial/screens/re_order_bal_mat_report.dart';
import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

import '../../common/widgets/comman_appbar.dart';

class ReOrderBalMatReportForm extends StatefulWidget {
  static String routeName = "/ReOrderBalMatReportForm";
  const ReOrderBalMatReportForm({super.key});

  @override
  State<ReOrderBalMatReportForm> createState() => _ReOrderBalMatReportFormState();
}

class _ReOrderBalMatReportFormState extends State<ReOrderBalMatReportForm> {
  @override
  void initState() {
    super.initState();
    ReOrderBalanceMaterialProvider provider =
    Provider.of<ReOrderBalanceMaterialProvider>(context, listen: false);
    provider.initReportWidget();
  }

  @override
  Widget build(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    return Consumer<ReOrderBalanceMaterialProvider>(builder: (context, provider, child) {
      return Scaffold(
        appBar: PreferredSize(
            preferredSize:
            Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
            child: const CommonAppbar(title: 'Re-Order Balance Material Report')),
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
                            context.pushNamed(ReOrderBalMatReport.routeName);
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
