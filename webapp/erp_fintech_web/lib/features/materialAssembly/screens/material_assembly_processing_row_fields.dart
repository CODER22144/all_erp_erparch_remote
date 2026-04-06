import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:searchable_paginated_dropdown/searchable_paginated_dropdown.dart';

class MaterialAssemblyProcessingRowFields extends StatefulWidget {
  final int index;
  final List<List<String>> tableRows;
  final Function deleteRow;
  final Function addRow;
  final List<SearchableDropdownMenuItem<String>> workProcess;
  final List<SearchableDropdownMenuItem<String>> resource;
  final List<List<TextEditingController>> controllers;
  const MaterialAssemblyProcessingRowFields(
      {super.key,
        required this.index,
        required this.tableRows,
        required this.deleteRow,
        required this.workProcess,
        required this.resource,
        required this.controllers,
        required this.addRow});

  @override
  State<MaterialAssemblyProcessingRowFields> createState() =>
      _MaterialAssemblyProcessingRowFieldsState();
}

class _MaterialAssemblyProcessingRowFieldsState extends State<MaterialAssemblyProcessingRowFields> {
  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: widget.resource.isNotEmpty && widget.workProcess.isNotEmpty,
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
                    return 'Required Field';
                  }
                },
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
                  items: widget.workProcess,
                  onChanged: (value) {
                    setState(() {
                      widget.tableRows[widget.index][1] = value!;
                    });
                  },
                  hasTrailingClearIcon: false,
                )),
          ),

          SizedBox(
            width: GlobalVariables.deviceWidth * 0.10,
            height: 50,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              child: TextFormField(
                inputFormatters: <TextInputFormatter>[
                  LengthLimitingTextInputFormatter(15)
                ],
                textAlignVertical: TextAlignVertical.center,
                controller: widget.controllers[widget.index][2],
                onChanged: (value) async {
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
                validator: (String? val) {
                  if (val == null || val.isEmpty) {
                    return 'Required Field';
                  }
                },
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
                  items: widget.resource,
                  onChanged: (value) {
                    setState(() {
                      widget.tableRows[widget.index][3] = value!;
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
              child: TextFormField(
                inputFormatters: <TextInputFormatter>[
                  LengthLimitingTextInputFormatter(15)
                ],
                textAlignVertical: TextAlignVertical.center,
                controller: widget.controllers[widget.index][4],
                onChanged: (value) async {
                  setState(() {
                    widget.tableRows[widget.index][4] = value;
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
                    return 'Required Field';
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
              child: TextFormField(
                inputFormatters: <TextInputFormatter>[
                  LengthLimitingTextInputFormatter(15)
                ],
                textAlignVertical: TextAlignVertical.center,
                controller: widget.controllers[widget.index][5],
                onChanged: (value) async {
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
                validator: (String? val) {
                  if (val == null || val.isEmpty) {
                    return 'Required Field';
                  }
                },
              ),
            ),
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
