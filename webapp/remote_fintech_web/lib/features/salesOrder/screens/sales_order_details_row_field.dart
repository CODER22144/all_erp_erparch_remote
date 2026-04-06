import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';


class SalesOrderDetailsRowField extends StatefulWidget {
  final int index;
  final List<List<String>> tableRows;
  final Function deleteRow;
  final List<List<TextEditingController>> controllers;
  const SalesOrderDetailsRowField(
      {super.key,
        required this.index,
        required this.tableRows,
        required this.deleteRow,
        required this.controllers});

  @override
  State<SalesOrderDetailsRowField> createState() => _SalesOrderDetailsRowFieldState();
}

class _SalesOrderDetailsRowFieldState extends State<SalesOrderDetailsRowField> {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            controller: widget.controllers[widget.index][0],
            onChanged: (value) {
              setState(() {
                widget.tableRows[widget.index][0] = value;
              });
            },
            decoration: InputDecoration(
              label: RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: "*",
                      style: TextStyle(color: Colors.red),
                    )
                  ],
                  text: "Item Code",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
              border: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey)),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black, width: 0),
              ),
            ),
            validator: (String? val) {
              if (val == null || val.isEmpty) {
                return 'This field is Mandatory';
              }
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            validator: (String? val) {
              if (val == null || val.isEmpty) {
                return 'This field is Mandatory';
              }
            },
            controller: widget.controllers[widget.index][1],
            onChanged: (value) {
              setState(() {
                widget.tableRows[widget.index][1] = value;
              });
            },
            decoration: InputDecoration(
              label: RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: "*",
                      style: TextStyle(color: Colors.red),
                    )
                  ],
                  text: "Quantity",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
              border: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey)),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black, width: 0),
              ),
            ),
          ),
        ),

        SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: DataTable(
                  border: TableBorder.all(color: HexColor("#dee2e6")),

                  columns: const [
                DataColumn(label: Text("Material No.")),
                DataColumn(label: Text("Description")),
                DataColumn(label: Text("MRP")),
                DataColumn(label: Text("List Price")),
                DataColumn(label: Text("Rate")),
                DataColumn(label: Text("Discount")),
                DataColumn(label: Text("Discount Amount")),
              ], rows: [
                DataRow(color: WidgetStateProperty.resolveWith<Color?>(
                      (Set<WidgetState> states) {
                    // Alternate row color
                    return HexColor("#f2f2f2");
                  },
                ),cells: const [
                  DataCell(Text("BT5006")),
                  DataCell(Text("HP Dell Laptop")),
                  DataCell(Text("149999.00")),
                  DataCell(Text("145999.00")),
                  DataCell(Text("149999.00")),
                  DataCell(Text("10%")),
                  DataCell(Text("10000")),
                ]),
                DataRow(color: WidgetStateProperty.resolveWith<Color?>(
                      (Set<WidgetState> states) {
                    // Alternate row color
                    return HexColor("#f2f2f2");
                  },
                ),cells: const [
                  DataCell(Text("BT5006")),
                  DataCell(Text("HP Dell Laptop")),
                  DataCell(Text("149999.00")),
                  DataCell(Text("145999.00")),
                  DataCell(Text("149999.00")),
                  DataCell(Text("10%")),
                  DataCell(Text("10000")),
                ]),
                DataRow(color: WidgetStateProperty.resolveWith<Color?>(
    (Set<WidgetState> states) {
    // Alternate row color
    return HexColor("#f2f2f2");
    },
    ),cells: const [
                  DataCell(Text("BT5006")),
                  DataCell(Text("HP Dell Laptop")),
                  DataCell(Text("149999.00")),
                  DataCell(Text("145999.00")),
                  DataCell(Text("149999.00")),
                  DataCell(Text("10%")),
                  DataCell(Text("10000")),
                ])
              ]),
            ),
          ),
        )
      ],
    );
  }

}
