import 'package:fintech_new_web/features/inwardVoucher/provider/inward_voucher_provider.dart';
import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../utility/models/forms_UI.dart';

class CustomTextField extends StatefulWidget {
  final FormUI field;
  final String feature;
  final TextInputType inputType;
  final Function? customMethod;
  final Widget? suffixWidget;
  final bool focus;
  const CustomTextField(
      {super.key,
      required this.field,
      required this.feature,
      required this.inputType,
      this.customMethod,
      this.suffixWidget,
      this.focus = false});

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    widget.field.controller?.text = "${widget.field.defaultValue ?? ''}";
    GlobalVariables.requestBody[widget.feature][widget.field.id] =
        (widget.field.defaultValue == "null" || widget.field.defaultValue == '')
            ? null
            : widget.field.defaultValue;

    _focusNode = FocusNode();
    // Request focus when widget is created
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 47,
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: TextFormField(
        focusNode: widget.focus ? _focusNode : null,
        style: (widget.field.readOnly)
            ? TextStyle(color: HexColor("#555555"), fontSize: 13)
            : const TextStyle(color: Colors.black, fontSize: 13),
        readOnly: widget.field.readOnly,
        controller: widget.field.controller,
        keyboardType: TextInputType.text,
        obscureText: widget.field.id == 'password' ? true : false,
        decoration: InputDecoration(
          suffix: widget.suffixWidget,
          filled: true,
          fillColor: Colors.white,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black45, width: 0.8),
              borderRadius: BorderRadius.all(Radius.circular(4))),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: widget.field.readOnly ? Colors.grey : Colors.black45,
                width: 1),
          ),
        ),
        validator: (String? val) {
          if ((val == null || val.isEmpty) && widget.field.isMandatory) {
            return '${widget.field.name} field is Mandatory';
          }
          if (widget.feature == InwardVoucherProvider.featureName) {
            var data =
                GlobalVariables.requestBody[InwardVoucherProvider.featureName];

            if (widget.field.id == "rdisc") {
              if (data['discType'] == 'P' &&
                  double.parse("${data['rdisc'] ?? 0}") <= 0) {
                return "For selected discount type discount rate should be greater than 0";
              } else if (data['discType'] == 'N' &&
                  double.parse("${data['rdisc'] ?? 0}") != 0) {
                return "Discount rate not applicable for selected discount type";
              } else if (data['discType'] == 'F' &&
                  double.parse("${data['rdisc'] ?? 0}") < 0) {
                return "Discount rate not applicable for selected discount type";
              }
            }
            if (widget.field.id == "tAmount") {
              double amount = double.parse("${data['amount'] ?? 0}");
              double discAmount =
                  double.parse("${data['discountAmount'] ?? 0}");
              double gstAmount = double.parse("${data['gstAmount'] ?? 0}");
              double totalAmount = (amount - discAmount) +
                  double.parse("${data['cessamount'] ?? 0}") +
                  double.parse("${data['roff'] ?? 0}") +
                  double.parse("${data['tcsAmount'] ?? 0}") +
                  gstAmount;

              if (double.parse("${data['tAmount'] ?? 0}") != totalAmount) {
                return "There is some calculation mistake";
              }
            }
          }
        },
        maxLines: widget.field.id == 'password' ? 1: null,
        onChanged: (value) {
          GlobalVariables.requestBody[widget.feature][widget.field.id] =
              value == "" ? null : value;
          if (widget.customMethod != null) {
            widget.customMethod!();
          }
        },
        inputFormatters: <TextInputFormatter>[
          if (widget.field.regex != null)
            FilteringTextInputFormatter.allow(RegExp(widget.field.regex!)),
          LengthLimitingTextInputFormatter(widget.field.maxCharacter)
        ],
      ),
    );
  }
}
