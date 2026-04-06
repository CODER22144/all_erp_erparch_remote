import 'package:fintech_new_web/features/businessPartner/provider/business_partner_search_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/widgets/comman_appbar.dart';

class BpSearchReport extends StatelessWidget {
  static const String routeName = "searchBpReport";
  const BpSearchReport({super.key});

  @override
  Widget build(BuildContext context) {
    BusinessPartnerSearchProvider provider =
        Provider.of<BusinessPartnerSearchProvider>(context, listen: false);

    return Material(
      child: SafeArea(
          child: Scaffold(
        appBar: PreferredSize(
            preferredSize:
                Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
            child: const CommonAppbar(title: 'Business Partner Report')),
        body: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: DataTable(
              border: TableBorder.all(),
              columns: const [
                DataColumn(label: Text("Business Partner Code")),
                DataColumn(label: Text("Business Partner Name")),
                DataColumn(label: Text("City")),
                DataColumn(label: Text("State"))
              ],
              rows: provider.searchResponse.map((data) {
                return DataRow(cells: [
                  DataCell(Text('${data['bpCode']}')),
                  DataCell(Text('${data['bpName']}')),
                  DataCell(Text(data['bpCity'])),
                  DataCell(Text(data['stateName'])),
                ]);
              }).toList(),
            ),
          ),
        ),
      )),
    );
  }
}
