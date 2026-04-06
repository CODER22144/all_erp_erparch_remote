import 'dart:convert';

import 'package:fintech_new_web/features/utility/services/common_utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:searchable_paginated_dropdown/searchable_paginated_dropdown.dart';

import 'package:intl/intl.dart';
import '../../network/service/network_service.dart';

class CrNoteRowFields extends StatefulWidget {
  final int index;
  final List<List<String>> tableRows;
  final List<SearchableDropdownMenuItem<String>> materialUnit;
  final List<SearchableDropdownMenuItem<String>> hsnCode;
  final List<List<TextEditingController>> controllers;
  final Function deleteRow;
  const CrNoteRowFields(
      {super.key,
        required this.index,
        required this.tableRows,
        required this.deleteRow,
        required this.materialUnit,
        required this.controllers, required this.hsnCode});

  @override
  State<CrNoteRowFields> createState() =>
      _CrNoteRowFieldsState();
}

class _CrNoteRowFieldsState extends State<CrNoteRowFields> {
  DateTime? _selectedDate;

  SearchableDropdownController<String> unitController = SearchableDropdownController<String>();
  SearchableDropdownController<String> hsnController = SearchableDropdownController<String>();

  Future<void> _selectDate(BuildContext context, int index) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
        widget.controllers[widget.index][index].text = DateFormat('dd-MM-yyyy').format(pickedDate);
        widget.tableRows[widget.index][index] =
            DateFormat('MM-dd-yyyy').format(pickedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 10),
              child: Text(
                "SNo. : ${widget.index + 1}",
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    color: Colors.black),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8, right: 10),
              child: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  widget.deleteRow(widget.index);
                },
              ),
            )
          ],
        ),
        // Padding(
        //   padding: const EdgeInsets.all(8.0),
        //   child: TextFormField(
        //     controller: widget.controllers[widget.index][0],
        //     onChanged: (value) {
        //       setState(() {
        //         widget.tableRows[widget.index][0] = value;
        //       });
        //     },
        //     decoration: InputDecoration(
        //       floatingLabelBehavior: FloatingLabelBehavior.always,
        //       label: RichText(
        //         text: const TextSpan(
        //           text: "Voucher Type",
        //           style: TextStyle(
        //             fontSize: 14,
        //             color: Colors.black,
        //             fontWeight: FontWeight.w300,
        //           ),
        //         ),
        //       ),
        //       border: const OutlineInputBorder(
        //           borderSide: BorderSide(color: Colors.grey)),
        //       focusedBorder: const OutlineInputBorder(
        //         borderSide: BorderSide(color: Colors.black, width: 0),
        //       ),
        //     ),
        //   ),
        // ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            controller: widget.controllers[widget.index][1],
            onChanged: (value) async{
              setState(() {
                widget.tableRows[widget.index][1] = value;
              });
              NetworkService networkService = NetworkService();

              http.StreamedResponse response = await networkService.get(
                  "/get-material/$value/");

              if(response.statusCode == 200) {
                var data = jsonDecode(await response.stream.bytesToString())[0];
                setState(() {
                  widget.tableRows[widget.index][4] = data['saleDescription'];
                  widget.controllers[widget.index][4].text = data['saleDescription'];

                  widget.tableRows[widget.index][5] = data['hsnCode'];
                  hsnController.selectedItem.value = findDropdownMenuItem(widget.hsnCode, data['hsnCode']);

                  widget.tableRows[widget.index][8] = data['unit'];
                  unitController.selectedItem.value = findDropdownMenuItem(widget.materialUnit, data['unit']);

                  widget.tableRows[widget.index][7] = data['prate'];
                  widget.controllers[widget.index][7].text = data['prate'];

                  widget.tableRows[widget.index][11] = data['gstTaxRate'];
                  widget.controllers[widget.index][11].text = data['gstTaxRate'];

                });

              } else {
                widget.tableRows[widget.index][4] = "";
                widget.controllers[widget.index][4].text = "";

                widget.tableRows[widget.index][5] = "";
                hsnController.clear();

                widget.tableRows[widget.index][8] = "";
                unitController.clear();

                widget.tableRows[widget.index][11] = "0";
                widget.controllers[widget.index][11].text = "0";

                widget.tableRows[widget.index][7] = "0";
                widget.controllers[widget.index][7].text = "0";
              }

              calculateTotalAmount();

            },
            decoration: InputDecoration(
              floatingLabelBehavior: FloatingLabelBehavior.always,
              label: RichText(
                text: const TextSpan(
                  text: "Material No.",
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
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            controller: widget.controllers[widget.index][4],
            onChanged: (value) {
              setState(() {
                widget.tableRows[widget.index][4] = value;
              });
            },
            decoration: InputDecoration(
              floatingLabelBehavior: FloatingLabelBehavior.always,
              label: RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                        text: "*",
                        style: TextStyle(color: Colors.red)
                    )
                  ],
                  text: "Product Description",
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
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            controller: widget.controllers[widget.index][2],
            onChanged: (value) {
              setState(() {
                widget.tableRows[widget.index][2] = value;
              });
            },
            decoration: InputDecoration(
              floatingLabelBehavior: FloatingLabelBehavior.always,
              label: RichText(
                text: const TextSpan(
                  text: "Org. Invoice No",
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
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            controller: widget.controllers[widget.index][3],
            onChanged: (value) {
              setState(() {
                widget.tableRows[widget.index][3] = value;
              });
            },
            readOnly: true,
            onTap: () {
              _selectDate(context, 3);
            },
            decoration: InputDecoration(
              floatingLabelBehavior: FloatingLabelBehavior.always,
              label: RichText(
                text: const TextSpan(
                  text: "Org Invoice Date",
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
        Stack(
          children: [
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: SearchableDropdown<String>(
                  isEnabled: true,
                  backgroundDecoration: (child) => Container(
                    height: 40,
                    margin: EdgeInsets.zero,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.black, width: 0.5),
                    ),
                    child: child,
                  ),
                  controller: hsnController,
                  items: widget.hsnCode,
                  onChanged: (value) async {
                    setState(() {
                      widget.tableRows[widget.index][5] = value!;
                    });

                    NetworkService networkService = NetworkService();
                    http.StreamedResponse response = await networkService
                        .get("/get-hsn-code/$value/");
                    if(response.statusCode == 200) {
                      widget.controllers[widget.index][11].text = jsonDecode(await response.stream.bytesToString())[0]['gstTaxRate'].toString();
                    } else {
                      widget.controllers[widget.index][11].text = "0.00";
                    }
                    widget.tableRows[widget.index][11] = widget.controllers[widget.index][11].text;

                    calculateTotalAmount();

                  },
                  hasTrailingClearIcon: false,
                )),
            Positioned(
              left: 15,
              top: 1,
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: const Wrap(
                  children: [
                    Text(
                      "Hsn code",
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      "*",
                      style: TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            controller: widget.controllers[widget.index][6],
            onChanged: (value) {
              setState(() {
                widget.tableRows[widget.index][6] = value;
              });
              calculateTotalAmount();
            },
            decoration: InputDecoration(
              floatingLabelBehavior: FloatingLabelBehavior.always,
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
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            controller: widget.controllers[widget.index][7],
            onChanged: (value) {
              setState(() {
                widget.tableRows[widget.index][7] = value;
              });
              calculateTotalAmount();
            },
            decoration: InputDecoration(
              floatingLabelBehavior: FloatingLabelBehavior.always,
              label: RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: "*",
                      style: TextStyle(color: Colors.red),
                    )
                  ],
                  text: "Unit Price",
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
        Stack(
          children: [
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: SearchableDropdown<String>(
                  isEnabled: true,
                  backgroundDecoration: (child) => Container(
                    height: 40,
                    margin: EdgeInsets.zero,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.black, width: 0.5),
                    ),
                    child: child,
                  ),
                  controller: unitController,
                  items: widget.materialUnit,
                  onChanged: (value) {
                    setState(() {
                      widget.tableRows[widget.index][8] = value!;
                    });
                  },
                  hasTrailingClearIcon: false,
                )),
            Positioned(
              left: 15,
              top: 1,
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: const Wrap(
                  children: [
                    Text(
                      "Material Unit",
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      "*",
                      style: TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            controller: widget.controllers[widget.index][14],
            onChanged: (value) {
              setState(() {
                widget.tableRows[widget.index][14] = value;
              });
            },
            readOnly: true,
            decoration: InputDecoration(
              floatingLabelBehavior: FloatingLabelBehavior.always,
              label: RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: "*",
                      style: TextStyle(color: Colors.red),
                    )
                  ],
                  text: "Amount",
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
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            controller: widget.controllers[widget.index][10],
            onChanged: (value) {
              setState(() {
                widget.tableRows[widget.index][10] = value;
              });
              calculateTotalAmount();
            },
            decoration: InputDecoration(
              floatingLabelBehavior: FloatingLabelBehavior.always,
              label: RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: "*",
                      style: TextStyle(color: Colors.red),
                    )
                  ],
                  text: "Discount",
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
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            controller: widget.controllers[widget.index][9],
            onChanged: (value) {
              setState(() {
                widget.tableRows[widget.index][9] = value;
              });
            },
            readOnly: true,
            decoration: InputDecoration(
              floatingLabelBehavior: FloatingLabelBehavior.always,
              label: RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: "*",
                      style: TextStyle(color: Colors.red),
                    )
                  ],
                  text: "Assessable Amount",
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
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            controller: widget.controllers[widget.index][11],
            onChanged: (value) {
              setState(() {
                widget.tableRows[widget.index][11] = value;
              });
              calculateTotalAmount();
            },
            decoration: InputDecoration(
              floatingLabelBehavior: FloatingLabelBehavior.always,
              label: RichText(
                text: const TextSpan(
                  text: "Gst Tax Rate",
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
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            controller: widget.controllers[widget.index][12],
            onChanged: (value) {
              setState(() {
                widget.tableRows[widget.index][12] = value;
              });
            },
            readOnly: true,
            decoration: InputDecoration(
              floatingLabelBehavior: FloatingLabelBehavior.always,
              label: RichText(
                text: const TextSpan(
                  text: "Gst Amount",
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
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            controller: widget.controllers[widget.index][13],
            onChanged: (value) {
              setState(() {
                widget.tableRows[widget.index][13] = value;
              });
            },
            readOnly: true,
            decoration: InputDecoration(
              floatingLabelBehavior: FloatingLabelBehavior.always,
              label: RichText(
                text: const TextSpan(
                  text: "Total Amount",
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
      ],
    );
  }

  void calculateTotalAmount() {
    double amount = 0;
    double gstAmount = 0;
    double totalAmount = 0;

    amount = parseEmptyStringToDouble(widget.tableRows[widget.index][6]) *
        parseEmptyStringToDouble(widget.tableRows[widget.index][7]);

    setState(() {
      widget.tableRows[widget.index][14] = amount.toStringAsFixed(2);
      widget.controllers[widget.index][14].text = amount.toStringAsFixed(2);
    });

    amount =
        amount - parseEmptyStringToDouble(widget.tableRows[widget.index][10]);
    gstAmount = amount *
        parseEmptyStringToDouble(widget.tableRows[widget.index][11]) *
        0.01;
    totalAmount = amount + gstAmount;

    setState(() {
      widget.tableRows[widget.index][9] = amount.toStringAsFixed(2);
      widget.controllers[widget.index][9].text = amount.toStringAsFixed(2);

      widget.tableRows[widget.index][12] = gstAmount.toStringAsFixed(2);
      widget.controllers[widget.index][12].text = gstAmount.toStringAsFixed(2);

      widget.controllers[widget.index][13].text =
          totalAmount.toStringAsFixed(2);
    });
  }
}
