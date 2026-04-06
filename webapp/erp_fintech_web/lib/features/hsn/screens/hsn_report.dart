import 'package:fintech_new_web/features/hsn/provider/hsn_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/widgets/comman_appbar.dart';

class HsnReport extends StatefulWidget {
  static String routeName = "hsnReport";

  const HsnReport({super.key});

  @override
  State<HsnReport> createState() => _HsnReportState();
}

class _HsnReportState extends State<HsnReport> {
  @override
  void initState() {
    HsnProvider provider =
    Provider.of<HsnProvider>(context, listen: false);
    provider.getHsnReport();
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
                  child: const CommonAppbar(title: 'HSN Report')),
              body: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: provider.hsnReport.isNotEmpty ? DataTable(
                    columns: const [
                      DataColumn(label: Text("Hsn Code")),
                      DataColumn(label: Text("Hsn Description")),
                      DataColumn(label: Text("Is Service")),
                      DataColumn(label: Text("Gst Tax Rate"))
                    ],
                    rows: provider.hsnReport.map((data) {
                      return DataRow(cells: [
                        DataCell(Text('${data['hsnCode'] ?? "-"}')),
                        DataCell(Text('${data['hsnShortDescription'] ?? "-"}')),
                        DataCell(Text('${data['isService'] ?? "-"}')),
                        DataCell(Text('${data['gstTaxRate'] ?? "-"}'))
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
