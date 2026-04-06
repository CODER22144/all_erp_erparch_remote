import 'package:fintech_new_web/features/businessPartner/provider/business_partner_provider.dart';
import 'package:fintech_new_web/features/businessPartner/screen/business_partner.dart';
import 'package:fintech_new_web/features/dlChallan/provider/dl_challan_provider.dart';
import 'package:fintech_new_web/features/jobWorkOut/provider/job_work_out_provider.dart';
import 'package:fintech_new_web/features/ledgerCodes/provider/ledger_codes_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/widgets/comman_appbar.dart';
import '../../network/service/network_service.dart';
import '../../utility/services/common_utility.dart';

class BpReport extends StatefulWidget {
  static String routeName = "BpReport";

  const BpReport({super.key});

  @override
  State<BpReport> createState() => _BpReportState();
}

class _BpReportState extends State<BpReport> {
  @override
  void initState() {
    super.initState();
    BusinessPartnerProvider provider =
    Provider.of<BusinessPartnerProvider>(context, listen: false);
    provider.getLedgerReport();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BusinessPartnerProvider>(builder: (context, provider, child) {
      return Material(
        child: SafeArea(
            child: Scaffold(
              appBar: PreferredSize(
                  preferredSize:
                  Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
                  child: const CommonAppbar(title: 'Business Partner Discount Structure')),
              body: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text("BP Code")),
                        DataColumn(label: Text("Name")),
                        DataColumn(label: Text("Address")),
                        DataColumn(label: Text("City")),
                        DataColumn(label: Text("State")),
                        DataColumn(label: Text("GSTIN")),
                        DataColumn(label: Text("Business\nRelation Type")),
                        DataColumn(label: Text("Supplier Type")),
                        DataColumn(label: Text("Supply Type")),
                        DataColumn(label: Text("Discount Type")),
                        DataColumn(label: Text("Discount Rate")),
                        DataColumn(label: Text("Loyalty Discount")),
                        DataColumn(label: Text("Payment Discount")),
                        DataColumn(label: Text("Distance")),
                        DataColumn(label: Text("Tcs Enabled")),
                        DataColumn(label: Text("Tcs Rate")),
                        DataColumn(label: Text("Tds Code")),
                      ],
                      rows: provider.bpSaleDiscount.map((data) {
                        return DataRow(cells: [
                          DataCell(Text('${data['bpCode'] ?? "-"}')),
                          DataCell(Text('${data['bpName'] ?? "-"}')),
                          DataCell(Text('${data['bpAdd'] ?? "-"}, ${data['bpAdd1'] ?? ""}')),
                          DataCell(Text('${data['bpCity'] ?? "-"}')),
                          DataCell(Text('${data['stateName'] ?? "-"}')),
                          DataCell(Text('${data['bpGSTIN'] ?? "-"}')),
                          DataCell(Text('${data['brType'] ?? "-"}')),
                          DataCell(Text('${data['slId'] ?? "-"}')),
                          DataCell(Text('${data['stId'] ?? "-"}')),
                          DataCell(Text('${data['discType'] ?? "-"}')),
                          DataCell(Text('${data['discRate'] ?? "-"}')),
                          DataCell(Text('${data['loyaltyDisc'] ?? "-"}')),
                          DataCell(Text('${data['paymentDisc'] ?? "-"}')),
                          DataCell(Text('${data['bpDistance'] ?? "-"}')),
                          DataCell(Text('${data['tcsEnabled'] ?? "-"}')),
                          DataCell(Text('${data['R_Tcs'] ?? "-"}')),
                          DataCell(Text('${data['tdsCode'] ?? "-"}')),

                        ]);
                      }).toList(),
                    ),
                  ),
                ),
              ),
            )),
      );
    });
  }
}
