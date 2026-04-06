import 'package:fintech_new_web/features/material/provider/material_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/widgets/comman_appbar.dart';

class MaterialUnitReport extends StatefulWidget {
  static String routeName = "materialUnitReport";

  const MaterialUnitReport({super.key});

  @override
  State<MaterialUnitReport> createState() => _MaterialUnitReportState();
}

class _MaterialUnitReportState extends State<MaterialUnitReport> {
  @override
  void initState() {
    MaterialProvider provider =
    Provider.of<MaterialProvider>(context, listen: false);
    provider.getMatUnit();
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
                  child: const CommonAppbar(title: 'Material Unit Report')),
              body: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: provider.matUnit.isNotEmpty ? DataTable(
                    columns: const [
                      DataColumn(label: Text("Unit Code")),
                      DataColumn(label: Text("Description"))
                    ],
                    rows: provider.matUnit.map((data) {
                      return DataRow(cells: [
                        DataCell(Text('${data['muCode'] ?? "-"}')),
                        DataCell(Text('${data['muName'] ?? "-"}'))
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
