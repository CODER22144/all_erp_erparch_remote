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
import 'common_utility.dart';

class GenerateFormService {
  Future<List<Widget>> generateDynamicForm(
      List<FormUI> formFields, String featureName,
      {bool disableDefault = false}) async {
    List<Widget> dynamicForm = [];
    for (FormUI eachField in formFields) {
      switch (eachField.inputType) {
        case ("text"):
        case ("number"):
        case ("email"):
          dynamicForm.add(Container(
            padding: const EdgeInsets.only(left: 3, bottom: 3, top: 3),
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
          ));
          dynamicForm.add(CustomTextField(
            customMethod: eachField.eventTrigger,
            field: eachField,
            feature: featureName,
            inputType: getInputType(eachField.inputType),
            suffixWidget: eachField.suffix,
          ));
          break;

        case ("datetime"):
          dynamicForm.add(Container(
            padding: const EdgeInsets.only(left: 3, bottom: 3, top: 3),
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
          ));
          dynamicForm.add(CustomDatetimeField(
              field: eachField,
              feature: featureName,
              disableDefault: disableDefault));
          break;

        case ("dropdown"):
          List<SearchableDropdownMenuItem<String>> items = [];
          if (checkForJson(eachField.dropdownMenuItem ?? "")) {
            items = await getDropdownMenuItemByJson(eachField.dropdownMenuItem ?? "");
          } else {
            items = await getDropdownMenuItem(eachField.dropdownMenuItem ?? "");
          }

          dynamicForm.add(Container(
            padding: const EdgeInsets.only(left: 3, bottom: 3, top: 3),
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
          ));
          dynamicForm.add(CustomDropdownField(
            field: eachField,
            dropdownMenuItems: items,
            feature: featureName,
            customFunction: eachField.eventTrigger,
          ));

          break;

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

  Future<List<SearchableDropdownMenuItem<String>>> getDropdownMenuItemByJson(
      String dropdownData) async {
    List<SearchableDropdownMenuItem<String>> dropdownMenu = [];
    try {
      var data = jsonDecode(dropdownData);
      List<String> keys = data[0].keys.toList();
      for (var element in data) {
        dropdownMenu.add(SearchableDropdownMenuItem(
            value: element[keys[0]].toString(),
            child: Text(element[keys[1]]),
            label: element[keys[1]]));
      }
      return dropdownMenu;
    } catch (e) {
      return [];
    }
  }
}
