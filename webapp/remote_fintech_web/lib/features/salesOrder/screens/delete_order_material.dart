import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../common/widgets/comman_appbar.dart';
import '../../common/widgets/pop_ups.dart';
import '../../home.dart';
import '../../utility/global_variables.dart';
import '../provider/sales_order_provider.dart';

class DeleteOrderMaterial extends StatefulWidget {
  static String routeName = "deleteOrderAddItem";
  final String orderId;
  const DeleteOrderMaterial({super.key, required this.orderId});

  @override
  State<DeleteOrderMaterial> createState() => _DeleteOrderMaterialState();
}

class _DeleteOrderMaterialState extends State<DeleteOrderMaterial> {
  List<List<String>> tableRows = [];

  @override
  void initState() {
    super.initState();
    SalesOrderProvider provider =
        Provider.of<SalesOrderProvider>(context, listen: false);
    provider.getOrderMaterial(widget.orderId);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child:
            Consumer<SalesOrderProvider>(builder: (context, provider, child) {
          return Scaffold(
            appBar: PreferredSize(
                preferredSize:
                    Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
                child: CommonAppbar(
                    title: 'Delete Item From Order : ${widget.orderId}')),
            body: SingleChildScrollView(
              child: Center(
                child: SizedBox(
                  width:GlobalVariables.deviceWidth,
                  child: provider.orderMaterial.isNotEmpty ? DataTable(
                    columns: const [
                      DataColumn(label: Text("Order ID")),
                      DataColumn(label: Text("Item Code")),
                      DataColumn(label: Text("Item Description")),
                      DataColumn(label: Text("Hsn code")),
                      DataColumn(label: Text("Quantity")),
                      DataColumn(label: Text("Rate")),
                      DataColumn(label: Text("Amount")),
                      DataColumn(label: Text("Action")),
                    ],
                    rows: provider.orderMaterial.map((data) {
                      return DataRow(cells: [
                        DataCell(Text(widget.orderId)),
                        DataCell(Text('${data['icode'] ?? ""}')),
                        DataCell(Text('${data['saleDescription'] ?? ""}')),
                        DataCell(Text('${data['hsnCode'] ?? ""}')),
                        DataCell(Text('${data['qty'] ?? ""}')),
                        DataCell(Text('${data['rate'] ?? ""}')),
                        DataCell(Text('${data['amount'] ?? ""}')),
                        DataCell(IconButton(
                          icon: const Icon(Icons.delete,
                              color: Colors.red),
                          onPressed: () {
                            provider.deleteOrderMaterial('${data['odId'] ?? ""}', widget.orderId);
                          },
                        )),
                      ]);
                    }).toList(),
                  ) : const SizedBox(),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
