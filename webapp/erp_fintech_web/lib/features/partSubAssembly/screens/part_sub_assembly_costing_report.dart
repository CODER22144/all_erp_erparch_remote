import 'package:fintech_new_web/features/partAssembly/provider/part_assembly_provider.dart';
import 'package:fintech_new_web/features/productBreakup/provider/product_breakup_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/widgets/comman_appbar.dart';
import '../provider/part_sub_assembly_provider.dart';

class PartSubAssemblyCostingReport extends StatefulWidget {
  static String routeName = "PartSubAssemblyCostingReport";

  const PartSubAssemblyCostingReport({super.key});

  @override
  State<PartSubAssemblyCostingReport> createState() => _PartSubAssemblyCostingReportState();
}

class _PartSubAssemblyCostingReportState extends State<PartSubAssemblyCostingReport> {
  @override
  void initState() {
    PartSubAssemblyProvider provider =
    Provider.of<PartSubAssemblyProvider>(context, listen: false);
    provider.getPbCostingReport();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PartSubAssemblyProvider>(
        builder: (context, provider, child) {
          return Material(
            child: SafeArea(
                child: Scaffold(
                  appBar: PreferredSize(
                      preferredSize:
                      Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
                      child: const CommonAppbar(title: 'Part Sub-Assembly Costing')),
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
