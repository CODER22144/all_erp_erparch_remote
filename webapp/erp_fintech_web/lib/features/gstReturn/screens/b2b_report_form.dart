// ignore_for_file: use_build_context_synchronously
import 'package:fintech_new_web/features/gstReturn/provider/gst_return_provider.dart';
import 'package:fintech_new_web/features/gstReturn/screens/b2b_report.dart';
import 'package:fintech_new_web/features/gstReturn/screens/b2cl_report.dart';
import 'package:fintech_new_web/features/gstReturn/screens/crdr_note.dart';
import 'package:fintech_new_web/features/gstReturn/screens/doc_type_report.dart';
import 'package:fintech_new_web/features/gstReturn/screens/gst_hsn_report.dart';
import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

import '../../common/widgets/comman_appbar.dart';
import 'b2c_report.dart';

class B2bReportForm extends StatefulWidget {
  static String routeName = "/B2bReportForm";
  final String type;
  const B2bReportForm({super.key, required this.type});

  @override
  State<B2bReportForm> createState() =>
      _B2bReportFormState();
}

class _B2bReportFormState extends State<B2bReportForm> {
  Map<String, String> routes = {};
  Map<String, String> titles = {};

  @override
  void initState() {
    super.initState();
    GstReturnProvider provider =
    Provider.of<GstReturnProvider>(context, listen: false);
    provider.initReport();

    routes = {
      "B2B" : B2bReport.routeName,
      "B2C" : B2cReport.routeName,
      "B2CL" : B2ClReport.routeName,
      "HSN" : GstHsnReport.routeName,
      "CRDR" : CrdrNote.routeName,
      "DOC" : DocTypeReport.routeName
    };

    titles = {
      "B2B" : "B2B Report",
      "B2C" : "B2C Report",
      "B2CL" : "B2CL Report",
      "HSN" : "Gst Hsn Summary",
      "CRDR" : "CR/DB Note Report",
      "DOC" : "Doc Type Report"
    };

  }

  @override
  Widget build(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    return Consumer<GstReturnProvider>(
        builder: (context, provider, child) {
          return Scaffold(
            appBar: PreferredSize(
                preferredSize:
                Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
                child: CommonAppbar(title: titles[widget.type]!)),
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
                                  context.pushNamed(routes[widget.type]!);
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
