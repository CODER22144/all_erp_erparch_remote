import 'package:fintech_new_web/features/partAssembly/provider/part_assembly_provider.dart';
import 'package:fintech_new_web/features/productBreakup/provider/product_breakup_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/widgets/comman_appbar.dart';

class PartAssemblyCostingReport extends StatefulWidget {
  static String routeName = "PartAssemblyCostingReport";

  const PartAssemblyCostingReport({super.key});

  @override
  State<PartAssemblyCostingReport> createState() => _PartAssemblyCostingReportState();
}

class _PartAssemblyCostingReportState extends State<PartAssemblyCostingReport> {
  @override
  void initState() {
    PartAssemblyProvider provider =
    Provider.of<PartAssemblyProvider>(context, listen: false);
    provider.getPbCostingReport();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PartAssemblyProvider>(
        builder: (context, provider, child) {
          return Material(
            child: SafeArea(
                child: Scaffold(
                  appBar: PreferredSize(
                      preferredSize:
                      Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
                      child: const CommonAppbar(title: 'Part Assembly Costing')),
                  body: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: (provider.costColumns.isNotEmpty && provider.costRows.isNotEmpty)
                          ? DataTable(border: TableBorder.all(color: Colors.transparent, width: 0),columns: provider.costColumns, rows: provider.costRows)
                          : const SizedBox(),
                    ),
                  ),
                )),
          );
        });
  }
}
