import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/widgets/comman_appbar.dart';
import '../../utility/services/common_utility.dart';
import '../provider/material_provider.dart';

class MatStockReport extends StatefulWidget {
  static const String routeName = "MatStockReport";

  const MatStockReport({super.key});

  @override
  State<MatStockReport> createState() => _MatStockReportState();
}

class _MatStockReportState extends State<MatStockReport> {
  @override
  void initState() {
    super.initState();
    MaterialProvider provider =
    Provider.of<MaterialProvider>(context, listen: false);
    provider.getMaterialStockReport();
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
                  child: const CommonAppbar(title: 'Material Stock Report')),
              body: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Visibility(
                      visible: provider.materialStockReport.isNotEmpty,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 5),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(5)),
                              ),
                            ),
                            onPressed: () async {
                              downloadJsonToExcel(provider.materialStockReport, "mat_stock_export");
                            },
                            child: const Text(
                              'Export Stock',
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                          ),
                          const SizedBox(height: 10),
                          DataTable(
                            columns: const [
                              DataColumn(label: Text("Material No.")),
                              DataColumn(label: Text("Description")),
                              DataColumn(label: Text("Hsn Code")),
                              DataColumn(label: Text("Min Level")),
                              DataColumn(label: Text("Max Level")),
                              DataColumn(label: Text("Req. Level")),
                              DataColumn(label: Text("Opening")),
                              DataColumn(label: Text("Received")),
                              DataColumn(label: Text("Released")),
                              DataColumn(label: Text("Qty In Stock"))
                            ],
                            rows: provider.rows,
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
