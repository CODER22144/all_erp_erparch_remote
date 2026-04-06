import 'dart:convert';

import 'package:fintech_new_web/features/inward/provider/inward_provider.dart';
import 'package:fintech_new_web/features/utility/services/common_utility.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:searchable_paginated_dropdown/searchable_paginated_dropdown.dart';

import '../../common/widgets/pop_ups.dart';
import '../../network/service/network_service.dart';
import '../../utility/global_variables.dart';

class InwardRowFields extends StatefulWidget {
  final int index;
  final List<List<String>> tableRows;
  final Function deleteRow;
  final List<SearchableDropdownMenuItem<String>> units;
  final List<SearchableDropdownMenuItem<String>> hsnCodes;
  final List<List<TextEditingController>> controllers;
  const InwardRowFields(
      {super.key,
      required this.index,
      required this.tableRows,
      required this.deleteRow,
      required this.controllers, required this.units, required this.hsnCodes});

  @override
  State<InwardRowFields> createState() => _InwardRowFieldsState();
}

class _InwardRowFieldsState extends State<InwardRowFields> {
  bool checkRatePercentage = false;
  bool checkDiscAmount = false;

  double amount = 0;
  double cessAmount = 0;
  double gstAmount = 0;
  double totalAmount = 0;

  SearchableDropdownController<String> hsnController = SearchableDropdownController<String>();
  SearchableDropdownController<String> unitController = SearchableDropdownController<String>();

  @override
  void initState() {
    super.initState();
    widget.controllers[widget.index][11].text = "0.00";
    widget.controllers[widget.index][12].text = "0.00";
    widget.controllers[widget.index][13].text = "0.00";


    widget.controllers[widget.index][6].text = "0.00";
    widget.controllers[widget.index][7].text = "0.00";
    widget.tableRows[widget.index][10] = "0.00";

    unitController.selectedItem.value = findDropdownMenuItem(widget.units, "PCS");
    widget.tableRows[widget.index][6] = "PCS";

    widget.controllers[widget.index][3].text =
        widget.tableRows[widget.index][1];
    widget.controllers[widget.index][0].text =
        widget.tableRows[widget.index][2];
    widget.controllers[widget.index][1].text =
        widget.tableRows[widget.index][4];
    widget.controllers[widget.index][8].text = widget.tableRows[widget.index][13];
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
          child: Focus(
            onFocusChange: (hasFocus) async {
              if (!hasFocus && widget.controllers[widget.index][3].text == "") {
                widget.controllers[widget.index][0].text = "";
                setState(() {
                  widget.tableRows[widget.index][4] = "0";
                  widget.tableRows[widget.index][2] =
                      widget.controllers[widget.index][0].text;
                  widget.tableRows[widget.index][13] = "0";
                  widget.controllers[widget.index][8].text = "0";
                });
              }
              if (!hasFocus &&
                  widget.controllers[widget.index][3].text != null &&
                  widget.controllers[widget.index][3].text != "") {
                setState(() {
                  widget.tableRows[widget.index][1] =
                      widget.controllers[widget.index][3].text;
                });

                NetworkService networkService = NetworkService();
                http.StreamedResponse response = await networkService.get(
                    "/get-material/${widget.controllers[widget.index][3].text}/");
                var matDetails =
                jsonDecode(await response.stream.bytesToString())[0];
                if (response.statusCode == 200) {
                  setState(() {
                    widget.controllers[widget.index][2].text = matDetails['saleDescription'];
                    widget.tableRows[widget.index][0] = matDetails['saleDescription'];

                    unitController.selectedItem.value = findDropdownMenuItem(widget.units, matDetails['unit']);
                    widget.tableRows[widget.index][6] = matDetails['unit'];

                    widget.controllers[widget.index][0].text =
                        matDetails['hsnCode'] ?? "";
                    hsnController.selectedItem.value = findDropdownMenuItem(widget.hsnCodes, matDetails['hsnCode']);
                    widget.tableRows[widget.index][4] =
                        matDetails['prate'] ?? "0";
                    widget.controllers[widget.index][1].text =
                        matDetails['prate'] ?? "0";

                    widget.tableRows[widget.index][2] =
                        widget.controllers[widget.index][0].text;

                    widget.tableRows[widget.index][13] =
                        matDetails['gstTaxRate'] ?? "0";
                    widget.controllers[widget.index][8].text = matDetails['gstTaxRate'] ?? "0";
                  });
                } else {
                  setState(() {
                    widget.controllers[widget.index][0].text = "";
                    widget.tableRows[widget.index][4] = "0";
                    widget.tableRows[widget.index][2] =
                        widget.controllers[widget.index][0].text;
                    widget.tableRows[widget.index][13] = "0";
                    widget.controllers[widget.index][8].text = "0";
                  });
                  showAlertDialog(
                      context, "Invalid Material no.", "Continue", false);
                }
              }
              calculateTotalAmount(widget.index);
            },
            child: TextFormField(
              validator: (String? val) {
                if (val == null || val.isEmpty) {
                  return 'This field is Mandatory';
                }
              },
              controller: widget.controllers[widget.index][3],
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
            controller: widget.controllers[widget.index][2],
            onChanged: (value) {
              setState(() {
                widget.tableRows[widget.index][0] = value;
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
            validator: (String? val) {
              if (val == null || val.isEmpty) {
                return 'This field is Mandatory';
              }
            },
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
                  items: widget.hsnCodes,
                  onChanged: (value) async {
                    setState(() {
                      widget.tableRows[widget.index][2] = value!;
                    });
                    NetworkService networkService = NetworkService();
                      http.StreamedResponse response = await networkService
                          .get("/get-hsn-code/$value/");
                      if(response.statusCode == 200) {
                        widget.controllers[widget.index][8].text = jsonDecode(await response.stream.bytesToString())[0]['gstTaxRate'].toString();
                    } else {
                        widget.controllers[widget.index][8].text = "0.00";
                    }
                    widget.tableRows[widget.index][13] = widget.controllers[widget.index][8].text;

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
                      "HSN Code",
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
            controller: widget.controllers[widget.index][4],
            onChanged: (value) {
              setState(() {
                widget.tableRows[widget.index][3] = value;
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
                  items: widget.units,
                  onChanged: (value) {
                    setState(() {
                      widget.tableRows[widget.index][6] = value!;
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
                      "Unit",
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
            controller: widget.controllers[widget.index][1],
            onChanged: (value) {
              setState(() {
                widget.tableRows[widget.index][4] = value;
                // rateController.selection = TextSelection.fromPosition(
                //     TextPosition(offset: rateController.text.length));
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
            controller: widget.controllers[widget.index][5],
            validator: (String? val) {
              if (val == null || val.isEmpty) {
                return 'This field is Mandatory';
              }
            },
            onChanged: (value) {
              setState(() {
                widget.tableRows[widget.index][5] = value;
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
                widget.tableRows[widget.index][8] = value;
              });
              calculateTotalAmount(widget.index);
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
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            validator: (String? val) {
              if (val == null || val.isEmpty) {
                return 'This field is Mandatory';
              }
            },
            controller: widget.controllers[widget.index][7],
            onChanged: (value) {
              setState(() {
                widget.tableRows[widget.index][10] = value;
              });

              calculateTotalAmount(widget.index);
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
            controller: widget.controllers[widget.index][11],
            onChanged: (value) {
              setState(() {
                widget.tableRows[widget.index][17] = value;
              });
              calculateTotalAmount(widget.index);
            },
            decoration: InputDecoration(
              label: RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: "",
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
            readOnly: true,
            controller: widget.controllers[widget.index][12],
            onChanged: (value) {
              setState(() {
                widget.tableRows[widget.index][18] = value;
              });
              calculateTotalAmount(widget.index);
            },
            decoration: InputDecoration(
              label: RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: "",
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
            controller: widget.controllers[widget.index][13],
            onChanged: (value) {
              setState(() {
                widget.tableRows[widget.index][19] = value;
              });
              calculateTotalAmount(widget.index);
            },
            decoration: InputDecoration(
              label: RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: "",
                      style: TextStyle(color: Colors.red),
                    )
                  ],
                  text: "BCD",
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
            controller: widget.controllers[widget.index][8],
            onChanged: (value) {
              setState(() {
                widget.tableRows[widget.index][13] = value;
              });
              calculateTotalAmount(widget.index);
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
            controller:widget.controllers[widget.index][9],
            onChanged: (value) {
              setState(() {
                widget.tableRows[widget.index][14] = value;
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

        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            validator: (String? val) {
              if (val == null || val.isEmpty) {
                return 'This field is Mandatory';
              }
            },
            controller:widget.controllers[widget.index][10],
            readOnly: true,
            onChanged: (value) {
              setState(() {
                widget.tableRows[widget.index][16] = value;
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
      amount = parseEmptyStringToDouble(widget.tableRows[widget.index][3]) *
          parseEmptyStringToDouble(widget.tableRows[widget.index][4]);
      widget.tableRows[widget.index][5] = amount.toStringAsFixed(2);
      widget.controllers[widget.index][5].text = amount.toStringAsFixed(2);

      cessAmount = (amount -
          parseEmptyStringToDouble(widget.tableRows[widget.index][8])) *
          parseEmptyStringToDouble(widget.tableRows[widget.index][17]) *
          0.01;

      widget.tableRows[widget.index][18] = cessAmount.toStringAsFixed(2);
      widget.controllers[widget.index][12].text = cessAmount.toStringAsFixed(2);


      gstAmount = (amount -
              parseEmptyStringToDouble(widget.tableRows[widget.index][8])) *
          parseEmptyStringToDouble(widget.tableRows[widget.index][13]) *
          0.01;
      widget.tableRows[widget.index][14] = gstAmount.toStringAsFixed(2);
      widget.controllers[widget.index][9].text = gstAmount.toStringAsFixed(2);

      totalAmount = (amount -
          parseEmptyStringToDouble(widget.tableRows[widget.index][8])) +
          gstAmount +
          cessAmount +
          parseEmptyStringToDouble(widget.tableRows[widget.index][19]) +
          parseEmptyStringToDouble(widget.tableRows[widget.index][10]);

      widget.tableRows[widget.index][16] = totalAmount.toStringAsFixed(2);
      widget.controllers[widget.index][10].text = totalAmount.toStringAsFixed(2);
    });
  }
}
