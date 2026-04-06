import 'dart:convert';

import 'package:fintech_new_web/features/common/widgets/file_upload_field.dart';
import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:searchable_paginated_dropdown/searchable_paginated_dropdown.dart';
import '../../common/widgets/custom_datetime_field.dart';
import '../../common/widgets/custom_dropdown_field.dart';
import '../../common/widgets/custom_text_field.dart';
import '../../network/service/network_service.dart';
import '../models/forms_UI.dart';

class GenerateFormService {
  Future<List<Widget>> generateDynamicForm(
      List<FormUI> formFields, String featureName,
      {bool disableDefault = false, bool isRow = false}) async {
    List<Widget> dynamicForm = [];
    for (FormUI eachField in formFields) {
      switch (eachField.inputType) {
        case ("text"):
        case ("number"):
        case ("email"):
          if (isRow) {
            dynamicForm.add(CustomTextField(
              field: eachField,
              feature: featureName,
              inputType: getInputType(eachField.inputType),
              suffixWidget: eachField.suffix,
              isRow: false,
            ));
          } else {
            dynamicForm.add(Row(
              children: [
                SizedBox(
                  width: GlobalVariables.deviceWidth * 0.13,
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: eachField.isMandatory ? "*" : "",
                          style: const TextStyle(color: Colors.red),
                        )
                      ],
                      text: eachField.name,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: CustomTextField(
                    field: eachField,
                    feature: featureName,
                    inputType: getInputType(eachField.inputType),
                    suffixWidget: eachField.suffix,
                  ),
                ),
              ],
            ));
          }
          break;

        case ("datetime"):
          if (isRow) {
            dynamicForm.add(Expanded(
              child: CustomDatetimeField(
                  field: eachField,
                  feature: featureName,
                  disableDefault: disableDefault),
            ));
          } else {
            dynamicForm.add(Row(
              children: [
                SizedBox(
                  width: GlobalVariables.deviceWidth * 0.13,
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: eachField.isMandatory ? "*" : "",
                          style: const TextStyle(color: Colors.red),
                        )
                      ],
                      text: eachField.name,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: CustomDatetimeField(
                      field: eachField,
                      feature: featureName,
                      disableDefault: disableDefault),
                ),
              ],
            ));
          }
          break;

        case ("dropdown"):
          List<SearchableDropdownMenuItem<String>> items =
          await getDropdownMenuItem(eachField.dropdownMenuItem ?? "");

          if (isRow) {
            dynamicForm.add(CustomDropdownField(
              field: eachField,
              dropdownMenuItems: items,
              feature: featureName,
              customFunction: eachField.eventTrigger,
            ));
          } else {
            dynamicForm.add(Row(
              children: [
                SizedBox(
                  width: GlobalVariables.deviceWidth * 0.13,
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: eachField.isMandatory ? "*" : "",
                          style: const TextStyle(color: Colors.red),
                        )
                      ],
                      text: eachField.name,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: CustomDropdownField(
                    field: eachField,
                    dropdownMenuItems: items,
                    feature: featureName,
                    customFunction: eachField.eventTrigger,
                  ),
                ),
              ],
            ));
          }
          break;

        case ("row"):
          List<FormUI> rowForm = [];

          for (var data in eachField.children) {
            TextEditingController editController = TextEditingController();
            rowForm.add(FormUI(
                id: data['id'],
                name: data['name'],
                isMandatory: data['isMandatory'],
                controller: editController,
                defaultValue: (eachField.defaultValue ?? {})[data['id']],
                inputType: data['inputType'],
                dropdownMenuItem: data['dropdownMenuItem'] ?? "",
                maxCharacter: data['maxCharacter'] ?? 255));
          }

          List<Widget> childrenWidget =
          await generateDynamicForm(rowForm, featureName, isRow: true);

          var length = (GlobalVariables.deviceWidth / 2) - (GlobalVariables.deviceWidth * 0.13);

          double w1 = length * 0.35;
          double w2 = length * 0.61;

          if (rowForm[0].maxCharacter > rowForm[1].maxCharacter) {
            w1 = length * 0.61;
            w2 = length * 0.35;
          }

          if(childrenWidget.length == 2) {
            if(rowForm[0].maxCharacter==rowForm[1].maxCharacter) {
              dynamicForm.add(Row(children: [
                SizedBox(
                  width: GlobalVariables.deviceWidth * 0.13,
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: eachField.isMandatory ? "*" : "",
                          style: const TextStyle(color: Colors.red),
                        )
                      ],
                      text: eachField.name,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
                Expanded(child: childrenWidget[0]),
                Expanded(child: childrenWidget[1]),
              ]));
            } else {
              dynamicForm.add(Row(children: [
                SizedBox(
                  width: GlobalVariables.deviceWidth * 0.13,
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: eachField.isMandatory ? "*" : "",
                          style: const TextStyle(color: Colors.red),
                        )
                      ],
                      text: eachField.name,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
                (rowForm[0].inputType == "number" || rowForm[0].inputType == "dropdown") ? Expanded(child: childrenWidget[0]) : SizedBox(width: w1, child: childrenWidget[0]),
                (rowForm[1].inputType == "number" || rowForm[1].inputType == "dropdown") ? Expanded(child: childrenWidget[1]) : SizedBox(width: w2, child: childrenWidget[1]),
              ]));
            }

          } else {
            dynamicForm.add(Row(children: [
              SizedBox(
                width: GlobalVariables.deviceWidth * 0.13,
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: eachField.isMandatory ? "*" : "",
                        style: const TextStyle(color: Colors.red),
                      )
                    ],
                    text: eachField.name,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
              Expanded(child: childrenWidget[0]),
              Expanded(child: childrenWidget[1]),
              Expanded(child: childrenWidget[2]),
            ]));
          }


        case ("fileUpload"):
          dynamicForm.add(
              FileUploadField(fieldDetails: eachField, feature: featureName));
          break;
      }
    }
    return dynamicForm;
  }

  TextInputType getInputType(String type) {
    switch (type.toLowerCase()) {
      case 'text':
        return TextInputType.text;
      case 'number':
        return TextInputType.number;
      case 'email':
        return TextInputType.emailAddress;
      case 'phone':
        return TextInputType.phone;
      case 'url':
        return TextInputType.url;
      case 'datetime':
        return TextInputType.datetime;
      case 'multiline':
        return TextInputType.multiline;
      default:
        return TextInputType.text; // Default fallback
    }
  }

  Future<List<SearchableDropdownMenuItem<String>>> getDropdownMenuItem(
      String endpoint) async {
    NetworkService networkService = NetworkService();
    List<SearchableDropdownMenuItem<String>> dropdownMenu = [];
    try {
      http.StreamedResponse response = await networkService.get(endpoint);
      if (response.statusCode == 200) {
        var data = jsonDecode(await response.stream.bytesToString());
        List<String> keys = data[0].keys.toList();
        for (var element in data) {
          dropdownMenu.add(SearchableDropdownMenuItem(
              value: element[keys[0]].toString(),
              child: Text(element[keys[1]]),
              label: element[keys[1]]));
        }
      }
      return dropdownMenu;
    } catch (e) {
      return [];
    }
  }

}
