import 'package:fintech_new_web/features/hsn/provider/hsn_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/widgets/comman_appbar.dart';

class AcGroupsReport extends StatefulWidget {
  static String routeName = "AcGroupsReport";

  const AcGroupsReport({super.key});

  @override
  State<AcGroupsReport> createState() => _AcGroupsReportState();
}

class _AcGroupsReportState extends State<AcGroupsReport> {
  @override
  void initState() {
    HsnProvider provider =
    Provider.of<HsnProvider>(context, listen: false);
    provider.getAcGroupsReport();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HsnProvider>(builder: (context, provider, child) {
      return Material(
        child: SafeArea(
            child: Scaffold(
              appBar: PreferredSize(
                  preferredSize:
                  Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
                  child: const CommonAppbar(title: 'Accounts Group Report')),
              body: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: provider.acGroups.isNotEmpty ? DataTable(
                    columns: const [
                      DataColumn(label: Text("Acc. Group Code")),
                      DataColumn(label: Text("Description")),
                      DataColumn(label: Text("Master Group Code")),
                      DataColumn(label: Text("Is Trading")),
                      DataColumn(label: Text("Is P/L")),
                      DataColumn(label: Text("Is Balanace Sheet"))
                    ],
                    rows: provider.acGroups.map((data) {
                      return DataRow(cells: [
                        DataCell(Text('${data['AgCode'] ?? "-"}')),
                        DataCell(Text('${data['agDescription'] ?? "-"}')),
                        DataCell(Text('${data['MGcode'] ?? "-"}')),
                        DataCell(Text('${data['IsTr'] ?? "-"}')),
                        DataCell(Text('${data['IsPl'] ?? "-"}')),
                        DataCell(Text('${data['IsBl'] ?? "-"}'))
                      ]);
                    }).toList(),
                  ) : const SizedBox(),
                ),
              ),
            )),
      );
    });
  }
}
