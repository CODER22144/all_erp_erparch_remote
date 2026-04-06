import 'package:fintech_new_web/features/taClaim/provider/ta_claim_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../billReceipt/screen/hyperlink.dart';
import '../../common/widgets/comman_appbar.dart';

class ClaimReport extends StatefulWidget {
  static String routeName = "claimReport";

  const ClaimReport({super.key});

  @override
  State<ClaimReport> createState() => _ClaimReportState();
}

class _ClaimReportState extends State<ClaimReport> {
  @override
  Widget build(BuildContext context) {
    return Consumer<TaClaimProvider>(builder: (context, provider, child) {
      return Material(
        child: SafeArea(
            child: Scaffold(
          appBar: PreferredSize(
              preferredSize:
                  Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
              child: const CommonAppbar(title: 'TA Claim Report')),
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text("Transaction ID")),
                    DataColumn(label: Text("Transaction Date")),
                    DataColumn(label: Text("User-Id")),
                    DataColumn(label: Text("From Place")),
                    DataColumn(label: Text("To Place")),
                    DataColumn(label: Text("Distance Covered (in Kms)")),
                    DataColumn(label: Text("Transport Medium")),
                    DataColumn(label: Text("Description")),
                    DataColumn(label: Text("Fare")),
                    DataColumn(label: Text("DA")),
                    DataColumn(label: Text("Local Conveyance")),
                    DataColumn(label: Text("Other Conveyance")),
                    DataColumn(label: Text("Other Amount")),
                    DataColumn(label: Text("Other Description")),
                    DataColumn(label: Text("Facility Name")),
                    DataColumn(label: Text("Facility Phone")),
                    DataColumn(label: Text("DocProof")),
                  ],
                  rows: provider.claimReport.map((data) {
                    return DataRow(cells: [
                      DataCell(Text('${data['transId']}')),
                      DataCell(Text('${data['tranDate']}')),
                      DataCell(Text('${data['userId']}')),
                      DataCell(Text('${data['from_Place']}')),
                      DataCell(Text("${data['to_Place']}")),
                      DataCell(Text('${data['distCovered']}')),
                      DataCell(Text('${data['mediumTransport']}')),
                      DataCell(Text('${data['transDescription']}')),
                      DataCell(Text('${data['fare']}')),
                      DataCell(Text('${data['da']}')),
                      DataCell(Text('${data['IConveyance']}')),
                      DataCell(Text('${data['oConveyance']}')),
                      DataCell(Text('${data['otherAmount']}')),
                      DataCell(Text('${data['otherDescription']}')),
                      DataCell(Text('${data['facilityName']}')),
                      DataCell(Text('${data['facilityPhone']}')),
                      DataCell(Hyperlink(
                          text: data['DocProof'].toString(),
                          url:
                          data['DocProof'] != null || data['DocProof'] != ""
                              ? data['DocProof']
                              : "")),
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

  Future<bool> _showConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Confirmation'),
              content: Text('Are you sure you want to proceed?'),
              actions: <Widget>[
                TextButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop(false); // Return false
                  },
                ),
                TextButton(
                  child: Text('Confirm'),
                  onPressed: () {
                    Navigator.of(context).pop(true); // Return true
                  },
                ),
              ],
            );
          },
        ) ??
        false; // Return false if dialog is dismissed by other means
  }
}
