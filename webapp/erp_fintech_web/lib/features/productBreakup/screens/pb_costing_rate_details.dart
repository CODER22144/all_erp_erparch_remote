import 'package:fintech_new_web/features/productBreakup/provider/product_breakup_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/widgets/comman_appbar.dart';

class PbCostingRateDetails extends StatefulWidget {
  static String routeName = "/PbCostingRateDetails";
  final String matno;

  const PbCostingRateDetails({super.key, required this.matno});

  @override
  State<PbCostingRateDetails> createState() => _PbCostingRateDetailsState();
}

class _PbCostingRateDetailsState extends State<PbCostingRateDetails> {
  @override
  void initState() {
    ProductBreakupProvider provider =
        Provider.of<ProductBreakupProvider>(context, listen: false);
    provider.getPbCostingRateDetails(widget.matno);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductBreakupProvider>(
        builder: (context, provider, child) {
      return Material(
        child: SafeArea(
            child: Scaffold(
          appBar: PreferredSize(
              preferredSize:
                  Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
              child: const CommonAppbar(title: 'Material Source Details')),
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text("Part No.")),
                  DataColumn(label: Text("BpCode")),
                  DataColumn(label: Text("BpName")),
                  DataColumn(label: Text("Rate")),
                  DataColumn(label: Text("Rate EF")),
                ],
                rows: provider.pbCostingMatSourceReport.map((data) {
                  return DataRow(cells: [
                    DataCell(Text('${data['matno'] ?? "-"}')),
                    DataCell(Text('${data['bpCode'] ?? "-"}')),
                    DataCell(Text('${data['bpName'] ?? "-"}')),
                    DataCell(Text('${data['bpRate'] ?? "-"}')),
                    DataCell(Text('${data['rateEf'] ?? "-"}')),
                  ]);
                }).toList(),
              ),
            ),
          ),
        )),
      );
    });
  }
}
