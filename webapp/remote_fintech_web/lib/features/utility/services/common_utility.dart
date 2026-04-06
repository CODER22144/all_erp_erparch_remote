import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:searchable_paginated_dropdown/searchable_paginated_dropdown.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:file_saver/file_saver.dart';
import 'package:universal_html/html.dart' as fhtml; // Web-specific import
import 'package:excel/excel.dart';
import 'package:csv/csv.dart';
import 'package:intl/intl.dart';

double parseEmptyStringToDouble(String value) {
  if (value != null && value != "") {
    return double.tryParse(value) ?? 0;
  }
  return 0;
}

String parseDoubleUpto2Decimal(String value) {
  if (value != null && value != "") {
    return (double.tryParse(value) ?? 0).toStringAsFixed(2);
  }
  return '0';
}

bool checkForEmptyOrNullString(String? value) {
  if (value != null && value != "" && value != "null") {
    return true;
  }
  return false;
}

SearchableDropdownMenuItem<String> findDropdownMenuItem(
    List<SearchableDropdownMenuItem<String>> dropdown, String searchText) {
  var data = dropdown.firstWhere((item) => item.value == searchText,
      orElse: () => const SearchableDropdownMenuItem(
          value: "", label: "", child: Text("")));
  return data;
}

void downloadJsonWeb(String jsonString, String fileName) {
  final bytes = utf8.encode(jsonString);
  final blob = fhtml.Blob([bytes]);
  final url = fhtml.Url.createObjectUrlFromBlob(blob);
  final anchor = fhtml.AnchorElement(href: url)
    ..setAttribute("download", fileName)
    ..click();

  fhtml.Url.revokeObjectUrl(url);
}

void downloadForAndroid(
    String jsonString, String fileName, BuildContext context) async {
  try {
    if (await Permission.storage.request().isGranted) {
      Directory? directory = await getExternalStorageDirectory();
      String path = "${directory!.path}/$fileName";

      // Write JSON data to file
      File file = File(path);
      await file.writeAsString(jsonString);

      // Save the file using FileSaver
      await FileSaver.instance.saveFile(
        name: fileName,
        bytes: file.readAsBytesSync(),
        ext: "json",
        mimeType: MimeType.json,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("JSON file downloaded: $path")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Storage permission denied!")),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Error: $e")),
    );
  }
}

Future<void> downloadJsonToExcel(List<dynamic> jsonData, String title) async {
  // Create Excel
  var excel = Excel.createExcel();
  Sheet sheet = excel['Sheet1'];
  sheet.appendRow(jsonData.first.keys.toList());

  for (var row in jsonData) {
    sheet.appendRow(row.values.toList());
  }

  List<int>? fileBytes = excel.encode();
  String fileName = "$title.xlsx";

  if (kIsWeb) {
    // Web download
    final blob = fhtml.Blob([fileBytes]);
    final url = fhtml.Url.createObjectUrlFromBlob(blob);
    final anchor = fhtml.AnchorElement(href: url)
      ..setAttribute("download", fileName)
      ..click();
    fhtml.Url.revokeObjectUrl(url);
  } else {
    // Android / iOS
    if (!await Permission.storage.request().isGranted) {
      print("Storage permission denied.");
      return;
    }

    final directory = await getExternalStorageDirectory();
    final path = "${directory!.path}/$fileName";
    File(path)
      ..createSync(recursive: true)
      ..writeAsBytesSync(fileBytes!);
  }
}

Future<void> downloadJsonToCsv(List<dynamic> jsonList,
    {String fileName = 'data.csv', String delimiter = ','}) async {
  // Convert JSON to CSV
  List<List<String>> csvData = [];

  // final headers = jsonList.first.keys.toList();

  List<List<String>> rows = [];

  for (var row in jsonList) {
    List<String> stringRow = [];
    for (var value in row.values) {
      if (value != null) {
        stringRow.add('$value');
      } else {
        stringRow.add('');
      }
    }
    rows.add(stringRow);
  }

  String csv = ListToCsvConverter(fieldDelimiter: delimiter).convert([...rows]);

  if (kIsWeb) {
    // Web: trigger download
    final bytes = utf8.encode(csv);
    final blob = fhtml.Blob([bytes]);
    final url = fhtml.Url.createObjectUrlFromBlob(blob);
    final anchor = fhtml.AnchorElement(href: url)
      ..setAttribute("download", fileName)
      ..click();
    fhtml.Url.revokeObjectUrl(url);
  } else {
    // Mobile/Desktop
    final dir = await getApplicationDocumentsDirectory();
    final path = '${dir.path}/$fileName';
    final file = File(path);
    await file.writeAsString(csv);
    print('CSV saved at: $path');
  }
}

String decodeBase64(String data) {
  int missingPadding = data.length % 4;
  if (missingPadding != 0) {
    data += '=' * (4 - missingPadding);
  }
  return utf8.decode(base64.decode(data));
}

bool checkForJson(String str) {
  try {
    jsonDecode(str);
    return true;
  } catch (e) {
    return false;
  }
}

String validateAndConvertDateToDbFormat(String data, int rowNo, String header) {
  List<String> dateKeyWords = ["Dt", "poDate", "shipBDt", "transDate", "valueDate", "tdate", "billDate", "dcgrDate", "transDocDate", "grDate", "docdate", "ackdate", "refDate"];
  if (dateKeyWords.contains(header)) {
    try {
      final date = DateFormat('dd-MM-yyyy').parseStrict(data);
      return DateFormat('MM-dd-yyyy').format(date);
    } catch (e) {
      throw FormatException('Invalid Date Format. Expected DD-MM-YYYY\nRow No: ${rowNo+1} | Column: $header');
    }
  }
  return data;
}
