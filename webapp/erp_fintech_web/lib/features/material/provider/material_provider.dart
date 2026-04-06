import 'dart:convert';

import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:fintech_new_web/features/utility/models/forms_UI.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../network/service/network_service.dart';
import '../../utility/services/common_utility.dart';
import '../../utility/services/generate_form_service.dart';

class MaterialProvider with ChangeNotifier {
  static const String featureName = "material";
  static const String reportFeature = "materialReport";
  static const String stockReportFeature = "materialStockReport";
  static const String stockValueReportFeature = "materialValueStockReport";
  static const String reOrderReportFeature = "materialReorderReport";

  List<FormUI> formFieldDetails = [];
  List<Widget> widgetList = [];
  List<Widget> stockReportWidgetList = [];
  List<Widget> reOrderRepWidgetList = [];
  TextEditingController editController = TextEditingController();

  List<dynamic> matGroup = [];
  List<dynamic> matUnit = [];
  List<dynamic> matType = [];
  List<dynamic> materialReportList = [];
  List<dynamic> materialSearched = [];
  List<dynamic> materialStockReport = [];
  List<dynamic> matReorderRep = [];
  List<dynamic> stockValueRep = [];

  List<DataRow> rows = [];
  List<DataRow> stockValueRows = [];

  NetworkService networkService = NetworkService();
  GenerateFormService formService = GenerateFormService();

  String jsonData =
      '[{"id": "matno","name": "Material Code","isMandatory": true,"inputType": "text","maxCharacter": 15  },  {"id": "skuno","name": "SKU Code","isMandatory": false,"inputType": "text","maxCharacter": 15  },  {"id": "matDescription","name": "Material Description","isMandatory": true,"inputType": "text","maxCharacter": 100  },  {"id": "inentoryitem","name": "Inventory Item","isMandatory": false,"inputType": "dropdown", "dropdownMenuItem" : "/get-tf/"},{"id": "saleitem","name": "Sale Item","isMandatory": false,"inputType": "dropdown", "dropdownMenuItem" : "/get-tf/"},  {"id": "purchaseitem","name": "Purchase Item","isMandatory": false, "inputType": "dropdown", "dropdownMenuItem" : "/get-tf/"},  {"id": "hsnCode","name": "HSN Code","isMandatory": true,"inputType": "text"},  {"id": "prate","name": "Purchase Rate","isMandatory": true,"inputType": "number"  },  {"id": "puUnit","name": "Unit","isMandatory": true,"inputType": "dropdown","dropdownMenuItem": "/get-material-unit/"  },  {"id": "skUnit","name": "SK Unit","isMandatory": true,"inputType": "dropdown","dropdownMenuItem": "/get-material-unit/"  },  {"id": "conFactor","name": "Con. Factor","inputType": "number","isMandatory": true  },{"id": "skrate","name": "SK Rate","inputType": "number","isMandatory": false  } ,{"id": "spq","name": "SPQ","inputType": "number","isMandatory": false  },  {"id": "saleDescription","name": "Sale Description","isMandatory": false,"inputType": "text","maxCharacter": 50  },  {"id": "mrp","name": "MRP","isMandatory": false,"inputType": "number"  },  {"id": "listPrice","name": "List Price","isMandatory": false,"inputType": "number"  }, {"id" : "discType" , "name" : "Discount Type", "isMandatory" : true, "inputType" : "dropdown", "dropdownMenuItem" : "/get-material-discount-type/"} ,{"id": "discRate","name": "Discount Rate","isMandatory": false,"inputType": "number"  },{"id": "fixedPrice","name": "Fixed Price","isMandatory": false,"inputType": "number"  },  {"id": "isQc","name": "Is Qc?","isMandatory": true,"inputType": "dropdown","dropdownMenuItem" : "/get-yesno/"  }, {"id" : "isStockKeeping", "name" : "Stock Keeping", "isMandatory" : true, "inputType":"dropdown", "dropdownMenuItem": "/get-yesno/"}, {"id": "materialType","name": "Material Type","isMandatory": true,"inputType": "dropdown","dropdownMenuItem" : "/get-material-type/"  },  {"id": "materialGroup","name": "Material Group","isMandatory": true,"inputType": "dropdown","dropdownMenuItem" : "/get-material-group/"  },  {"id": "materialSubGroup","name": "Material Sub Group","isMandatory": false,"inputType": "dropdown","dropdownMenuItem" : "/get-material-subgroup/"  },  {"id": "weight","name": "Weight","isMandatory": false,"inputType": "number"  },  {"id": "location","name": "Location","isMandatory": false,"inputType": "text","maxCharacter":20  },  {"id": "minLevel","name": "Min Level","isMandatory": true,"inputType": "number"  },  {"id": "maxLevel","name": "Max Level","isMandatory": true,"inputType": "number"  },  {"id": "reqLevel","name": "Required Level","isMandatory": true,"inputType": "number"  },  {"id" : "mst","name" : "Material Status","isMandatory": true,"inputType" : "dropdown","dropdownMenuItem" : "/get-material-status/"},{"id": "doclosing","name": "Closing Date","isMandatory": false,"inputType": "datetime"}]';

  void reset() {
    GlobalVariables.requestBody[featureName] = {};
    formFieldDetails.clear();
    widgetList.clear();
    notifyListeners();
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

  Future<http.StreamedResponse> processFormInfo(bool manualOrder) async {
    var payload = manualOrder
        ? [GlobalVariables.requestBody[featureName]]
        : GlobalVariables.requestBody[featureName];
    http.StreamedResponse response =
        await networkService.post("/add-material/", payload);
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
        '[{"id":"fmatno","name":"From Material No.","isMandatory":false,"inputType":"text","maxCharacter":15},{"id":"tmatno","name":"To Material No.","isMandatory":false,"inputType":"text","maxCharacter":15},{"id":"materialType","name":"Material Type","isMandatory":false,"inputType":"dropdown","dropdownMenuItem":"/get-material-type/"},{"id":"materialGroup","name":"Material Group","isMandatory":false,"inputType":"dropdown","dropdownMenuItem":"/get-material-group/"},{"id":"mst","name":"Material Status","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-material-status/","default":"A"}]';
    GlobalVariables.requestBody[reportFeature] = {};
    formFieldDetails.clear();
    widgetList.clear();

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
    widgetList.addAll(widgets);
    notifyListeners();
  }

  void getMaterialReport() async {
    materialReportList.clear();
    http.StreamedResponse response = await networkService.post(
        "/get-material-report/", GlobalVariables.requestBody[reportFeature]);
    if (response.statusCode == 200) {
      materialReportList = jsonDecode(await response.stream.bytesToString());
      materialSearched = materialReportList;
    }
    notifyListeners();
  }

  void search(String target, List<String> fields) {
    if (target.length >= 3) {
      materialSearched = materialReportList.where((item) {
        return fields.any((field) {
          var value = item;

          for (var key in field.split('.')) {
            if (value is Map && value.containsKey(key)) {
              value = value[key];
            } else {
              return false;
            }
          }
          return value.toString().toLowerCase().contains(target.toLowerCase());
        });
      }).toList();
    } else {
      materialSearched = materialReportList;
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

  void initReorderReportWidget() async {
    String jsonData =
        '[{"id":"type","name":"Type [L/G]","isMandatory":true,"inputType":"text","maxCharacter":1, "default" : "L"},{"id":"mst","name":"Material Status","isMandatory":true,"inputType":"dropdown","dropdownMenuItem":"/get-material-status/","default":"A"},{"id":"materialType","name":"Material Type","isMandatory":false,"inputType":"dropdown","dropdownMenuItem":"/get-material-type/"},{"id":"materialGroup","name":"Material Group","isMandatory":false,"inputType":"dropdown","dropdownMenuItem":"/get-material-group/"},{"id":"fmatno","name":"From Material No.","isMandatory":false,"inputType":"text","maxCharacter":15},{"id":"tmatno","name":"To Material No.","isMandatory":false,"inputType":"text","maxCharacter":15}]';
    GlobalVariables.requestBody[reOrderReportFeature] = {};
    formFieldDetails.clear();
    reOrderRepWidgetList.clear();

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
        formFieldDetails, reOrderReportFeature);
    reOrderRepWidgetList.addAll(widgets);
    notifyListeners();
  }

  void getMaterialMinMaxReport() async {
    matReorderRep.clear();
    http.StreamedResponse response = await networkService.post(
        "/mat-min-max-report/", GlobalVariables.requestBody[reOrderReportFeature]);
    if (response.statusCode == 200) {
      matReorderRep = jsonDecode(await response.stream.bytesToString());
    }
    getRows();
  }

  void initStockValueReportWidget() async {
    String jsonData =
        '[{"id":"materialType","name":"Material Type","isMandatory":false,"inputType":"dropdown","dropdownMenuItem":"/get-material-type/"},{"id":"fmatno","name":"From Material No.","isMandatory":false,"inputType":"text","maxCharacter":15},{"id":"tmatno","name":"To Material No.","isMandatory":false,"inputType":"text","maxCharacter":15}]';
    GlobalVariables.requestBody[stockValueReportFeature] = {};
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
        formFieldDetails, stockValueReportFeature);
    stockReportWidgetList.addAll(widgets);
    notifyListeners();
  }

  void getStockValueReport() async {
    stockValueRep.clear();
    http.StreamedResponse response = await networkService.post(
        "/stock-value-report/", GlobalVariables.requestBody[stockValueReportFeature]);
    if (response.statusCode == 200) {
      stockValueRep = jsonDecode(await response.stream.bytesToString());
    }
    getStockValueRows();
  }

  void getStockValueRows() {
    List<double> totals = [0, 0, 0, 0,0];
    stockValueRows.clear();

    for (var data in stockValueRep) {
      totals[0] = totals[0] + parseEmptyStringToDouble('${data['opening']}');
      totals[1] = totals[1] + parseEmptyStringToDouble('${data['received']}');
      totals[2] = totals[2] + parseEmptyStringToDouble('${data['released']}');
      totals[3] = totals[3] + parseEmptyStringToDouble('${data['qtyinstock']}');
      totals[4] = totals[4] + parseEmptyStringToDouble('${data['amount']}');
      stockValueRows.add(DataRow(cells: [
        DataCell(Text('${data['matno'] ?? "-"}')),
        DataCell(Text('${data['matDescription'] ?? "-"}')),
        DataCell(Text('${data['hsnCode'] ?? "-"}')),
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
        DataCell(Align(
            alignment: Alignment.centerRight,
            child: Text(parseDoubleUpto2Decimal('${data['amount']}')))),
      ]));
    }

    stockValueRows.add(DataRow(cells: [
      const DataCell(Text("")),
      const DataCell(Text("")),
      const DataCell(
          Text('TOTAL', style: TextStyle(fontWeight: FontWeight.bold))),
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
      DataCell(Align(
          alignment: Alignment.centerRight,
          child: Text(parseDoubleUpto2Decimal('${totals[4]}'),
              style: const TextStyle(fontWeight: FontWeight.bold)))),
    ]));

    notifyListeners();
  }
}
