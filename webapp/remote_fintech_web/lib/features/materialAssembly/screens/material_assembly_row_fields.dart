import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:searchable_paginated_dropdown/searchable_paginated_dropdown.dart';

class MaterialAssemblyRowFields extends StatefulWidget {
  final int index;
  final List<List<String>> tableRows;
  final Function deleteRow;
  final Function addRow;
  final List<SearchableDropdownMenuItem<String>> units;
  final List<SearchableDropdownMenuItem<String>> rmType;
  final List<List<TextEditingController>> controllers;
  const MaterialAssemblyRowFields(
      {super.key,
      required this.index,
      required this.tableRows,
      required this.deleteRow,
      required this.units,
      required this.rmType,
      required this.controllers,
      required this.addRow});

  @override
  State<MaterialAssemblyRowFields> createState() =>
      _MaterialAssemblyRowFieldsState();
}

class _MaterialAssemblyRowFieldsState extends State<MaterialAssemblyRowFields> {
  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: widget.rmType.isNotEmpty && widget.units.isNotEmpty,
      child: Row(
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

          // MATERIAL
          SizedBox(
            width: GlobalVariables.deviceWidth * 0.16,
            height: 50,
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

          // PART NO
          SizedBox(
            width: 100,
            height: 50,
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

          SizedBox(
            width: 100,
            height: 50,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              child: TextFormField(
                controller: widget.controllers[widget.index][2],
                onChanged: (value) {
                  setState(() {
                    widget.tableRows[widget.index][2] = value;
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
          SizedBox(
            width: GlobalVariables.deviceWidth * 0.09,
            height: 50,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              child: TextFormField(
                controller: widget.controllers[widget.index][3],
                onChanged: (value) {
                  setState(() {
                    widget.tableRows[widget.index][3] = value;
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
                  items: widget.units,
                  onChanged: (value) {
                    setState(() {
                      widget.tableRows[widget.index][4] = value!;
                    });
                  },
                  hasTrailingClearIcon: false,
                )),
          ),

          SizedBox(
            width: GlobalVariables.deviceWidth * 0.09,
            height: 50,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              child: TextFormField(
                controller: widget.controllers[widget.index][5],
                onChanged: (value) {
                  setState(() {
                    widget.tableRows[widget.index][5] = value;
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

          SizedBox(
            width: GlobalVariables.deviceWidth * 0.16,
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
                  items: widget.rmType,
                  onChanged: (value) {
                    setState(() {
                      widget.tableRows[widget.index][6] = value!;
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
                      widget.deleteRow(widget.index);
                    },
                    icon: const Icon(Icons.delete_outline),
                    color: Colors.white),
              ))
        ],
      ),
    );
  }
}
