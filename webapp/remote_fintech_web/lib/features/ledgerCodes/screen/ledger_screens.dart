import 'package:fintech_new_web/features/ledgerCodes/provider/ledger_codes_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../common/widgets/comman_appbar.dart';
import '../../network/service/network_service.dart';
import '../../utility/global_variables.dart';

class LedgerScreens extends StatefulWidget {
  static String routeName = "LedgerScreens";

  const LedgerScreens({super.key});

  @override
  State<LedgerScreens> createState() => _LedgerScreensState();
}

class _LedgerScreensState extends State<LedgerScreens> {
  @override
  void initState() {
    super.initState();
    LedgerCodesProvider provider =
        Provider.of<LedgerCodesProvider>(context, listen: false);
    provider.getLedgersReport();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LedgerCodesProvider>(builder: (context, provider, child) {
      return Material(
        child: SafeArea(
            child: Scaffold(
          appBar: PreferredSize(
              preferredSize:
                  Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
              child: const CommonAppbar(title: 'Ledgers Report')),
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 25),
                      child: Text("${provider.ledgerRep['legalName']}",
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 25),
                      child: Text(
                          "${provider.ledgerRep['compAdd']} ${provider.ledgerRep['compAdd1']}",
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 25),
                      child: Text("${provider.ledgerRep['compCity']}",
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    DataTable(
                      columns: [
                        DataColumn(
                            label: Text("${provider.ledgerRep['lcode'] ?? "-"}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text("${provider.ledgerRep['lname'] ?? "-"}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold))),
                        const DataColumn(
                            label: Text("",
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        const DataColumn(
                            label: Text("",
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        const DataColumn(
                            label: Text("",
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        const DataColumn(label: SizedBox()),
                        DataColumn(
                            label: ElevatedButton(
                                onPressed: () async {
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  var cid = prefs.getString("currentLoginCid");

                                  String url =
                                      "${NetworkService.baseUrl}/get-ledger-report-pdf/?fromDate=${GlobalVariables.requestBody[LedgerCodesProvider.report2Feature]['fromDate']}&toDate=${GlobalVariables.requestBody[LedgerCodesProvider.report2Feature]['toDate']}&lcode=${GlobalVariables.requestBody[LedgerCodesProvider.report2Feature]['lcode']}&cid=$cid";
                                  final Uri uri = Uri.parse(url);
                                  if (await canLaunchUrl(uri)) {
                                  await launchUrl(uri,
                                  mode: LaunchMode.inAppBrowserView);
                                  } else {
                                  throw 'Could not launch';
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: HexColor("#0038a8"),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        3), // Square shape
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 2, horizontal: 5),
                                ),
                                child: const Row(children: [
                                  Text(
                                    "PDF",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Icon(Icons.download_outlined, color: Colors.white)
                                ],))),
                      ],
                      rows: provider.rows,
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
