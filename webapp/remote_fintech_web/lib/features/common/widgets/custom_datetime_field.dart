import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../material/provider/material_provider.dart';
import '../../purchaseOrder/provider/purchase_order_provider.dart';
import '../../utility/models/forms_UI.dart';

class CustomDatetimeField extends StatefulWidget {
  final FormUI field;
  final String feature;
  final bool disableDefault;
  const CustomDatetimeField(
      {super.key,
      required this.feature,
      required this.field,
      this.disableDefault = false});

  @override
  State<CustomDatetimeField> createState() => _CustomDatetimeFieldState();
}

class _CustomDatetimeFieldState extends State<CustomDatetimeField> {
  TextEditingController dateController = TextEditingController();
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    if (widget.feature != PurchaseOrderProvider.reportFeature &&
        !widget.disableDefault &&
        widget.field.isMandatory) {
      GlobalVariables.requestBody[widget.feature][widget.field.id] =
          DateFormat('MM-dd-yyyy').format(DateTime.now());
      _selectedDate = DateTime.now();
    }

    if (widget.field.defaultValue != null && widget.field.defaultValue != "") {
      _selectedDate = DateFormat('dd-MM-yyy')
          .parse(convertDateForFrontend(widget.field.defaultValue));
      dateController.text = convertDateForFrontend(widget.field.defaultValue);
      GlobalVariables.requestBody[widget.feature][widget.field.id] =
          convertDateForBackend(widget.field.defaultValue);
    }
  }

  Future<void> _selectDate(BuildContext context) async {
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
        GlobalVariables.requestBody[widget.feature][widget.field.id] =
            DateFormat('MM-dd-yyyy').format(pickedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 47,
      width: 150,
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: TextFormField(
        controller: dateController,
        style: (widget.field.readOnly)
            ? const TextStyle(color: Colors.grey, fontSize: 13)
            : const TextStyle(color: Colors.black, fontSize: 13),
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          suffixIcon: dateController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    // Clear the text field and trigger onChanged
                    setState(() {
                      dateController.text = "";
                      GlobalVariables.requestBody[widget.feature]
                          [widget.field.id] = null;
                    });
                  },
                )
              : null, // No icon when the field is empty
          hintText: widget.feature != PurchaseOrderProvider.reportFeature &&
                  !widget.disableDefault &&
                  widget.field.isMandatory
              ? widget.field.defaultValue != null &&
                      widget.field.defaultValue != ""
                  ? "${widget.field.defaultValue}"
                  : DateFormat('dd-MM-yyyy').format(DateTime.now())
              : '',
          floatingLabelBehavior: FloatingLabelBehavior.always,
          enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black45, width: 0.8),
              borderRadius: BorderRadius.all(Radius.circular(4))),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black, width: 1),
          ),
          // label: RichText(
          //   text: TextSpan(
          //     text: widget.field.name,
          //     style: const TextStyle(
          //       fontSize: 14,
          //       color: Colors.black,
          //       fontWeight: FontWeight.w300,
          //     ),
          //     children: [
          //       TextSpan(
          //           text: widget.field.isMandatory ? "*" : "",
          //           style: const TextStyle(color: Colors.red))
          //     ],
          //   ),
          // ),
        ),
        readOnly: true,
        onTap: () => _selectDate(context),
        validator: (String? value) {
          if ((GlobalVariables.requestBody[widget.feature][widget.field.id] ==
                      null ||
                  GlobalVariables
                      .requestBody[widget.feature][widget.field.id].isEmpty) &&
              widget.field.isMandatory) {
            return '${widget.field.name} field is Mandatory';
          }
          if (widget.feature == MaterialProvider.featureName) {
            String mst = GlobalVariables
                    .requestBody[MaterialProvider.featureName]['mst'] ??
                "";
            String closingDate = GlobalVariables
                    .requestBody[MaterialProvider.featureName]['doclosing'] ??
                "";
            if (mst == 'A' && closingDate.isNotEmpty) {
              return "Active Material cannot have closing date";
            }
            if (mst != 'A' && closingDate.isEmpty) {
              return "Closing Date is required";
            }
          }
        },
      ),
    );
  }

  String convertDateForFrontend(String inputDate) {
    final formats = [
      DateFormat("dd-MM-yyyy"),
      DateFormat("MM-dd-yyyy"),
      DateFormat("yyyy-MM-dd"),
      DateFormat("dd/MM/yyyy"),
      DateFormat("MM/dd/yyyy"),
      DateFormat("yyyy/MM/dd"),
      DateFormat("dd.MM.yyyy"),
      DateFormat("MM.dd.yyyy"),
      DateFormat("yyyy.MM.dd"),
      DateFormat("yyyy-MM-ddTHH:mm:ss"),
    ];

    DateTime? parsedDate;

    for (var format in formats) {
      try {
        parsedDate = format.parseStrict(inputDate);
        break;
      } catch (_) {
        continue;
      }
    }

    if (parsedDate == null) {
      throw FormatException("Invalid date format: $inputDate");
    }

    return DateFormat("dd-MM-yyyy").format(parsedDate);
  }

  String convertDateForBackend(String inputDate) {
    final formats = [
      DateFormat("dd-MM-yyyy"),
      DateFormat("MM-dd-yyyy"),
      DateFormat("yyyy-MM-dd"),
      DateFormat("dd/MM/yyyy"),
      DateFormat("MM/dd/yyyy"),
      DateFormat("yyyy/MM/dd"),
      DateFormat("dd.MM.yyyy"),
      DateFormat("MM.dd.yyyy"),
      DateFormat("yyyy.MM.dd"),
      DateFormat("yyyy-MM-ddTHH:mm:ss"),
    ];

    DateTime? parsedDate;

    for (var format in formats) {
      try {
        parsedDate = format.parseStrict(inputDate);
        break;
      } catch (_) {
        continue;
      }
    }

    if (parsedDate == null) {
      throw FormatException("Invalid date format: $inputDate");
    }

    return DateFormat("MM-dd-yyyy").format(parsedDate);
  }
}
