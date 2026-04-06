import 'package:fintech_new_web/features/material/provider/material_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/widgets/comman_appbar.dart';

class MaterialTypeReport extends StatefulWidget {
  static String routeName = "materialTypeReport";

  const MaterialTypeReport({super.key});

  @override
  State<MaterialTypeReport> createState() => _MaterialTypeReportState();
}

class _MaterialTypeReportState extends State<MaterialTypeReport> {
  @override
  void initState() {
    MaterialProvider provider =
    Provider.of<MaterialProvider>(context, listen: false);
    provider.getMatType();
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
                  child: const CommonAppbar(title: 'Material Type Report')),
              body: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: provider.matType.isNotEmpty ? DataTable(
                    columns: const [
                      DataColumn(label: Text("ID")),
                      DataColumn(label: Text("Description"))
                    ],
                    rows: provider.matType.map((data) {
                      return DataRow(cells: [
                        DataCell(Text('${data['mtid'] ?? "-"}')),
                        DataCell(Text('${data['mtDescription'] ?? "-"}'))
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
