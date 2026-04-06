import 'dart:convert';

import 'package:fintech_new_web/features/network/service/network_service.dart';
import 'package:fintech_new_web/features/purchaseOrder/provider/purchase_order_provider.dart';
import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:searchable_paginated_dropdown/searchable_paginated_dropdown.dart';

class PurchaseOrderRowFields extends StatefulWidget {
  final int index;
  final List<List<String>> tableRows;
  final Function deleteRow;
  final Function addRow;
  final Function totalQty;
  final Function subTotalQty;
  final List<SearchableDropdownMenuItem<String>> priority;
  final List<SearchableDropdownMenuItem<String>> poType;
  final List<List<TextEditingController>> controllers;
  const PurchaseOrderRowFields(
      {super.key,
      required this.index,
      required this.tableRows,
      required this.deleteRow,
      required this.priority,
      required this.poType,
      required this.controllers,
      required this.addRow,
      required this.totalQty, required this.subTotalQty});

  @override
  State<PurchaseOrderRowFields> createState() => _PurchaseOrderRowFieldsState();
}

class _PurchaseOrderRowFieldsState extends State<PurchaseOrderRowFields> {
  TextEditingController dateController = TextEditingController();

  DateTime? _selectedDate;

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
        widget.tableRows[index][2] =
            DateFormat('MM-dd-yyyy').format(pickedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
            width: GlobalVariables.deviceWidth * 0.03,
            height: GlobalVariables.deviceWidth * 0.03,
            margin: const EdgeInsets.only(left: 5),
            color: Colors.transparent,
            child: Visibility(
              visible: widget.index == widget.tableRows.length - 1,
              child: IconButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: const RoundedRectangleBorder()),
                  onPressed: () {
                    widget.addRow();
                  },
                  icon: const Icon(Icons.add),
                  color: Colors.white),
            )),

        SizedBox(
          width: GlobalVariables.deviceWidth * 0.16,
          height: 50,
          child: Focus(
            onFocusChange: (hasFocus) async {
              if (!hasFocus) {
                NetworkService networkService = NetworkService();

                http.StreamedResponse response =
                    await networkService.post("/get-material-source-details/", {
                  "matno": widget.tableRows[widget.index][0],
                  "bpCode": GlobalVariables
                      .requestBody[PurchaseOrderProvider.featureName]['bpCode']
                });
                if (response.statusCode == 200) {
                  var data =
                      jsonDecode(await response.stream.bytesToString())[0];
                  setState(() {
                    widget.controllers[widget.index][2].text = data['bpRate'];
                    widget.controllers[widget.index][3].text = data['hsnCode'];
                  });
                }
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              child: TextFormField(
                inputFormatters: <TextInputFormatter>[
                  LengthLimitingTextInputFormatter(15)
                ],
                textAlignVertical: TextAlignVertical.center,
                controller: widget.controllers[widget.index][0],
                onChanged: (value) async {
                  setState(() {
                    widget.tableRows[widget.index][0] = value;
                  });
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 0),
                  ),
                ),
                validator: (String? val) {
                  if (val == null || val.isEmpty) {
                    return 'Material No. is Mandatory';
                  }
                },
              ),
            ),
          ),
        ),
        SizedBox(
          width: 100,
          height: 50,
          child: Focus(
            onFocusChange: (hasFocus) async {
              if (!hasFocus) {
                widget.totalQty(widget.tableRows[widget.index][1]);
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              child: TextFormField(
                validator: (String? val) {
                  if (val == null || val.isEmpty) {
                    return 'Quantity is Mandatory';
                  }
                },
                controller: widget.controllers[widget.index][1],
                onChanged: (value) {
                  setState(() {
                    widget.tableRows[widget.index][1] = value;
                  });
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 0),
                  ),
                ),
              ),
            ),
          ),
        ),

        // DISPLAY ONLY FIELD

        SizedBox(
          width: 100,
          height: 50,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            child: TextFormField(
              readOnly: true,
              controller: widget.controllers[widget.index][2],
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey)),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 0),
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          width: GlobalVariables.deviceWidth * 0.09,
          height: 50,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            child: TextFormField(
              readOnly: true,
              controller: widget.controllers[widget.index][3],
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey)),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 0),
                ),
              ),
            ),
          ),
        ),

        // END DISPLAY

        SizedBox(
          width: GlobalVariables.deviceWidth * 0.08,
          height: 50,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            child: TextFormField(
              controller: dateController,
              style: const TextStyle(color: Colors.black, fontSize: 12),
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey)),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 2),
                ),
              ),
              readOnly: true,
              onTap: () => _selectDate(context, widget.index),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Delivery date field is Mandatory';
                }
              },
            ),
          ),
        ),
        SizedBox(
          width: GlobalVariables.deviceWidth * 0.08,
          height: 50,
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              child: SearchableDropdown<String>(
                isEnabled: true,
                backgroundDecoration: (child) => Container(
                  height: 48,
                  margin: EdgeInsets.zero,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    border: Border.all(color: Colors.black, width: 0.5),
                  ),
                  child: child,
                ),
                items: widget.poType,
                onChanged: (value) {
                  setState(() {
                    widget.tableRows[widget.index][4] = value!;
                  });
                },
                hasTrailingClearIcon: false,
              )),
        ),
        SizedBox(
          width: GlobalVariables.deviceWidth * 0.08,
          height: 50,
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              child: SearchableDropdown<String>(
                isEnabled: true,
                backgroundDecoration: (child) => Container(
                  height: 48,
                  margin: EdgeInsets.zero,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    border: Border.all(color: Colors.black, width: 0.5),
                  ),
                  child: child,
                ),
                items: widget.priority,
                onChanged: (value) {
                  setState(() {
                    widget.tableRows[widget.index][3] = value!;
                  });
                },
                hasTrailingClearIcon: false,
              )),
        ),
        Container(
            width: GlobalVariables.deviceWidth * 0.03,
            height: GlobalVariables.deviceWidth * 0.03,
            margin: const EdgeInsets.only(right: 5),
            color: Colors.transparent,
            child: Visibility(
              visible: widget.tableRows.length != 1,
              child: IconButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: const RoundedRectangleBorder()),
                  onPressed: () {
                    widget.subTotalQty(widget.tableRows[widget.index][1] ?? 0);
                    widget.deleteRow(widget.index);
                  },
                  icon: const Icon(Icons.delete_outline),
                  color: Colors.white),
            ))
      ],
    );
  }
}
