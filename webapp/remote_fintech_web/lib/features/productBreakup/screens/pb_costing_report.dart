import 'package:fintech_new_web/features/productBreakup/provider/product_breakup_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/widgets/comman_appbar.dart';

class PbCostingReport extends StatefulWidget {
  static String routeName = "PbCostingReport";

  const PbCostingReport({super.key});

  @override
  State<PbCostingReport> createState() => _PbCostingReportState();
}

class _PbCostingReportState extends State<PbCostingReport> {
  @override
  void initState() {
    ProductBreakupProvider provider =
        Provider.of<ProductBreakupProvider>(context, listen: false);
    provider.getPbCostingReport();
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
              child: const CommonAppbar(title: 'PB Costing')),
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: (provider.columns.isNotEmpty && provider.rows.isNotEmpty)
                  ? DataTable(columnSpacing: 30,border: TableBorder.all(color: Colors.transparent, width: 0),columns: provider.columns, rows: provider.rows)
                  : const SizedBox(),
            ),
          ),
        )),
      );
    });
  }
}
