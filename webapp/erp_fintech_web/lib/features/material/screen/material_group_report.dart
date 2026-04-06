import 'package:fintech_new_web/features/hsn/provider/hsn_provider.dart';
import 'package:fintech_new_web/features/material/provider/material_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/widgets/comman_appbar.dart';

class MaterialGroupReport extends StatefulWidget {
  static String routeName = "materialGroupReport";

  const MaterialGroupReport({super.key});

  @override
  State<MaterialGroupReport> createState() => _MaterialGroupReportState();
}

class _MaterialGroupReportState extends State<MaterialGroupReport> {
  @override
  void initState() {
    MaterialProvider provider =
    Provider.of<MaterialProvider>(context, listen: false);
    provider.getMatGroup();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MaterialProvider>(builder: (context, provider, child) {
      return Material(
        child: SafeArea(
            child: Scaffold(
              appBar: PreferredSize(
                  preferredSize:
                  Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
                  child: const CommonAppbar(title: 'Material Group Report')),
              body: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: provider.matGroup.isNotEmpty ? DataTable(
                    columns: const [
                      DataColumn(label: Text("Group ID")),
                      DataColumn(label: Text("Description"))
                    ],
                    rows: provider.matGroup.map((data) {
                      return DataRow(cells: [
                        DataCell(Text('${data['mgid'] ?? "-"}')),
                        DataCell(Text('${data['mgDescription'] ?? "-"}'))
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
