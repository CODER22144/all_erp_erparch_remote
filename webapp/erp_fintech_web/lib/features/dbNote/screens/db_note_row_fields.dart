import 'dart:convert';

import 'package:fintech_new_web/features/utility/services/common_utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:searchable_paginated_dropdown/searchable_paginated_dropdown.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../network/service/network_service.dart';
import '../../utility/global_variables.dart';
import '../provider/dbnote_provider.dart';

class DbnoteRowFields extends StatefulWidget {
  final int index;
  final List<List<String>> tableRows;
  final List<SearchableDropdownMenuItem<String>> discountType;
  final List<SearchableDropdownMenuItem<String>> materialUnit;
  final List<SearchableDropdownMenuItem<String>> yesno;
  final Function deleteRow;
  final List<List<TextEditingController>> controllers;
  const DbnoteRowFields(
      {super.key,
      required this.index,
      required this.tableRows,
      required this.discountType,
      required this.deleteRow,
      required this.materialUnit,
      required this.yesno,
      required this.controllers});

  @override
  State<DbnoteRowFields> createState() => _DbnoteRowFieldsState();
}

class _DbnoteRowFieldsState extends State<DbnoteRowFields> {
  bool checkRatePercentage = true;
  bool checkDiscAmount = true;

  double amount = 0;
  double discAmount = 0;
  double cessAmount = 0;
  double gstAmount = 0;
  double totalAmount = 0;

  SearchableDropdownController<String> unitController =
      SearchableDropdownController();

  TextEditingController dateController = TextEditingController();
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    widget.controllers[widget.index][6].text = widget.tableRows[widget.index][6];
  }

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
        dateController.text = DateFormat('dd-MM-yyyy').format(pickedDate);
        // GlobalVariables.requestBody[widget.feature][widget.field.id] =
        //     DateFormat('MM-dd-yyyy').format(pickedDate);
        widget.tableRows[widget.index][index] = DateFormat('MM-dd-yyyy').format(pickedDate);
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
              floatingLabelBehavior: FloatingLabelBehavior.always,
              label: RichText(
                text: const TextSpan(
                  text: "Narration",
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
            controller: widget.controllers[widget.index][1],
            decoration: InputDecoration(
              suffix: ElevatedButton(
                  onPressed: () async {
                    NetworkService networkService = NetworkService();
                    http.StreamedResponse response =
                        await networkService.post("/get-mat-wh/", {
                      "bpCode": GlobalVariables
                          .requestBody[DbnoteProvider.featureName]['lcode'],
                      "matno": widget.controllers[widget.index][1].text
                    });
                    if (response.statusCode == 200) {
                      getMaterialTab(context,
                          jsonDecode(await response.stream.bytesToString()));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3), // Square shape
                    ),
                    padding:
                        const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                  ),
                  child: const Text(
                    "Details",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  )),
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
            validator: (String? val) {
              if (val == null || val.isEmpty) {
                return 'This field is Mandatory';
              }
            },
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
                  children: [
                    TextSpan(
                      text: "*",
                      style: TextStyle(color: Colors.red),
                    )
                  ],
                  text: "HSN Code",
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
            decoration: InputDecoration(
              floatingLabelBehavior: FloatingLabelBehavior.always,
              label: RichText(
                text: const TextSpan(
                  text: "Bill No.",
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
            // controller: widget.controllers[widget.index][4],
            controller: dateController,
            readOnly: true,
            // onChanged: (value) {
            //   setState(() {
            //     widget.tableRows[widget.index][4] = value;
            //   });
            // },
            onTap: () => _selectDate(context, 4),
            decoration: InputDecoration(
              floatingLabelBehavior: FloatingLabelBehavior.always,
              label: RichText(
                text: const TextSpan(
                  text: "Bill Date",
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
            validator: (String? val) {
              if (val == null || val.isEmpty) {
                return 'This field is Mandatory';
              }
            },
            controller: widget.controllers[widget.index][5],
            onChanged: (value) {
              setState(() {
                widget.tableRows[widget.index][5] = value;
              });
              calculateTotalAmount(widget.index);
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
        Stack(
          children: [
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: SearchableDropdown<String>(
                  controller: unitController,
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
                  items: widget.materialUnit,
                  onChanged: (value) {
                    setState(() {
                      widget.tableRows[widget.index][19] = value!;
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
            validator: (String? val) {
              if (val == null || val.isEmpty) {
                return 'This field is Mandatory';
              }
            },
            controller: widget.controllers[widget.index][6],
            onChanged: (value) {
              setState(() {
                widget.tableRows[widget.index][6] = value;
                widget.controllers[widget.index][6].text = value;

                widget.controllers[widget.index][6].selection = TextSelection.fromPosition(
                    TextPosition(offset: widget.controllers[widget.index][6].text.length));
              });
              calculateTotalAmount(widget.index);
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
                  text: "Rate",
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
            validator: (String? val) {
              if (val == null || val.isEmpty) {
                return 'This field is Mandatory';
              }
            },
            onChanged: (value) {
              setState(() {
                widget.tableRows[widget.index][7] = value;
              });
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
        Stack(
          children: [
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: SearchableDropdown<String>(
                  controller: SearchableDropdownController<String>(
                      initialItem: const SearchableDropdownMenuItem(
                          value: "N", label: "None", child: Text("None"))),
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
                  items: widget.discountType,
                  onChanged: (value) {
                    setState(() {
                      widget.tableRows[widget.index][8] = value!;
                      if (value == "N") {
                        widget.tableRows[widget.index][9] = "0"; // disc Rate
                        widget.controllers[widget.index][9].text = "0";

                        widget.controllers[widget.index][10].text = "0";
                        widget.tableRows[widget.index][10] = "0"; // disc Amount
                        discAmount = 0;
                        checkRatePercentage = true;
                        checkDiscAmount = true;
                      }
                      if (value == "F") {
                        widget.tableRows[widget.index][9] = "0"; // disc Rate
                        widget.controllers[widget.index][9].text = "0";

                        widget.tableRows[widget.index][10] = "0"; // disc Amount
                        widget.controllers[widget.index][10].text = "0";
                        discAmount = 0;
                        checkRatePercentage = true;
                        checkDiscAmount = false;
                      }
                      if (value == "P") {
                        widget.controllers[widget.index][10].text = "0";
                        checkRatePercentage = false;
                        checkDiscAmount = false;
                      }
                    });
                    calculateTotalAmount(widget.index);
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
                      "Discount Type",
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
            validator: (String? val) {
              if (val == null || val.isEmpty) {
                return 'This field is Mandatory';
              }
            },
            readOnly: checkRatePercentage,
            controller: widget.controllers[widget.index][9],
            onChanged: (value) {
              setState(() {
                widget.tableRows[widget.index][9] = value;
                if (widget.tableRows[widget.index][8] == "P") {
                  discAmount = parseEmptyStringToDouble(
                          widget.tableRows[widget.index][5]) *
                      parseEmptyStringToDouble(
                          widget.tableRows[widget.index][6]) *
                      parseEmptyStringToDouble(
                          widget.tableRows[widget.index][9]) *
                      0.01;

                  widget.tableRows[widget.index][10] =
                      discAmount.toStringAsFixed(2);
                  widget.controllers[widget.index][10].text = discAmount.toStringAsFixed(2);


                    gstAmount = ((parseEmptyStringToDouble(
                                    widget.tableRows[widget.index][5]) *
                                parseEmptyStringToDouble(
                                    widget.tableRows[widget.index][6])) -
                            discAmount) *
                        parseEmptyStringToDouble(
                            widget.tableRows[widget.index][15]) *
                        0.01;

                    widget.tableRows[widget.index][16] =
                        gstAmount.toStringAsFixed(2);
                  widget.controllers[widget.index][16].text =
                      gstAmount.toStringAsFixed(2);



                    cessAmount = ((parseEmptyStringToDouble(
                                    widget.tableRows[widget.index][5]) *
                                parseEmptyStringToDouble(
                                    widget.tableRows[widget.index][6])) -
                            parseEmptyStringToDouble(
                                widget.controllers[widget.index][10].text)) *
                        parseEmptyStringToDouble(
                            widget.tableRows[widget.index][13]) *
                        0.01;

                    widget.tableRows[widget.index][14] =
                        cessAmount.toStringAsFixed(2);
                  widget.controllers[widget.index][14].text =
                      cessAmount.toStringAsFixed(2);

                    totalAmount = ((parseEmptyStringToDouble(
                                    widget.tableRows[widget.index][5]) *
                                parseEmptyStringToDouble(
                                    widget.tableRows[widget.index][6])) -
                            discAmount) +
                        cessAmount +
                        gstAmount +
                        parseEmptyStringToDouble(
                            widget.tableRows[widget.index][17]) +
                        parseEmptyStringToDouble(
                            widget.tableRows[widget.index][11]) +
                        parseEmptyStringToDouble(
                            widget.tableRows[widget.index][12]);

                    widget.tableRows[widget.index][18] =
                        totalAmount.toStringAsFixed(2);
                  widget.controllers[widget.index][18].text =
                      totalAmount.toStringAsFixed(2);

                }
                widget.controllers[widget.index][9].selection = TextSelection.fromPosition(
                    TextPosition(offset: widget.controllers[widget.index][9].text.length));
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
                  text: "Discount Percentage",
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
            validator: (String? val) {
              if (val == null || val.isEmpty) {
                return 'This field is Mandatory';
              }
            },
            controller: widget.controllers[widget.index][10],
            readOnly: checkDiscAmount,
            onChanged: (value) {
              setState(() {
                if (widget.tableRows[widget.index][8] == "F") {
                  widget.tableRows[widget.index][10] = value;
                  widget.controllers[widget.index][10].text = value;

                  widget.tableRows[widget.index][9] = "0";
                  widget.controllers[widget.index][9].text = "0";

                  discAmount = parseEmptyStringToDouble(value);
                    gstAmount = ((parseEmptyStringToDouble(
                                    widget.tableRows[widget.index][5]) *
                                parseEmptyStringToDouble(
                                    widget.tableRows[widget.index][6])) -
                            discAmount) *
                        parseEmptyStringToDouble(
                            widget.tableRows[widget.index][15]) *
                        0.01;

                    widget.tableRows[widget.index][16] =
                        gstAmount.toStringAsFixed(2);
                  widget.controllers[widget.index][16].text =
                      gstAmount.toStringAsFixed(2);



                    cessAmount = ((parseEmptyStringToDouble(
                                    widget.tableRows[widget.index][5]) *
                                parseEmptyStringToDouble(
                                    widget.tableRows[widget.index][6])) -
                            parseEmptyStringToDouble(
                                widget.controllers[widget.index][10].text)) *
                        parseEmptyStringToDouble(
                            widget.tableRows[widget.index][13]) *
                        0.01;

                    widget.tableRows[widget.index][14] =
                        cessAmount.toStringAsFixed(2);
                  widget.controllers[widget.index][14].text =
                      cessAmount.toStringAsFixed(2);


                    totalAmount = ((parseEmptyStringToDouble(
                                    widget.tableRows[widget.index][5]) *
                                parseEmptyStringToDouble(
                                    widget.tableRows[widget.index][6])) -
                            discAmount) +
                        cessAmount +
                        gstAmount +
                        parseEmptyStringToDouble(
                            widget.tableRows[widget.index][17]) +
                        parseEmptyStringToDouble(
                            widget.tableRows[widget.index][11]) +
                        parseEmptyStringToDouble(
                            widget.tableRows[widget.index][12]);

                    widget.tableRows[widget.index][18] =
                        totalAmount.toStringAsFixed(2);
                  widget.controllers[widget.index][18].text =
                      totalAmount.toStringAsFixed(2);

                }
                widget.controllers[widget.index][10].selection = TextSelection.fromPosition(
                    TextPosition(offset: widget.controllers[widget.index][10].text.length));
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
                  text: "Discount Amount",
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
        Visibility(
          visible: false,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: widget.controllers[widget.index][11],
              onChanged: (value) {
                setState(() {
                  widget.tableRows[widget.index][11] = value;

                    gstAmount = ((parseEmptyStringToDouble(
                                    widget.tableRows[widget.index][5]) *
                                parseEmptyStringToDouble(
                                    widget.tableRows[widget.index][6])) -
                            discAmount) *
                        parseEmptyStringToDouble(
                            widget.tableRows[widget.index][15]) *
                        0.01;
                    widget.tableRows[widget.index][16] =
                        gstAmount.toStringAsFixed(2);
                  widget.controllers[widget.index][16].text =
                      gstAmount.toStringAsFixed(2);



                    cessAmount = ((parseEmptyStringToDouble(
                                    widget.tableRows[widget.index][5]) *
                                parseEmptyStringToDouble(
                                    widget.tableRows[widget.index][6])) -
                            parseEmptyStringToDouble(
                                widget.controllers[widget.index][10].text)) *
                        parseEmptyStringToDouble(
                            widget.tableRows[widget.index][13]) *
                        0.01;
                    widget.tableRows[widget.index][14] =
                        cessAmount.toStringAsFixed(2);
                  widget.controllers[widget.index][14].text =
                      cessAmount.toStringAsFixed(2);

                    totalAmount = ((parseEmptyStringToDouble(
                                    widget.tableRows[widget.index][5]) *
                                parseEmptyStringToDouble(
                                    widget.tableRows[widget.index][6])) -
                            discAmount) +
                        cessAmount +
                        gstAmount +
                        parseEmptyStringToDouble(
                            widget.tableRows[widget.index][17]) +
                        parseEmptyStringToDouble(
                            widget.tableRows[widget.index][11]) +
                        parseEmptyStringToDouble(
                            widget.tableRows[widget.index][12]);
                    widget.tableRows[widget.index][18] =
                        totalAmount.toStringAsFixed(2);
                  widget.controllers[widget.index][18].text =
                      totalAmount.toStringAsFixed(2);

                });
              },
              decoration: InputDecoration(
                label: RichText(
                  text: const TextSpan(
                    text: "Basic Custom Duty (BCD)",
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
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            validator: (String? val) {
              if (val == null || val.isEmpty) {
                return 'This field is Mandatory';
              }
            },
            controller: widget.controllers[widget.index][12],
            onChanged: (value) {
              setState(() {
                widget.tableRows[widget.index][12] = value;
                totalAmount = ((parseEmptyStringToDouble(
                                widget.tableRows[widget.index][5]) *
                            parseEmptyStringToDouble(
                                widget.tableRows[widget.index][6])) -
                        discAmount) +
                    cessAmount +
                    gstAmount +
                    parseEmptyStringToDouble(
                        widget.tableRows[widget.index][17]) +
                    parseEmptyStringToDouble(
                        widget.tableRows[widget.index][11]) +
                    parseEmptyStringToDouble(value);

                widget.tableRows[widget.index][18] =
                    totalAmount.toStringAsFixed(2);
                widget.controllers[widget.index][18].text =
                    totalAmount.toStringAsFixed(2);
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
                  text: "Round Off.",
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
            validator: (String? val) {
              if (val == null || val.isEmpty) {
                return 'This field is Mandatory';
              }
            },
            controller: widget.controllers[widget.index][13],
            onChanged: (value) {
              setState(() {
                widget.tableRows[widget.index][13] = value;


                  gstAmount = ((parseEmptyStringToDouble(
                                  widget.tableRows[widget.index][5]) *
                              parseEmptyStringToDouble(
                                  widget.tableRows[widget.index][6])) -
                          discAmount) *
                      parseEmptyStringToDouble(
                          widget.tableRows[widget.index][15]) *
                      0.01;
                  widget.tableRows[widget.index][16] =
                      gstAmount.toStringAsFixed(2);
                  widget.controllers[widget.index][16].text =
                      gstAmount.toStringAsFixed(2);

                  cessAmount = ((parseEmptyStringToDouble(
                                  widget.tableRows[widget.index][5]) *
                              parseEmptyStringToDouble(
                                  widget.tableRows[widget.index][6])) -
                          parseEmptyStringToDouble(widget.controllers[widget.index][10].text)) *
                      parseEmptyStringToDouble(value) *
                      0.01;
                  widget.tableRows[widget.index][14] =
                      cessAmount.toStringAsFixed(2);
                widget.controllers[widget.index][14].text =
                    cessAmount.toStringAsFixed(2);


                  totalAmount = ((parseEmptyStringToDouble(
                                  widget.tableRows[widget.index][5]) *
                              parseEmptyStringToDouble(
                                  widget.tableRows[widget.index][6])) -
                          discAmount) +
                      cessAmount +
                      gstAmount +
                      parseEmptyStringToDouble(
                          widget.tableRows[widget.index][17]) +
                      parseEmptyStringToDouble(
                          widget.tableRows[widget.index][11]) +
                      parseEmptyStringToDouble(
                          widget.tableRows[widget.index][12]);
                  widget.tableRows[widget.index][18] =
                      totalAmount.toStringAsFixed(2);
                widget.controllers[widget.index][18].text =
                    totalAmount.toStringAsFixed(2);

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
                  text: "Cess Rate",
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
            validator: (String? val) {
              if (val == null || val.isEmpty) {
                return 'This field is Mandatory';
              }
            },
            controller: widget.controllers[widget.index][14],
            onChanged: (value) {
              setState(() {
                widget.tableRows[widget.index][14] = value;
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
                  text: "Cess Amount",
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
            validator: (String? val) {
              if (val == null || val.isEmpty) {
                return 'This field is Mandatory';
              }
            },
            controller: widget.controllers[widget.index][15],
            onChanged: (value) {
              setState(() {
                widget.tableRows[widget.index][15] = value;
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
            validator: (String? val) {
              if (val == null || val.isEmpty) {
                return 'This field is Mandatory';
              }
            },
            controller: widget.controllers[widget.index][16],

            onChanged: (value) {
              setState(() {
                widget.tableRows[widget.index][16] = value;
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
                  text: "GST Amount",
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
        Visibility(
          visible: false,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              validator: (String? val) {
                if (val == null || val.isEmpty) {
                  return 'This field is Mandatory';
                }
              },
              controller: widget.controllers[widget.index][17],
              onChanged: (value) {
                setState(() {
                  widget.tableRows[widget.index][17] = value;
                  totalAmount = ((parseEmptyStringToDouble(
                                  widget.tableRows[widget.index][5]) *
                              parseEmptyStringToDouble(
                                  widget.tableRows[widget.index][6])) -
                          discAmount) +
                      cessAmount +
                      gstAmount +
                      parseEmptyStringToDouble(
                          widget.tableRows[widget.index][17]) +
                      parseEmptyStringToDouble(
                          widget.tableRows[widget.index][11]) +
                      parseEmptyStringToDouble(
                          widget.tableRows[widget.index][12]);
                  widget.tableRows[widget.index][18] =
                      totalAmount.toStringAsFixed(2);
                  widget.controllers[widget.index][18].text =
                      totalAmount.toStringAsFixed(2);
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
                    text: "TCS Amount",
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
        ),
        Stack(
          children: [
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: SearchableDropdown<String>(
                  controller: SearchableDropdownController(initialItem: findDropdownMenuItem(widget.yesno, "N")),
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
                  items: widget.yesno,
                  onChanged: (value) {
                    setState(() {
                      widget.tableRows[widget.index][22] = value!;
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
                      "StockLess",
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
            validator: (String? val) {
              if (val == null || val.isEmpty) {
                return 'This field is Mandatory';
              }
            },
            controller: widget.controllers[widget.index][18],

            onChanged: (value) {
              setState(() {
                widget.tableRows[widget.index][18] = value;
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
        )
      ],
    );
  }

  void calculateTotalAmount(int i) {
    setState(() {
      amount = parseEmptyStringToDouble(widget.tableRows[widget.index][5]) *
          parseEmptyStringToDouble(widget.tableRows[widget.index][6]);
      widget.tableRows[widget.index][7] = amount.toStringAsFixed(2);
      widget.controllers[widget.index][7].text = amount.toStringAsFixed(2);

      if (widget.tableRows[widget.index][8] == "P") {
        discAmount = (amount *
            parseEmptyStringToDouble(widget.tableRows[widget.index][9]) *
            0.01);
        widget.controllers[widget.index][10].text = discAmount.toStringAsFixed(2);
      }
    });
    // GST TAX AMOUNT
    setState(() {
      gstAmount = ((parseEmptyStringToDouble(
                      widget.tableRows[widget.index][5]) *
                  parseEmptyStringToDouble(widget.tableRows[widget.index][6])) -
              discAmount) *
          parseEmptyStringToDouble(widget.tableRows[widget.index][15]) *
          0.01;
      widget.tableRows[widget.index][16] = gstAmount.toStringAsFixed(2);
      widget.controllers[widget.index][16].text = gstAmount.toStringAsFixed(2);

    });

    // CESS AMOUNT AND TOTAL AMOUNT
    setState(() {
      cessAmount = ((parseEmptyStringToDouble(
                      widget.tableRows[widget.index][5]) *
                  parseEmptyStringToDouble(widget.tableRows[widget.index][6])) -
              parseEmptyStringToDouble(widget.controllers[widget.index][10].text)) *
          parseEmptyStringToDouble(widget.tableRows[widget.index][13]) *
          0.01;
      widget.tableRows[widget.index][14] = cessAmount.toStringAsFixed(2);
      widget.controllers[widget.index][14].text = cessAmount.toStringAsFixed(2);

      totalAmount = ((parseEmptyStringToDouble(
                      widget.tableRows[widget.index][5]) *
                  parseEmptyStringToDouble(widget.tableRows[widget.index][6])) -
              discAmount) +
          cessAmount +
          gstAmount +
          parseEmptyStringToDouble(widget.tableRows[widget.index][17]) +
          parseEmptyStringToDouble(widget.tableRows[widget.index][11]) +
          parseEmptyStringToDouble(widget.tableRows[widget.index][12]);
      widget.tableRows[widget.index][18] = totalAmount.toStringAsFixed(2);
      widget.controllers[widget.index][18].text = totalAmount.toStringAsFixed(2);
    });
  }

  void getMaterialTab(BuildContext context, List<dynamic> orderData) {
    List<DataRow> rows = [];
    for (var data in orderData) {
      rows.add(DataRow(cells: [
        DataCell(Text('${data['vtype'] ?? "-"}')),
        DataCell(Text('${data['wdocno'] ?? "-"}')),
        DataCell(Text('${data['bpCode'] ?? "-"}')),
        DataCell(Text('${data['matno'] ?? "-"}')),
        DataCell(Text('${data['billNo'] ?? "-"}')),
        DataCell(Text('${data['billDate'] ?? "-"}')),
        DataCell(Text('${data['hsnCode'] ?? "-"}')),
        DataCell(Text('${data['rgst'] ?? "-"}')),
        DataCell(Text('${data['prate'] ?? "-"}')),
        DataCell(Text('${data['bqty'] ?? "-"}')),
        DataCell(ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(3), // Square shape
              ),
              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
            ),
            onPressed: () {
              setState(() {
                widget.tableRows[widget.index][1] = widget.controllers[widget.index][1].text;

                widget.tableRows[widget.index][2] = data['hsnCode'] ?? "";
                widget.controllers[widget.index][2].text = data['hsnCode'] ?? "";

                widget.tableRows[widget.index][6] = data['prate'] ?? "0";
                widget.controllers[widget.index][6].text = data['prate'] ?? "0";

                widget.tableRows[widget.index][15] = data['rgst'] ?? "0";
                widget.controllers[widget.index][15].text = data['rgst'] ?? "0";

                widget.controllers[widget.index][3].text = '${data['billNo'] ?? ""}';
                widget.tableRows[widget.index][3] = '${data['billNo'] ?? ""}';

                widget.controllers[widget.index][4].text = '${data['billDate'] ?? ""}';
                widget.tableRows[widget.index][4] = '${data['billDate'] ?? ""}';

                widget.controllers[widget.index][5].text = '${data['bqty'] ?? ""}';
                widget.tableRows[widget.index][5] = '${data['bqty'] ?? ""}';

                // set vtype and docno
                widget.tableRows[widget.index][20] = '${data['vtype'] ?? ""}';
                widget.tableRows[widget.index][21] = '${data['wdocno'] ?? ""}';
              });
              calculateTotalAmount(widget.index);
              context.pop();
            },
            child: const Text(
              "Select",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ))),
      ]));
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Materials',
              style: TextStyle(fontWeight: FontWeight.w500)),
          content: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DataTable(
                    columns: const [
                      DataColumn(label: Text('VType')),
                      DataColumn(label: Text('Docno.')),
                      DataColumn(label: Text('BpCode')),
                      DataColumn(label: Text('Material No.')),
                      DataColumn(label: Text('Bill no.')),
                      DataColumn(label: Text('Bill Date')),
                      DataColumn(label: Text('HSN Code')),
                      DataColumn(label: Text('Gst Rate')),
                      DataColumn(label: Text('Price Rate')),
                      DataColumn(label: Text('Qty')),
                      DataColumn(label: Text('')),
                    ],
                    rows: rows,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    // Navigator.pop(context, false);
                    Navigator.of(context, rootNavigator: true).pop(false);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 5),
                    width: GlobalVariables.deviceWidth * 0.15,
                    height: GlobalVariables.deviceHeight * 0.05,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.grey,
                          blurRadius: 2,
                          offset: Offset(
                            2,
                            3,
                          ),
                        )
                      ],
                    ),
                    child: const Text("CLOSE",
                        style: TextStyle(fontSize: 11, color: Colors.black)),
                  ),
                ),
              ],
            )
          ],
        );
      },
    );
  }
}
