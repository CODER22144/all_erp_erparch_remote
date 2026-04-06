import 'package:fintech_new_web/features/bpShipping/provider/bp_shipping_provider.dart';
import 'package:fintech_new_web/features/ledgerCodes/provider/ledger_codes_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/widgets/comman_appbar.dart';

class ShippingReport extends StatefulWidget {
  static String routeName = "ShippingReport";

  const ShippingReport({super.key});

  @override
  State<ShippingReport> createState() => _ShippingReportState();
}

class _ShippingReportState extends State<ShippingReport> {
  @override
  void initState() {
    super.initState();
    BpShippingProvider provider =
    Provider.of<BpShippingProvider>(context, listen: false);
    provider.getShippingReport();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BpShippingProvider>(builder: (context, provider, child) {
      return Material(
        child: SafeArea(
            child: Scaffold(
              appBar: PreferredSize(
                  preferredSize:
                  Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
                  child: const CommonAppbar(title: 'BP Shipping Report')),
              body: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text("Shipping Code")),
                        DataColumn(label: Text("Party Code")),
                        DataColumn(label: Text("Shipping Name")),
                        DataColumn(label: Text("Shipping Address")),
                        DataColumn(label: Text("City")),
                        DataColumn(label: Text("State")),
                        DataColumn(label: Text("Zipcode")),
                        DataColumn(label: Text("Country")),
                        DataColumn(label: Text("Phone")),
                        DataColumn(label: Text("GSTIN")),
                      ],
                      rows: provider.shippingReport.map((data) {
                        return DataRow(cells: [
                          DataCell(Text('${data['shipCode'] ?? "-"}')),
                          DataCell(Text('${data['bpCode'] ?? "-"}')),
                          DataCell(Text('${data['shipName'] ?? "-"}')),
                          DataCell(Text('${data['shipAdd'] ?? "-"} ${data['shipAdd1'] ?? ""}')),
                          DataCell(Text('${data['shipCity'] ?? "-"}')),
                          DataCell(Text('${data['shipState'] ?? "-"}')),
                          DataCell(Text('${data['shipZipCode'] ?? "-"}')),
                          DataCell(Text('${data['shipCountry'] ?? "-"}')),
                          DataCell(Text('${data['shipPhone'] ?? "-"}')),
                          DataCell(Text('${data['shipGSTIN'] ?? "-"}')),

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
