import 'package:flutter/cupertino.dart';

class FormUI {
  final String id;
  final String name;
  String? placeholder;
  final bool isMandatory;
  dynamic defaultValue;
  final String inputType;
  Function? eventTrigger;
  final int maxCharacter;
  final int minCharacter;
  final bool readOnly;
  dynamic controller;
  String? dropdownMenuItem;
  Widget? suffix;
  List<dynamic> children;

  FormUI(
      {required this.id,
        required this.name,
        this.placeholder,
        required this.isMandatory,
        this.defaultValue,
        required this.inputType,
        this.eventTrigger,
        this.maxCharacter = 255,
        this.minCharacter = 0,
        this.readOnly = false,
        this.controller,
        this.dropdownMenuItem,
        this.suffix,
        this.children = const []});
}
