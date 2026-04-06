import 'dart:convert';

import 'package:fintech_new_web/features/network/service/network_service.dart';
import 'package:fintech_new_web/features/utility/services/generate_form_service.dart';
import 'package:flutter/cupertino.dart';

import 'package:http/http.dart' as http;
import 'package:searchable_paginated_dropdown/searchable_paginated_dropdown.dart';

import '../../utility/models/forms_UI.dart';

class QueryProvider with ChangeNotifier {
  NetworkService networkService = NetworkService();
  GenerateFormService formService = GenerateFormService();

  TextEditingController tableController = TextEditingController();

  List<SearchableDropdownMenuItem<String>> operators = [];
  List<SearchableDropdownMenuItem<String>> dataTypes = [];
  List<SearchableDropdownMenuItem<String>> columnNames = [];
  List<FormUI> formFieldDetails = [];
  List<Widget> widgetList = [];

  Future<List<dynamic>> getColumns(String tableName) async {
    http.StreamedResponse response =
        await networkService.post("/columns/", {"tableName": tableName});
    if (response.statusCode == 200) {
      var data = jsonDecode(await response.stream.bytesToString());
      setType(data['types']);
      return data['columns'];
    }
    return [];
  }

  void setType(Map<String, dynamic> data) async {
    columnNames = await getColumnsDropdown(tableController.text);
    notifyListeners();
  }

  void getOperators() async {
    operators.addAll([
      const SearchableDropdownMenuItem<String>(
          label: "Greater Than >", child: Text("Grater Than : >"), value: ">"),
      const SearchableDropdownMenuItem<String>(
          label: "Greater Than >=",
          child: Text("Grater Than Equals To : >="),
          value: ">="),
      const SearchableDropdownMenuItem<String>(
          label: "Less Than <", child: Text("Less Than : <"), value: "<"),
      const SearchableDropdownMenuItem<String>(
          label: "Less Than Equals To <=",
          child: Text("Less Than : <="),
          value: "<="),
      const SearchableDropdownMenuItem<String>(
          label: "LIKE", child: Text("Like"), value: "LIKE"),
      const SearchableDropdownMenuItem<String>(
          label: "EQUALS =", child: Text("Equals To"), value: "="),
    ]);

    dataTypes.addAll([
      const SearchableDropdownMenuItem<String>(
          label: "Date", child: Text("Date"), value: "date"),
      const SearchableDropdownMenuItem<String>(
          label: "String", child: Text("String"), value: "string"),
      const SearchableDropdownMenuItem<String>(
          label: "number", child: Text("Number"), value: "number"),
    ]);
  }

  Future<List<SearchableDropdownMenuItem<String>>> getColumnsDropdown(
      String tableName) async {
    List<SearchableDropdownMenuItem<String>> dropdown = [];
    http.StreamedResponse response =
        await networkService.post("/columns-drp/", {"tableName": tableName});
    if (response.statusCode == 200) {
      var data = jsonDecode(await response.stream.bytesToString());
      for (var element in data) {
        dropdown.add(SearchableDropdownMenuItem(
            value: element['type'].toString(),
            child: Text(element['type']),
            label: element['type']));
      }
      return dropdown;
    }
    return [];
  }

  Future<http.StreamedResponse> executeBuildQuery(
      Map<String, dynamic> payload) async {
    http.StreamedResponse response =
        await networkService.post("/execute-sql-query/", payload);
    return response;
  }
}
