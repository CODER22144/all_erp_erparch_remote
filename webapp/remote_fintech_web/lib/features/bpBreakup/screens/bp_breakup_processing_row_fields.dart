import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:searchable_paginated_dropdown/searchable_paginated_dropdown.dart';
import 'package:provider/provider.dart';

import '../provider/bp_breakup_provider.dart';

class BpBreakupProcessingRowFields extends StatefulWidget {
  final int index;
  final List<List<String>> tableRows;
  final Function deleteRow;
  final Function addRow;
  final List<List<TextEditingController>> controllers;
  final List<SearchableDropdownMenuItem<String>> bpCodes;
  const BpBreakupProcessingRowFields(
      {super.key,
      required this.index,
      required this.tableRows,
      required this.deleteRow,
      required this.controllers,
      required this.addRow, required this.bpCodes});

  @override
  State<BpBreakupProcessingRowFields> createState() =>
      _BpBreakupProcessingRowFieldsState();
}

class _BpBreakupProcessingRowFieldsState
    extends State<BpBreakupProcessingRowFields> {

  bool isLoading = false;
  List<SearchableDropdownMenuItem<String>> materials = [];
  List<SearchableDropdownMenuItem<String>> bpPId = [];
  void getMaterialsByBpCode(String? bpCode) async {

    BpBreakupProvider provider = Provider.of<BpBreakupProvider>(context, listen: false);


    setState(() {
      isLoading = true;
    });
    widget.tableRows[widget.index][0] = bpCode!;

    var matDrop = await provider.getMaterials(bpCode);
    var bpDrop = await provider.getBpProcessing(bpCode);

    setState(() {
      materials = matDrop;
      bpPId = bpDrop;
      isLoading= false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: widget.bpCodes.isNotEmpty,
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
                  items: widget.bpCodes,
                  onChanged: getMaterialsByBpCode,
                  hasTrailingClearIcon: false,
                )),
          ),

          if(isLoading)
            const CircularProgressIndicator()
          else
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
                    items: materials,
                    onChanged: (value) {
                      setState(() {
                        widget.tableRows[widget.index][1] = value!;
                      });
                    },
                    hasTrailingClearIcon: false,
                  )),
            ),

          if(isLoading)
            const CircularProgressIndicator()
          else
            SizedBox(
              width: GlobalVariables.deviceWidth * 0.14,
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
                    items: bpPId,
                    onChanged: (value) {
                      setState(() {
                        widget.tableRows[widget.index][2] = value!;
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
                textAlignVertical: TextAlignVertical.center,
                controller: widget.controllers[widget.index][3],
                onChanged: (value) async {
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
