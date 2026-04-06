import 'dart:convert';

import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:fintech_new_web/features/utility/models/forms_UI.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../../network/service/network_service.dart';
import '../../utility/services/common_utility.dart';
import '../../utility/services/generate_form_service.dart';

class MasterProvider with ChangeNotifier {
  List<dynamic> states = [];
  List<dynamic> country = [];
  List<dynamic> gstTaxRates = [];
  List<dynamic> hsnCodes = [];

  NetworkService networkService = NetworkService();

  void getStates() async {
    http.StreamedResponse response = await networkService.get("/get-states/");
    if (response.statusCode == 200) {
      states = jsonDecode(await response.stream.bytesToString());
    }
  }

  void getGstTaxRate() async {
    http.StreamedResponse response = await networkService.get("/get-gst-tax-rate/");
    if (response.statusCode == 200) {
      gstTaxRates = jsonDecode(await response.stream.bytesToString());
    }
  }

  void getHsnCode() async {
    http.StreamedResponse response = await networkService.get("/get-hsn/");
    if (response.statusCode == 200) {
      hsnCodes = jsonDecode(await response.stream.bytesToString());
    }
  }

  void getCountry() async {
    http.StreamedResponse response = await networkService.get("/get-countries/");
    if (response.statusCode == 200) {
      country = jsonDecode(await response.stream.bytesToString());
    }
    notifyListeners();
  }

  void init() {
    getStates();
    getGstTaxRate();
    getHsnCode();
    getCountry();
  }
}
