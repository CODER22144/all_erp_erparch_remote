import 'package:fintech_new_web/features/billReceipt/provider/bill_receipt_provider.dart';
import 'package:fintech_new_web/features/utility/services/common_utility.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../common/widgets/comman_appbar.dart';
import '../../network/service/network_service.dart';
import 'hyperlink.dart';

class BrReport extends StatefulWidget {
  static String routeName = "BrReport";

  const BrReport({super.key});

  @override
  State<BrReport> createState() => _BrReportState();
}

class _BrReportState extends State<BrReport> {
  @override
  void initState() {
    super.initState();
    BillReceiptProvider provider =
    Provider.of<BillReceiptProvider>(context, listen: false);
    provider.getBrReport();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BillReceiptProvider>(builder: (context, provider, child) {
      return Material(
        child: SafeArea(
            child: Scaffold(
              appBar: PreferredSize(
                  preferredSize:
                  Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
                  child: const CommonAppbar(title: 'BR Report')),
              body: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Visibility(
                      visible: provider.brReport.isNotEmpty,
                      child: DataTable(
                        columnSpacing: 23,
                        columns: const [
                          DataColumn(label: Text("Br Id")),
                          DataColumn(label: Text("Date")),
                          DataColumn(label: Text("Bill Type")),
                          DataColumn(label: Text("Party Name")),
                          DataColumn(label: Text("Bill No.")),
                          DataColumn(label: Text("Bill Date")),
                          DataColumn(label: Text("Bill Amount")),
                          DataColumn(label: Text("Carrier Type")),
                          DataColumn(label: Text("Transport Mode")),
                          DataColumn(label: Text("Carrier Name")),
                          DataColumn(label: Text("Vehicle No.")),
                          DataColumn(label: Text("DCGR No.")),
                          DataColumn(label: Text("DCGR Date")),
                          DataColumn(label: Text("No of Packet")),
                          DataColumn(label: Text("Posted")),
                        ],
                        rows: provider.brReport.map((data) {
                          return DataRow(cells: [
                            DataCell(Hyperlink(
                                text: data['brId'].toString(),
                                url:
                                data['docImage'] != null || data['docImage'] != ""
                                    ? data['docImage']
                                    : "")),
                            DataCell(Text('${data['dtranDate'] ?? "-"}')),
                            DataCell(Text('${data['btDescription'] ?? "-"}')),
                            DataCell(Text('${data['bpName'] ?? "-"}')),
                            DataCell(Text('${data['billNo'] ?? "-"}')),
                            DataCell(Text('${data['billDate'] ?? "-"}')),
                            DataCell(Align(alignment: Alignment.centerRight,child: Text(parseDoubleUpto2Decimal(data['billAmount'])))),
                            DataCell(Text('${data['crtpDescription'] ?? "-"}')),
                            DataCell(Text('${data['transDescription'] ?? "-"}')),
                            DataCell(Text('${data['carrierName'] ?? "-"}')),
                            DataCell(Text('${data['vehicleNo'] ?? "-"}')),
                            DataCell(Text('${data['dcgrNo'] ?? "-"}')),
                            DataCell(Text('${data['dcgrDate'] ?? "-"}')),
                            DataCell(Text('${data['nopkt'] ?? "-"}')),
                            DataCell(Text('${data['POSTED'] ?? "-"}')),
                          ]);
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ),
            )),
      );
    });
  }
}
