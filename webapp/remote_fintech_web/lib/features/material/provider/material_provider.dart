import 'dart:convert';

import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:fintech_new_web/features/utility/models/forms_UI.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http_parser/http_parser.dart';

import '../../network/service/network_service.dart';
import '../../utility/services/common_utility.dart';
import '../../utility/services/generate_form_service.dart';

class MaterialProvider with ChangeNotifier {
  static const String featureName = "material";
  static const String reportFeature = "materialReport";
  static const String stockReportFeature = "materialStockReport";

  List<FormUI> formFieldDetails = [];
  List<Widget> widgetList = [];
  List<Widget> reportWidgetList = [];
  List<Widget> stockReportWidgetList = [];
  TextEditingController editController = TextEditingController();

  List<dynamic> matGroup = [];
  List<dynamic> matUnit = [];
  List<dynamic> matType = [];
  List<dynamic> materialReportList = [];
  List<dynamic> materialStockReport = [];

  List<DataRow> rows = [];

  NetworkService networkService = NetworkService();
  GenerateFormService formService = GenerateFormService();

  String jsonData =
      '[{"id":"matno","name":"Material Code","isMandatory":true,"inputType":"text","maxCharacter":15},{"id":"hsnCode","name":"HSN Code","isMandatory":true,"inputType":"text"},{"id":"matDescription","name":"Material Description","isMandatory":true,"inputType":"text","maxCharacter":100},{"id":"prate","name":"Purchase Rate","isMandatory":true,"inputType":"number"},{"id":"unit","name":"Unit","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-material-unit/"},{"id":"saleDescription","name":"Sale Description","isMandatory":false,"inputType":"text","maxCharacter":50},{"id":"mrp","name":"MRP","isMandatory":false,"inputType":"number"},{"id":"listPrice","name":"List Price","isMandatory":false,"inputType":"number"},{"id":"discRate","name":"Discount Rate","isMandatory":false,"inputType":"number"},{"id":"smargin","name":"Margin","isMandatory":true,"inputType":"number"},{"id":"srate","name":"Sale Rate","isMandatory":true,"inputType":"number", "default" : 0},{"id":"mst","name":"Material Status","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-material-status/", "default" : "A"}]';

  void reset() {
    GlobalVariables.requestBody[featureName] = {};
    formFieldDetails.clear();
    widgetList.clear();
  }

  void initWidget() async {
    GlobalVariables.requestBody[featureName] = {};
    formFieldDetails.clear();
    widgetList.clear();

    for (var element in jsonDecode(jsonData)) {
      formFieldDetails.add(FormUI(
          id: element['id'],
          name: element['name'],
          isMandatory: element['isMandatory'],
          inputType: element['inputType'],
          dropdownMenuItem: element['dropdownMenuItem'] ?? "",
          maxCharacter: element['maxCharacter'] ?? 255));
    }

    List<Widget> widgets =
        await formService.generateDynamicForm(formFieldDetails, featureName);
    widgetList.addAll(widgets);
    notifyListeners();
  }

  Future<Map<String, dynamic>> getByIdMaterial() async {
    http.StreamedResponse response =
        await networkService.get("/get-material/${editController.text}/");
    if (response.statusCode == 200) {
      return jsonDecode(await response.stream.bytesToString())[0];
    }
    return {};
  }

  void initEditWidget() async {
    GlobalVariables.requestBody[featureName] = {};
    formFieldDetails.clear();
    widgetList.clear();
    Map<String, dynamic> editMapData = await getByIdMaterial();
    GlobalVariables.requestBody[featureName] = editMapData;

    for (var element in jsonDecode(jsonData)) {
      TextEditingController editController = TextEditingController();
      formFieldDetails.add(FormUI(
          id: element['id'],
          name: element['name'],
          isMandatory: false,
          inputType: element['inputType'],
          dropdownMenuItem: element['dropdownMenuItem'] ?? "",
          maxCharacter: element['maxCharacter'] ?? 255,
          controller: editController,
          defaultValue: editMapData[element['id']]));
    }

    List<Widget> widgets =
        await formService.generateDynamicForm(formFieldDetails, featureName);
    widgetList.addAll(widgets);
    notifyListeners();
  }

  Future<http.StreamedResponse> processUpdateFormInfo() async {
    http.StreamedResponse response = await networkService.post(
        "/update-material/", GlobalVariables.requestBody[featureName]);
    return response;
  }

  Future<http.StreamedResponse> processFormInfo(bool manual, {String path = "", String name = ""}) async {
    if (!manual) {
      // If Importing
      http.StreamedResponse respFile = await uploadExcel(path,name);
      return respFile;
    }
    http.StreamedResponse response = await networkService
        .post("/add-material/", [GlobalVariables.requestBody[featureName]]);
    return response;
  }

  void getMatGroup() async {
    matGroup.clear();
    http.StreamedResponse response =
        await networkService.get("/get-material-group/");
    if (response.statusCode == 200) {
      var data = jsonDecode(await response.stream.bytesToString());
      matGroup = data;
    }
    notifyListeners();
  }

  void getMatUnit() async {
    matUnit.clear();
    http.StreamedResponse response =
        await networkService.get("/get-material-unit/");
    if (response.statusCode == 200) {
      var data = jsonDecode(await response.stream.bytesToString());
      matUnit = data;
    }
    notifyListeners();
  }

  void getMatType() async {
    matType.clear();
    http.StreamedResponse response =
        await networkService.get("/get-material-type/");
    if (response.statusCode == 200) {
      var data = jsonDecode(await response.stream.bytesToString());
      matType = data;
    }
    notifyListeners();
  }

  void initReportWidget() async {
    String jsonData =
        '[{"id":"fmatno","name":"From Material No.","isMandatory":false,"inputType":"text","maxCharacter":15},{"id":"tmatno","name":"To Material No.","isMandatory":false,"inputType":"text","maxCharacter":15},{"id":"mst","name":"Material Status","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-material-status/","default":"A"}]';
    GlobalVariables.requestBody[reportFeature] = {};
    formFieldDetails.clear();
    reportWidgetList.clear();

    for (var element in jsonDecode(jsonData)) {
      TextEditingController controller = TextEditingController();
      formFieldDetails.add(FormUI(
          id: element['id'],
          name: element['name'],
          isMandatory: element['isMandatory'],
          controller: controller,
          inputType: element['inputType'],
          dropdownMenuItem: element['dropdownMenuItem'] ?? "",
          maxCharacter: element['maxCharacter'] ?? 255,
          defaultValue: element['default']));
    }
    List<Widget> widgets =
        await formService.generateDynamicForm(formFieldDetails, reportFeature);
    reportWidgetList.addAll(widgets);
    notifyListeners();
  }

  void getMaterialReport() async {
    materialReportList.clear();
    http.StreamedResponse response = await networkService.post(
        "/get-material-report/", GlobalVariables.requestBody[reportFeature]);
    if (response.statusCode == 200) {
      materialReportList = jsonDecode(await response.stream.bytesToString());
    }
    notifyListeners();
  }

  void initStockReportWidget() async {
    String jsonData =
        '[{"id":"mst","name":"Material Status","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-material-status/","default":"A"},{"id":"materialType","name":"Material Type","isMandatory":false,"inputType":"dropdown","dropdownMenuItem":"/get-material-type/"},{"id":"materialGroup","name":"Material Group","isMandatory":false,"inputType":"dropdown","dropdownMenuItem":"/get-material-group/"},{"id":"fmatno","name":"From Material No.","isMandatory":false,"inputType":"text","maxCharacter":15},{"id":"tmatno","name":"To Material No.","isMandatory":false,"inputType":"text","maxCharacter":15}]';
    GlobalVariables.requestBody[stockReportFeature] = {};
    formFieldDetails.clear();
    stockReportWidgetList.clear();

    for (var element in jsonDecode(jsonData)) {
      TextEditingController controller = TextEditingController();
      formFieldDetails.add(FormUI(
          id: element['id'],
          name: element['name'],
          isMandatory: element['isMandatory'],
          controller: controller,
          inputType: element['inputType'],
          dropdownMenuItem: element['dropdownMenuItem'] ?? "",
          maxCharacter: element['maxCharacter'] ?? 255,
          defaultValue: element['default']));
    }
    List<Widget> widgets = await formService.generateDynamicForm(
        formFieldDetails, stockReportFeature);
    stockReportWidgetList.addAll(widgets);
    notifyListeners();
  }

  void getMaterialStockReport() async {
    materialStockReport.clear();
    http.StreamedResponse response = await networkService.post(
        "/mat-stock-report/", GlobalVariables.requestBody[stockReportFeature]);
    if (response.statusCode == 200) {
      materialStockReport = jsonDecode(await response.stream.bytesToString());
    }
    getRows();
  }

  void getRows() {
    List<double> totals = [0, 0, 0, 0];
    rows.clear();

    for (var data in materialStockReport) {
      totals[0] = totals[0] + parseEmptyStringToDouble('${data['opening']}');
      totals[1] = totals[1] + parseEmptyStringToDouble('${data['received']}');
      totals[2] = totals[2] + parseEmptyStringToDouble('${data['released']}');
      totals[3] = totals[3] + parseEmptyStringToDouble('${data['qtyinstock']}');
      rows.add(DataRow(cells: [
        DataCell(Text('${data['matno'] ?? "-"}')),
        DataCell(Text('${data['matDescription'] ?? "-"}')),
        DataCell(Text('${data['hsnCode'] ?? "-"}')),
        DataCell(Text('${data['minLevel'] ?? "-"}')),
        DataCell(Text('${data['maxLevel'] ?? "-"}')),
        DataCell(Text('${data['reqLevel'] ?? "-"}')),
        DataCell(Align(
            alignment: Alignment.centerRight,
            child: Text(parseDoubleUpto2Decimal('${data['opening']}')))),
        DataCell(Align(
            alignment: Alignment.centerRight,
            child: Text(parseDoubleUpto2Decimal('${data['received']}')))),
        DataCell(Align(
            alignment: Alignment.centerRight,
            child: Text(parseDoubleUpto2Decimal('${data['released']}')))),
        DataCell(Align(
            alignment: Alignment.centerRight,
            child: Text(parseDoubleUpto2Decimal('${data['qtyinstock']}')))),
      ]));
    }

    rows.add(DataRow(cells: [
      const DataCell(Text("")),
      const DataCell(Text("")),
      const DataCell(Text("")),
      const DataCell(
          Text('TOTAL', style: TextStyle(fontWeight: FontWeight.bold))),
      const DataCell(Text("")),
      const DataCell(Text("")),
      DataCell(Align(
          alignment: Alignment.centerRight,
          child: Text(parseDoubleUpto2Decimal('${totals[0]}'),
              style: const TextStyle(fontWeight: FontWeight.bold)))),
      DataCell(Align(
          alignment: Alignment.centerRight,
          child: Text(parseDoubleUpto2Decimal('${totals[1]}'),
              style: const TextStyle(fontWeight: FontWeight.bold)))),
      DataCell(Align(
          alignment: Alignment.centerRight,
          child: Text(parseDoubleUpto2Decimal('${totals[2]}'),
              style: const TextStyle(fontWeight: FontWeight.bold)))),
      DataCell(Align(
          alignment: Alignment.centerRight,
          child: Text(parseDoubleUpto2Decimal('${totals[3]}'),
              style: const TextStyle(fontWeight: FontWeight.bold)))),
    ]));

    notifyListeners();
  }



  Future<http.StreamedResponse> uploadExcel(String blobPath, String name) async {
    var request = http.MultipartRequest(
        'POST', Uri.parse('${NetworkService.baseUrl}/import-materials/'));

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("auth_token");
    var headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      "Authorization": "Bearer $token"
    };

    if (kIsWeb) {
      // Fetch the blob
      final response = await http.get(Uri.parse(blobPath));

      if (response.statusCode == 200) {
        final Uint8List bytes = response.bodyBytes;

        // Create a multipart file
        final http.MultipartFile multipartFile = http.MultipartFile.fromBytes(
          'file',
          bytes,
          filename: name,
          contentType: MediaType('image', 'png'),
        );

        // Add the multipart file to the request
        request.files.add(multipartFile);
      }
    } else {
      request.files.add(await http.MultipartFile.fromPath('file', blobPath));
    }
    request.headers.addAll(headers);
    http.StreamedResponse respFile = await request.send();

    return respFile;
  }
}
