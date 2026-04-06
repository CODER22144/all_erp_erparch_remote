import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/widgets/comman_appbar.dart';
import '../../utility/services/common_utility.dart';
import '../provider/material_provider.dart';

class StockValueReport extends StatefulWidget {
  static const String routeName = "StockValueReport";

  const StockValueReport({super.key});

  @override
  State<StockValueReport> createState() => _StockValueReportState();
}

class _StockValueReportState extends State<StockValueReport> {
  @override
  void initState() {
    super.initState();
    MaterialProvider provider =
    Provider.of<MaterialProvider>(context, listen: false);
    provider.getStockValueReport();
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
                  child: const CommonAppbar(title: 'Stock Value')),
              body: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Visibility(
                      visible: provider.stockValueRep.isNotEmpty,
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
                              downloadJsonToExcel(provider.stockValueRep, "stock_value_export");
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
                              DataColumn(label: Text("Opening")),
                              DataColumn(label: Text("Received")),
                              DataColumn(label: Text("Released")),
                              DataColumn(label: Text("Qty In Stock")),
                              DataColumn(label: Text("Amount")),
                            ],
                            rows: provider.stockValueRows,
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
