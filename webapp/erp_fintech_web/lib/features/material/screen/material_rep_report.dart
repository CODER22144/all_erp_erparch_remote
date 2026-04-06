import 'package:fintech_new_web/features/material/provider/material_rep_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/widgets/comman_appbar.dart';

class MaterialRepReport extends StatelessWidget {
  static const String routeName = "materialReport";
  const MaterialRepReport({super.key});

  @override
  Widget build(BuildContext context) {
    MaterialRepProvider provider =
        Provider.of<MaterialRepProvider>(context, listen: false);

    return Material(
      child: SafeArea(
          child: Scaffold(
        appBar: PreferredSize(
            preferredSize:
                Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
            child: const CommonAppbar(title: 'Material Report')),
        body: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: DataTable(
              border: TableBorder.all(),
              columns: const [
                DataColumn(label: Text("Material No.")),
                DataColumn(label: Text("Description")),
                DataColumn(label: Text("HSN Code")),
                DataColumn(label: Text("MRP")),
                DataColumn(label: Text("List Price"))

              ],
              rows: provider.materialRepResponse.map((data) {
                return DataRow(cells: [
                  DataCell(Text('${data['matno']}')),
                  DataCell(Text('${data['matDescription']}')),
                  DataCell(Text(data['hsnCode'])),
                  DataCell(Text(data['mrp'])),
                  DataCell(Text(data['listPrice']))
                ]);
              }).toList(),
            ),
          ),
        ),
      )),
    );
  }
}
