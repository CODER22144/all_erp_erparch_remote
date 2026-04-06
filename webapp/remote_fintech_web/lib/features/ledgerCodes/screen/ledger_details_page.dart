// ignore_for_file: use_build_context_synchronously
import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

import '../../common/widgets/comman_appbar.dart';
import '../provider/ledger_codes_provider.dart';

class LedgerDetailsPage extends StatefulWidget {
  static String routeName = "/LedgerDetailsPage";
  final String partyCode;

  const LedgerDetailsPage({super.key, required this.partyCode});

  @override
  State<LedgerDetailsPage> createState() => _LedgerDetailsPageState();
}

class _LedgerDetailsPageState extends State<LedgerDetailsPage> {
  late LedgerCodesProvider provider;
  bool pass = true;

  @override
  void initState() {
    super.initState();
    provider = Provider.of<LedgerCodesProvider>(context, listen: false);
    provider.reset();
    provider.initEditWidget(widget.partyCode);
  }

  @override
  void dispose() {
    super.dispose();
    provider.reset();
  }

  @override
  Widget build(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    return Consumer<LedgerCodesProvider>(builder: (context, provider, child) {
      return Scaffold(
        backgroundColor: HexColor('#f9f9ff'),
        appBar: PreferredSize(
            preferredSize:
                Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
            child: const CommonAppbar(title: "Ledger Codes Details")),
        body: SingleChildScrollView(
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                  border: provider.widgetList.isNotEmpty
                      ? Border.all(width: 1, color: Colors.black)
                      : null),
              width: kIsWeb
                  ? GlobalVariables.deviceWidth / 2.0
                  : GlobalVariables.deviceWidth,
              padding: const EdgeInsets.all(10),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    ListView.builder(
                      itemCount: provider.widgetList.length,
                      physics: const ClampingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return provider.widgetList[index];
                      },
                    ),
                    Visibility(
                      visible: provider.visibility != 'O' &&
                          (provider.visibility != null &&
                              provider.visibility != ""),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 5, bottom: 5),
                        child: ListView.builder(
                          itemCount: provider.optWidgetList1.length,
                          physics: const ClampingScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return provider.optWidgetList1[index];
                          },
                        ),
                      ),
                    ),
                    Visibility(
                      visible: provider.visibility == 'V' ||
                          provider.visibility == 'B',
                      child: Padding(
                        padding: const EdgeInsets.only(top: 5, bottom: 5),
                        child: ListView.builder(
                          itemCount: provider.optWidgetList2.length,
                          physics: const ClampingScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return provider.optWidgetList2[index];
                          },
                        ),
                      ),
                    ),
                    Visibility(
                      visible: provider.visibility == 'C' ||
                          provider.visibility == 'B',
                      child: Padding(
                        padding: const EdgeInsets.only(top: 5, bottom: 5),
                        child: ListView.builder(
                          itemCount: provider.optWidgetList3.length,
                          physics: const ClampingScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return provider.optWidgetList3[index];
                          },
                        ),
                      ),
                    ),
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
