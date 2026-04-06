import 'package:fintech_new_web/features/sqlQuery/provider/query_provider.dart';
import 'package:flutter/material.dart';
import 'package:searchable_paginated_dropdown/searchable_paginated_dropdown.dart';
import 'package:provider/provider.dart';

class QueryConditions extends StatefulWidget {
  final int index;
  final List<List<String>> tableRows;
  final Function deleteRow;
  final List<SearchableDropdownMenuItem<String>> operators;
  final List<SearchableDropdownMenuItem<String>> types;
  final List<List<TextEditingController>> controllers;
  const QueryConditions(
      {super.key,
      required this.index,
      required this.tableRows,
      required this.deleteRow,
      required this.controllers,
      required this.operators, required this.types});

  @override
  State<QueryConditions> createState() => _QueryConditionsState();
}

class _QueryConditionsState extends State<QueryConditions> {

  @override
  Widget build(BuildContext context) {
    return Consumer<QueryProvider>(builder: (context, provider, child) {
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
          Visibility(
            visible: provider.columnNames.isNotEmpty,
            child: Stack(
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
                      onChanged: (value) {
                        widget.tableRows[widget.index][0] = value!;
                      },
                      // controller: hsnController,
                      items: provider.columnNames,
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
                          "Column",
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
                    onChanged: (value) {
                      widget.tableRows[widget.index][1] = value!;
                    },
                    // controller: hsnController,
                    items: widget.operators,
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
                        "Operator",
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
                    onChanged: (value) {
                      widget.tableRows[widget.index][2] = value!;
                    },
                    // controller: hsnController,
                    items: widget.types,
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
                        "Data Type",
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
              // controller:widget.controllers[widget.index][10],
              onChanged: (value) {
                setState(() {
                  widget.tableRows[widget.index][3] = value;
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
                    text: "Logic",
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
              // controller:widget.controllers[widget.index][10],
              onChanged: (value) {
                setState(() {
                  widget.tableRows[widget.index][4] = value;
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
                    text: "Value",
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
    });
  }
}
