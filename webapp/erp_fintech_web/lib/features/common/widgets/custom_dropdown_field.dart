import 'package:flutter/material.dart';
import 'package:searchable_paginated_dropdown/searchable_paginated_dropdown.dart';

import '../../utility/global_variables.dart';
import '../../utility/models/forms_UI.dart';

class CustomDropdownField extends StatefulWidget {
  final FormUI field;
  final List<SearchableDropdownMenuItem<String>> dropdownMenuItems;
  final String feature;
  final Function? customFunction;
  const CustomDropdownField(
      {super.key,
      required this.field,
      required this.dropdownMenuItems,
      required this.feature,
      this.customFunction});

  @override
  State<CustomDropdownField> createState() => _CustomDropdownFieldState();
}

class _CustomDropdownFieldState extends State<CustomDropdownField> {
  bool visible = false;
  late SearchableDropdownController<String> controller;

  @override
  void initState() {
    super.initState();
    GlobalVariables.requestBody[widget.feature][widget.field.id] =
        (widget.field.defaultValue == "null" || widget.field.defaultValue == '')
            ? null
            : widget.field.defaultValue;
    var defaultItem = SearchableDropdownMenuItem(
        value: "${widget.field.defaultValue ?? ''}",
        label: "${widget.field.defaultValue ?? ''}",
        child: Text("${widget.field.defaultValue ?? ''}"));
    var searchItem = widget.dropdownMenuItems.firstWhere(
        (item) => item.value == widget.field.defaultValue.toString(),
        orElse: () => defaultItem);
    controller = SearchableDropdownController<String>(initialItem: searchItem);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
            height: 41,
            key: const Key('outletMappingDropdownKey'),
            color: Colors.white,
            margin: const EdgeInsets.symmetric(vertical: 2),
            child: SearchableDropdown<String>(
              trailingIcon: const SizedBox(),
              isEnabled: !widget.field.readOnly,
              controller:
                  (widget.field.controller is SearchableDropdownController)
                      ? widget.field.controller
                      : controller,
              backgroundDecoration: (child) => Container(
                height: 48,
                margin: EdgeInsets.zero,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.black45, width: 0.8),
                ),
                child: child,
              ),
              items: widget.dropdownMenuItems,
              onChanged: (String? value) {
                if (value == "true") {
                  GlobalVariables.requestBody[widget.feature][widget.field.id] =
                      1;
                } else if (value == 'false') {
                  GlobalVariables.requestBody[widget.feature][widget.field.id] =
                      0;
                } else {
                  GlobalVariables.requestBody[widget.feature][widget.field.id] =
                      value;
                }

                setState(() {
                  visible = true;
                });

                if (widget.customFunction != null) {
                  widget.customFunction!();
                }
              },
              hasTrailingClearIcon: false,
            )),
        // widget.isRow ? Positioned(
        //   left: 10,
        //   top: -2,
        //   child: Container(
        //     color: Colors.white,
        //     padding: const EdgeInsets.symmetric(horizontal: 2),
        //     child: Wrap(
        //       children: [
        //         Text(
        //           widget.field.name,
        //           style: const TextStyle(
        //             fontSize: 11,
        //             color: Colors.black,
        //             fontWeight: FontWeight.w500,
        //           ),
        //         ),
        //         widget.field.isMandatory == true
        //             ? const Text(
        //                 "*",
        //                 style: TextStyle(color: Colors.red),
        //               )
        //             : const Text(""),
        //       ],
        //     ),
        //   ),
        // ) : const SizedBox(),
        Visibility(
          visible: visible,
          child: Positioned(
              left: GlobalVariables.deviceWidth / 2.19,
              top: 15,
              child: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  // Clear the text field and trigger onChanged
                  setState(() {
                    controller.selectedItem.value = null;
                    GlobalVariables.requestBody[widget.feature]
                        [widget.field.id] = null;
                    visible = false;
                  });
                },
              )),
        )
      ],
    );
  }
}
