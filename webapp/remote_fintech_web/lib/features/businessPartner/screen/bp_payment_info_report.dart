import 'package:fintech_new_web/features/businessPartner/provider/business_partner_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/widgets/comman_appbar.dart';

class BpPaymentInfoReport extends StatefulWidget {
  static String routeName = "BpPaymentInfoReport";

  const BpPaymentInfoReport({super.key});

  @override
  State<BpPaymentInfoReport> createState() => _BpPaymentInfoReportState();
}

class _BpPaymentInfoReportState extends State<BpPaymentInfoReport> {
  @override
  void initState() {
    super.initState();
    BusinessPartnerProvider provider =
    Provider.of<BusinessPartnerProvider>(context, listen: false);
    provider.getPaymentInfoReport();
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
                  child: const CommonAppbar(title: 'Business Partner Payment Info')),
              body: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text("BP Code")),
                        DataColumn(label: Text("BP Name")),
                        DataColumn(label: Text("City")),
                        DataColumn(label: Text("State")),
                        DataColumn(label: Text("MOP")),
                        DataColumn(label: Text("Ac. Name")),
                        DataColumn(label: Text("Bank")),
                        DataColumn(label: Text("Branch")),
                        DataColumn(label: Text("Ac. Type")),
                        DataColumn(label: Text("Ac. No")),
                        DataColumn(label: Text("IFSC Code")),
                        DataColumn(label: Text("Swift Code")),
                      ],
                      rows: provider.bpPaymentInfo.map((data) {
                        return DataRow(cells: [
                          DataCell(Text('${data['bpCode'] ?? "-"}')),
                          DataCell(Text('${data['bpName'] ?? "-"}')),
                          DataCell(Text('${data['bpCity'] ?? "-"}')),
                          DataCell(Text('${data['bpStateName'] ?? "-"}')),
                          DataCell(Text('${data['mop'] ?? "-"}')),
                          DataCell(Text('${data['bankAcName'] ?? "-"}')),
                          DataCell(Text('${data['bankName'] ?? "-"}')),
                          DataCell(Text('${data['bankBranch'] ?? "-"}')),
                          DataCell(Text('${data['bankAcType'] ?? "-"}')),
                          DataCell(Text('${data['bankAcNo'] ?? "-"}')),
                          DataCell(Text('${data['ifscCode'] ?? "-"}')),
                          DataCell(Text('${data['swiftCode'] ?? "-"}')),

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
