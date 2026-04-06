import 'package:flutter/cupertino.dart';

import '../../network/service/network_service.dart';
import 'package:http/http.dart' as http;

import '../../utility/global_variables.dart';

class AdvanceRequirementProvider with ChangeNotifier {
  static const String featureName = "AdvanceRequirement";

  NetworkService networkService = NetworkService();
  List<List<TextEditingController>> rowControllers = [];

  void initDetailsTab(List<List<String>> tableRows) {
    rowControllers = tableRows
        .map((row) =>
        row.map((field) => TextEditingController(text: field)).toList())
        .toList();
    notifyListeners();
  }

  void deleteRowController(int index) {
    rowControllers.removeAt(index);
    notifyListeners();
  }

  void addRowController() {
    rowControllers.add([
      TextEditingController(),
      TextEditingController(),
    ]);
    notifyListeners();
  }

  Future<http.StreamedResponse> processFormInfo(
      List<List<String>> tableRows, bool isManual) async {
    List<Map<String, dynamic>> payload = [];
    for (int i = 0; i < tableRows.length; i++) {
      payload.add({
        "matno": tableRows[i][0],
        "qty": tableRows[i][1],
      });
    }
    if (isManual) {
      GlobalVariables.requestBody[featureName] = payload;
    }
    http.StreamedResponse response = await networkService.post(
        "/add-advance-req/", GlobalVariables.requestBody[featureName]);
    return response;
  }

}