import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/widgets/comman_appbar.dart';
import '../provider/material_provider.dart';

class MaterialReport extends StatefulWidget {
  static const String routeName = "materialReport1";

  const MaterialReport({super.key});

  @override
  State<MaterialReport> createState() => _MaterialReportState();
}

class _MaterialReportState extends State<MaterialReport> {
  @override
  void initState() {
    super.initState();
    MaterialProvider provider =
        Provider.of<MaterialProvider>(context, listen: false);
    provider.getMaterialReport();
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
              child: const CommonAppbar(title: 'Material Report')),
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Visibility(
                  visible: provider.materialReportList.isNotEmpty,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 300,
                        child: TextField(
                          onChanged: (value) {
                            provider.search(value, ["matno", "matDescription", "hsnCode", "materialType"]);
                          },
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                          ),
                        ),
                      ),
                      DataTable(
                        dataRowMaxHeight: 100,
                        columns: const [
                          DataColumn(label: Text("Material No.")),
                          DataColumn(label: Text("Description")),
                          DataColumn(label: Text("Inventory Item")),
                          DataColumn(label: Text("Status")),
                          DataColumn(label: Text("Hsn Code")),
                          DataColumn(label: Text("PRate")),
                          DataColumn(label: Text("Unit")),
                          DataColumn(label: Text("Sale Description")),
                          DataColumn(label: Text("Sale Price")),
                          DataColumn(label: Text("Qc/Stock")),
                          DataColumn(label: Text("Type/Group")),
                          DataColumn(label: Text("Min/Max")),
                          DataColumn(label: Text("Entry/Closing"))
                        ],
                        rows: provider.materialSearched.map((data) {
                          return DataRow(cells: [
                            DataCell(Text('${data['matno']}')),
                            DataCell(Text('${data['matDescription']}')),
                            DataCell(Text('${data['inentoryitem']}')),
                            DataCell(Text('${data['mst']}')),
                            DataCell(Text('${data['hsnCode']}')),
                            DataCell(Text('${data['prate']}')),
                            DataCell(Text('PU : ${data['puUnit']}\nSK: ${data['skUnit']}\nSpq : ${data['spq']}\nConFactor: ${data['conFactor']}\nSkRate : ${data['skrate']}')),
                            DataCell(Text('${data['saleDescription']}')),
                            DataCell(Text('Mrp: ${data['mrp']}\nListPrice: ${data['listPrice']}\nDiscount Type: ${data['discType'] ?? ""}\nDiscount Rate: ${data['discRate']}\nFixed Price: ${data['fixedPrice']}')),
                            DataCell(Text('IsQc: ${data['isQc']}\nIsStockKeeping: ${data['isStockKeeping']}')),
                            DataCell(Text('Type: ${data['materialType']}\nGroup: ${data['materialGroup']}\nSubGroup: ${data['materialSubGroup']}')),
                            DataCell(Text('Weight: ${data['weight']}\nLocation: ${data['location']}\nMinLevel:${data['minLevel']}\nMaxLevel : ${data['maxLevel']}\nReqLevel: ${data['reqLevel']}')),
                            DataCell(Text('Entry Date: ${data['doentry']}\nClosing Date: ${data['doclosing']}')),
                          ]);
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        )),
      );
    });
  }
}
