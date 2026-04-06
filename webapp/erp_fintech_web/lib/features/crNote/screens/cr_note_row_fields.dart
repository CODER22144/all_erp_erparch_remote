import 'dart:convert';

import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:searchable_paginated_dropdown/searchable_paginated_dropdown.dart';
import 'package:intl/intl.dart';

import '../../common/widgets/pop_ups.dart';
import '../../network/service/network_service.dart';
import '../../utility/services/common_utility.dart';
import '../provider/cr_note_provider.dart';

class CrnoteRowFields extends StatefulWidget {
  final int index;
  final List<List<String>> tableRows;
  final List<SearchableDropdownMenuItem<String>> discountType;
  final List<SearchableDropdownMenuItem<String>> materialUnit;
  final Function deleteRow;
  final List<List<TextEditingController>> controllers;
  const CrnoteRowFields(
      {super.key,
      required this.index,
      required this.tableRows,
      required this.discountType,
      required this.deleteRow,
      required this.materialUnit, required this.controllers});

  @override
  State<CrnoteRowFields> createState() => _CrnoteRowFieldsState();
}

class _CrnoteRowFieldsState extends State<CrnoteRowFields> {
  bool checkRatePercentage = true;
  bool checkDiscAmount = true;

  double amount = 0;
  double discAmount = 0;
  double cessAmount = 0;
  double gstAmount = 0;
  double totalAmount = 0;

  SearchableDropdownController<String> unitController = SearchableDropdownController();

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
          child: Focus(
            onFocusChange: (hasFocus) async {
              if (!hasFocus && widget.controllers[widget.index][9].text == "") {
                widget.controllers[widget.index][10].text = "";
                setState(() {
                  widget.tableRows[widget.index][6] = "0";
                  widget.controllers[widget.index][8].text = "0";
                  widget.tableRows[widget.index][2] = widget.controllers[widget.index][10].text;
                  widget.tableRows[widget.index][15] = "0";
                  widget.tableRows[widget.index][19] = "";
                  unitController.selectedItem.value = const SearchableDropdownMenuItem(
                      value: "", label: "", child: Text(""));

                  widget.controllers[widget.index][6].text = "";
                  widget.tableRows[widget.index][3] = "";

                  widget.controllers[widget.index][5].text = "";
                  widget.tableRows[widget.index][0] = "";

                  widget.tableRows[widget.index][4] = "";
                  widget.controllers[widget.index][7].text = "";
                });
              }
              if (!hasFocus &&
                  widget.controllers[widget.index][9].text != null &&
                  widget.controllers[widget.index][9].text != "") {
                setState(() {
                  widget.tableRows[widget.index][1] = widget.controllers[widget.index][9].text;
                });

                NetworkService networkService = NetworkService();
                http.StreamedResponse response =
                    await networkService.post("/get-cr-mat-details/", {
                  "matno": widget.controllers[widget.index][9].text,
                  "bpCode": GlobalVariables
                      .requestBody[CrnoteProvider.featureName]['lcode']
                });
                var matDetails =
                    jsonDecode(await response.stream.bytesToString())[0];
                if (response.statusCode == 200) {
                  widget.controllers[widget.index][10].text = matDetails['hsnCode'] ?? "";
                  setState(() {
                    widget.tableRows[widget.index][6] =
                        matDetails['rate'] ?? "0";
                    widget.controllers[widget.index][8].text = matDetails['rate'] ?? "0";
                    widget.tableRows[widget.index][2] = widget.controllers[widget.index][10].text;
                    widget.tableRows[widget.index][15] =
                        matDetails['gstTaxRate'] ?? "0";

                    widget.tableRows[widget.index][19] = matDetails['puUnit'];
                    unitController.selectedItem.value = findDropdownMenuItem(widget.materialUnit, matDetails['puUnit']);
                    widget.controllers[widget.index][6].text = matDetails['billNo'] ?? "";
                    widget.tableRows[widget.index][3] = matDetails['billNo'] ?? "";

                    widget.tableRows[widget.index][4] = matDetails['billDate'] ?? "";
                    if(matDetails['billDate'] != null) {
                      widget.controllers[widget.index][7].text = DateFormat("MM-dd-yyyy").format(
                          DateFormat("dd-MM-yyyy").parse(matDetails['billDate']));
                    }

                    widget.controllers[widget.index][5].text = matDetails['saleDescription'] ?? "";
                    widget.tableRows[widget.index][0] = matDetails['saleDescription'] ?? "";
                  });
                } else {
                  widget.controllers[widget.index][10].text = "";
                  setState(() {
                    widget.tableRows[widget.index][6] = "0";
                    widget.tableRows[widget.index][2] = widget.controllers[widget.index][10].text;
                    widget.tableRows[widget.index][15] = "0";

                    widget.controllers[widget.index][5].text = "";
                    widget.tableRows[widget.index][0] = "";

                    widget.tableRows[widget.index][19] = "";
                    unitController.selectedItem.value = const SearchableDropdownMenuItem(
                        value: "", label: "", child: Text(""));

                    widget.controllers[widget.index][6].text = "";
                    widget.tableRows[widget.index][3] = "";

                    widget.tableRows[widget.index][4] = "";
                    widget.controllers[widget.index][7].text = "";
                  });
                  showAlertDialog(
                      context, "Invalid Material no.", "Continue", false);
                }
              }
              calculateTotalAmount(widget.index);
            },
            child: TextFormField(
              controller: widget.controllers[widget.index][9],
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
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            controller: widget.controllers[widget.index][5],
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
          child: Focus(
            onFocusChange: (hasFocus) async {
              if (!hasFocus) {
                setState(() {
                  widget.tableRows[widget.index][2] = widget.controllers[widget.index][10].text;
                });
                NetworkService networkService = NetworkService();
                dynamic hsnDetails;
                if (widget.controllers[widget.index][10].text != null && widget.controllers[widget.index][10].text != "") {
                  http.StreamedResponse response = await networkService
                      .get("/get-hsn/${widget.controllers[widget.index][10].text}/");
                  if (response.statusCode == 200) {
                    hsnDetails =
                        jsonDecode(await response.stream.bytesToString())[0]
                                ['gstTaxRate'] ??
                            "0";
                    setState(() {
                      widget.tableRows[widget.index][15] = hsnDetails;
                    });
                  } else {
                    setState(() {
                      widget.tableRows[widget.index][15] = "0";
                    });
                    showAlertDialog(context, "Invalid Hsn Code", "Okay", false);
                  }
                  calculateTotalAmount(widget.index);
                }
              }
            },
            child: TextFormField(
              validator: (String? val) {
                if (val == null || val.isEmpty) {
                  return 'This field is Mandatory';
                }
              },
              controller: widget.controllers[widget.index][10],
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
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            controller: widget.controllers[widget.index][6],
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
            controller: widget.controllers[widget.index][7],
            onChanged: (value) {
              setState(() {
                widget.tableRows[widget.index][4] = DateFormat("MM-dd-yyyy").format(
                    DateFormat("dd-MM-yyyy").parse(value));
              });
            },
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
            controller: widget.controllers[widget.index][0],
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
            controller: widget.controllers[widget.index][8],
            onChanged: (value) {
              setState(() {
                widget.tableRows[widget.index][6] = value;
                widget.controllers[widget.index][8].text = value;
              });
              widget.controllers[widget.index][8].selection = TextSelection.fromPosition(
                  TextPosition(offset: widget.controllers[widget.index][8].text.length));
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
            controller:
                TextEditingController(text: widget.tableRows[widget.index][7]),
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
                        widget.tableRows[widget.index][10] = "0"; // disc Amount
                        widget.controllers[widget.index][12].text = "0";
                        widget.controllers[widget.index][11].text = "0";
                        discAmount = 0;
                        checkRatePercentage = true;
                        checkDiscAmount = true;
                      }
                      if (value == "F") {
                        widget.tableRows[widget.index][9] = "0"; // disc Rate
                        widget.tableRows[widget.index][10] = "0"; // disc Amount
                        widget.controllers[widget.index][12].text = "0";
                        widget.controllers[widget.index][11].text = "0";
                        discAmount = 0;
                        checkRatePercentage = true;
                        checkDiscAmount = false;
                      }
                      if (value == "P") {
                        widget.controllers[widget.index][12].text = "0";
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
            controller: widget.controllers[widget.index][11],
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
                  widget.controllers[widget.index][12].text = discAmount.toStringAsFixed(2);

                  setState(() {
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
                  });

                  setState(() {
                    cessAmount = ((parseEmptyStringToDouble(
                                    widget.tableRows[widget.index][5]) *
                                parseEmptyStringToDouble(
                                    widget.tableRows[widget.index][6])) -
                            parseEmptyStringToDouble(
                                widget.controllers[widget.index][12].text)) *
                        parseEmptyStringToDouble(
                            widget.tableRows[widget.index][13]) *
                        0.01;
                    widget.tableRows[widget.index][14] =
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
                  });
                }
                widget.controllers[widget.index][11].selection = TextSelection.fromPosition(
                    TextPosition(offset: widget.controllers[widget.index][11].text.length));
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
            controller: widget.controllers[widget.index][12],
            readOnly: checkDiscAmount,
            onChanged: (value) {
              setState(() {
                if (widget.tableRows[widget.index][8] == "F") {
                  widget.tableRows[widget.index][10] = value;
                  widget.tableRows[widget.index][9] = "0";
                  discAmount = parseEmptyStringToDouble(value);
                  widget.controllers[widget.index][12].text = value;

                  setState(() {
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
                  });

                  setState(() {
                    cessAmount = ((parseEmptyStringToDouble(
                                    widget.tableRows[widget.index][5]) *
                                parseEmptyStringToDouble(
                                    widget.tableRows[widget.index][6])) -
                            parseEmptyStringToDouble(
                                widget.controllers[widget.index][12].text)) *
                        parseEmptyStringToDouble(
                            widget.tableRows[widget.index][13]) *
                        0.01;
                    widget.tableRows[widget.index][14] =
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
                  });
                }
                widget.controllers[widget.index][12].selection = TextSelection.fromPosition(
                    TextPosition(offset: widget.controllers[widget.index][12].text.length));
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
              controller: widget.controllers[widget.index][1],
              onChanged: (value) {
                setState(() {
                  widget.tableRows[widget.index][11] = value;

                  setState(() {
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
                  });

                  setState(() {
                    cessAmount = ((parseEmptyStringToDouble(
                                    widget.tableRows[widget.index][5]) *
                                parseEmptyStringToDouble(
                                    widget.tableRows[widget.index][6])) -
                            parseEmptyStringToDouble(
                                widget.controllers[widget.index][12].text)) *
                        parseEmptyStringToDouble(
                            widget.tableRows[widget.index][13]) *
                        0.01;
                    widget.tableRows[widget.index][14] =
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
                  });
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
            controller: widget.controllers[widget.index][2],
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
            controller: widget.controllers[widget.index][3],
            onChanged: (value) {
              setState(() {
                widget.tableRows[widget.index][13] = value;

                setState(() {
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
                });

                setState(() {
                  cessAmount = ((parseEmptyStringToDouble(
                                  widget.tableRows[widget.index][5]) *
                              parseEmptyStringToDouble(
                                  widget.tableRows[widget.index][6])) -
                          parseEmptyStringToDouble(widget.controllers[widget.index][12].text)) *
                      parseEmptyStringToDouble(value) *
                      0.01;
                  widget.tableRows[widget.index][14] =
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
                });
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
            controller:
                TextEditingController(text: widget.tableRows[widget.index][14]),
            onChanged: (value) {
              setState(() {
                widget.tableRows[widget.index][14] = value;
              });
            },
            readOnly: true,
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
            controller:
                TextEditingController(text: widget.tableRows[widget.index][15]),
            onChanged: (value) {
              setState(() {
                widget.tableRows[widget.index][15] = value;
              });
            },
            readOnly: true,
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
            controller:
                TextEditingController(text: widget.tableRows[widget.index][16]),
            readOnly: true,
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
              controller: widget.controllers[widget.index][4],
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
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            validator: (String? val) {
              if (val == null || val.isEmpty) {
                return 'This field is Mandatory';
              }
            },
            controller:
                TextEditingController(text: widget.tableRows[widget.index][18]),
            readOnly: true,
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

      if (widget.tableRows[widget.index][8] == "P") {
        discAmount = (amount *
            parseEmptyStringToDouble(widget.tableRows[widget.index][9]) *
            0.01);
        widget.controllers[widget.index][12].text = discAmount.toStringAsFixed(2);
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
    });

    // CESS AMOUNT AND TOTAL AMOUNT
    setState(() {
      cessAmount = ((parseEmptyStringToDouble(
                      widget.tableRows[widget.index][5]) *
                  parseEmptyStringToDouble(widget.tableRows[widget.index][6])) -
              parseEmptyStringToDouble(widget.controllers[widget.index][12].text)) *
          parseEmptyStringToDouble(widget.tableRows[widget.index][13]) *
          0.01;
      widget.tableRows[widget.index][14] = cessAmount.toStringAsFixed(2);
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
    });
  }
}
