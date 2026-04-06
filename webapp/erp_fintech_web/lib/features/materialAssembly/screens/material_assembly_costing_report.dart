import 'package:fintech_new_web/features/materialAssembly/provider/material_assembly_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/widgets/comman_appbar.dart';

class MaterialAssemblyCostingReport extends StatefulWidget {
  static String routeName = "MaterialAssemblyCostingReport";

  const MaterialAssemblyCostingReport({super.key});

  @override
  State<MaterialAssemblyCostingReport> createState() => _MaterialAssemblyCostingReportState();
}

class _MaterialAssemblyCostingReportState extends State<MaterialAssemblyCostingReport> {
  @override
  void initState() {
    MaterialAssemblyProvider provider =
    Provider.of<MaterialAssemblyProvider>(context, listen: false);
    provider.getPbCostingReport();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MaterialAssemblyProvider>(
        builder: (context, provider, child) {
          return Material(
            child: SafeArea(
                child: Scaffold(
                  appBar: PreferredSize(
                      preferredSize:
                      Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
                      child: const CommonAppbar(title: 'Material Assembly Costing')),
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
