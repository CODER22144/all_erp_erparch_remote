// ignore_for_file: use_build_context_synchronously
import 'package:fintech_new_web/features/partAssembly/provider/part_assembly_provider.dart';
import 'package:fintech_new_web/features/partAssembly/screens/part_assembly_costing_report.dart';
import 'package:fintech_new_web/features/partSubAssembly/screens/part_sub_assembly_costing_report.dart';
import 'package:fintech_new_web/features/productBreakup/provider/product_breakup_provider.dart';
import 'package:fintech_new_web/features/productBreakup/screens/pb_costing_report.dart';
import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:fintech_new_web/features/wireSize/provider/wire_size_provider.dart';
import 'package:fintech_new_web/features/wireSize/screens/ws_report.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../../common/widgets/comman_appbar.dart';
import '../provider/part_sub_assembly_provider.dart';

class PartSubAssemblyCostingReportForm extends StatefulWidget {
  static String routeName = "PartSubAssemblyCostingReportForm";
  const PartSubAssemblyCostingReportForm({super.key});

  @override
  State<PartSubAssemblyCostingReportForm> createState() => _PartSubAssemblyCostingReportFormState();
}

class _PartSubAssemblyCostingReportFormState extends State<PartSubAssemblyCostingReportForm> {
  @override
  void initState() {
    super.initState();
    PartSubAssemblyProvider provider =
    Provider.of<PartSubAssemblyProvider>(context, listen: false);
    provider.initAssemblyCostingReport();
  }

  @override
  Widget build(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    return Consumer<PartSubAssemblyProvider>(builder: (context, provider, child) {
      return Scaffold(
        appBar: PreferredSize(
            preferredSize:
            Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
            child: const CommonAppbar(title: 'Part Sub-Assembly Costing')),
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
                            context.pushNamed(PartSubAssemblyCostingReport.routeName);
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
