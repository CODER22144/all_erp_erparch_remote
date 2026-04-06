import 'package:fintech_new_web/features/dlChallan/provider/dl_challan_provider.dart';
import 'package:fintech_new_web/features/jobWorkOut/provider/job_work_out_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/widgets/comman_appbar.dart';
import '../../network/service/network_service.dart';
import '../../utility/services/common_utility.dart';

class DlChallanReport extends StatefulWidget {
  static String routeName = "DlChallanReport";

  const DlChallanReport({super.key});

  @override
  State<DlChallanReport> createState() => _DlChallanReportState();
}

class _DlChallanReportState extends State<DlChallanReport> {
  @override
  void initState() {
    super.initState();
    DlChallanProvider provider =
    Provider.of<DlChallanProvider>(context, listen: false);
    provider.getDlChallanReport();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DlChallanProvider>(builder: (context, provider, child) {
      return Material(
        child: SafeArea(
            child: Scaffold(
              appBar: PreferredSize(
                  preferredSize:
                  Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
                  child: const CommonAppbar(title: 'Delivery Challan Report')),
              body: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columnSpacing: 25,
                      columns: const [
                        DataColumn(label: Text("Doc No.")),
                        DataColumn(label: Text("Date")),
                        DataColumn(label: Text("Party Name")),
                        DataColumn(label: Text("Address")),
                        DataColumn(label: Text("City")),
                        DataColumn(label: Text("State")),
                        DataColumn(label: Text("Pincode")),
                        DataColumn(label: Text("Tax Applies")),
                        DataColumn(label: Text("Movement Reason")),
                        DataColumn(label: Text("Remarks")),
                        DataColumn(label: Text("Product No.")),
                        DataColumn(label: Text("Qty")),
                        DataColumn(label: Text("Trans Mode")),
                        DataColumn(label: Text("Transporter ID")),
                        DataColumn(label: Text("Vehicle No.")),
                        DataColumn(label: Text("Trans Doc No.")),
                        DataColumn(label: Text("Trans Doc Date")),
                        DataColumn(label: Text("Eway Bill No.")),
                        DataColumn(label: Text("Eway Bill Date")),
                        DataColumn(label: Text("Amount")),
                        DataColumn(label: Text("Discount")),
                        DataColumn(label: Text("Ass Amount")),
                        DataColumn(label: Text("Gst Amount")),
                        DataColumn(label: Text("Igst On Intra")),
                        DataColumn(label: Text("Igst Amount")),
                        DataColumn(label: Text("Cgst Amount")),
                        DataColumn(label: Text("Sgst Amount")),
                        DataColumn(label: Text("Total Amount")),
                      ],
                      rows: provider.dlChallanReport.map((data) {
                        return DataRow(cells: [
                          // DataCell(InkWell(onTap: () async {
                          //   SharedPreferences prefs = await SharedPreferences.getInstance();
                          //   var cid = prefs.getString("currentLoginCid");
                          //   final Uri uri = Uri.parse("${NetworkService.baseUrl}/get-dl-challan-pdf/${data['docno']}/$cid/");
                          //   if (await canLaunchUrl(uri)) {
                          //     await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
                          //   } else {
                          //     throw 'Could not launch';
                          //   }
                          // },child: Text('${data['docno'] ?? "-"}', style: const TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.w500)))),
                          DataCell(Text('${data['No'] ?? "-"}')),
                          DataCell(Text('${data['dDt'] ?? "-"}')),
                          DataCell(Text('${data['Addr1'] ?? "-"}\n${data['Addr2'] ?? ""}')),
                          DataCell(Text('${data['lcode'] ?? "-"}\n${data['LglNm'] ?? "-"}')),
                          DataCell(Text('${data['Loc'] ?? "-"}')),
                          DataCell(Text('${data['Stcd'] ?? "-"}')),
                          DataCell(Text('${data['Pin'] ?? "-"}')),
                          DataCell(Text('${data['taxApplies'] ?? "-"}')),
                          DataCell(Text('${data['movementReason'] ?? "-"}')),
                          DataCell(Text('${data['Remarks'] ?? "-"}')),
                          DataCell(Text('${data['prodNo'] ?? "-"}')),
                          DataCell(Align(alignment: Alignment.centerRight,child: Text(parseDoubleUpto2Decimal('${data['sumQty']}')))),
                          DataCell(Text('${data['transMode'] ?? "-"}')),
                          DataCell(Text('${data['transId'] ?? "-"}')),
                          DataCell(Text('${data['vehicleNo'] ?? "-"}')),
                          DataCell(Text('${data['transDocNo'] ?? "-"}')),
                          DataCell(Text('${data['transDocDate'] ?? "-"}')),
                          DataCell(Text('${data['ewayBillNo'] ?? "-"}')),
                          DataCell(Text('${data['ewayBillDate'] ?? "-"}')),
                          DataCell(Align(alignment: Alignment.centerRight,child: Text(parseDoubleUpto2Decimal('${data['sumTotAmt']}')))),
                          DataCell(Align(alignment: Alignment.centerRight,child: Text(parseDoubleUpto2Decimal('${data['sumDiscount']}')))),
                          DataCell(Align(alignment: Alignment.centerRight,child: Text(parseDoubleUpto2Decimal('${data['sumAssAmt']}')))),
                          DataCell(Align(alignment: Alignment.centerRight,child: Text(parseDoubleUpto2Decimal('${data['sumGstAmt']}')))),
                          DataCell(Align(alignment: Alignment.centerRight,child: Text(parseDoubleUpto2Decimal('${data['IgstOnIntra']}')))),
                          DataCell(Align(alignment: Alignment.centerRight,child: Text(parseDoubleUpto2Decimal('${data['sumIgstAmt']}')))),
                          DataCell(Align(alignment: Alignment.centerRight,child: Text(parseDoubleUpto2Decimal('${data['sumCgstAmt']}')))),
                          DataCell(Align(alignment: Alignment.centerRight,child: Text(parseDoubleUpto2Decimal('${data['sumSgstAmt']}')))),
                          DataCell(Align(alignment: Alignment.centerRight,child: Text(parseDoubleUpto2Decimal('${data['sumTotItemVal']}')))),
                          // DataCell(Align(alignment: Alignment.centerRight,child: Text(parseDoubleUpto2Decimal('${data['sumAmount']}')))),
                          // DataCell(Align(alignment: Alignment.centerRight,child: Text(parseDoubleUpto2Decimal('${data['sumGstAmount']}')))),
                          // DataCell(Align(alignment: Alignment.centerRight,child: Text(parseDoubleUpto2Decimal('${data['sumTamount']}')))),
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
