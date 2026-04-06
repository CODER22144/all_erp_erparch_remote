import 'package:fintech_new_web/features/colorCode/provider/color_provider.dart';
import 'package:fintech_new_web/features/materialClassification/provider/material_classification_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../../common/widgets/comman_appbar.dart';
import '../../common/widgets/pop_ups.dart';
import '../../network/service/network_service.dart';

class MaterialClassificationReport extends StatefulWidget {
  static String routeName = "MaterialClassificationReport";

  const MaterialClassificationReport({super.key});

  @override
  State<MaterialClassificationReport> createState() =>
      _MaterialClassificationReportState();
}

class _MaterialClassificationReportState
    extends State<MaterialClassificationReport> {
  @override
  void initState() {
    MaterialClassificationProvider provider =
        Provider.of<MaterialClassificationProvider>(context, listen: false);
    provider.getMaterialClassificationReport();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MaterialClassificationProvider>(
        builder: (context, provider, child) {
      return Material(
        child: SafeArea(
            child: Scaffold(
          appBar: PreferredSize(
              preferredSize:
                  Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
              child:
                  const CommonAppbar(title: 'Material Classification Report')),
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: provider.matClassificationRep.isNotEmpty
                  ? DataTable(
                      columns: const [
                        DataColumn(label: Text("Material No.")),
                        DataColumn(label: Text("Brand")),
                        DataColumn(label: Text("Department")),
                        DataColumn(label: Text("Product Segment")),
                        DataColumn(label: Text("Category")),
                        DataColumn(label: Text("Sub category")),
                        DataColumn(label: Text("Product Group")),
                        // DataColumn(label: Text("")),
                      ],
                      rows: provider.matClassificationRep.map((data) {
                        return DataRow(cells: [
                          DataCell(Text('${data['matno'] ?? "-"}')),
                          DataCell(Text('${data['brandId'] ?? "-"}')),
                          DataCell(Text('${data['departmentId'] ?? "-"}')),
                          DataCell(Text('${data['psid'] ?? "-"}')),
                          DataCell(Text('${data['categoryId'] ?? "-"}')),
                          DataCell(Text('${data['subCategoryId'] ?? "-"}')),
                          DataCell(Text('${data['pgId'] ?? "-"}')),
                          // DataCell(ElevatedButton(
                          //   style: ElevatedButton.styleFrom(
                          //       backgroundColor: Colors.redAccent,
                          //       shape: const RoundedRectangleBorder(
                          //           borderRadius:
                          //               BorderRadius.all(Radius.circular(5)))),
                          //   onPressed: () async {
                          //     bool confirmation = await showConfirmationDialogue(
                          //         context,
                          //         "Do you want delete colour: ${data['colNo']}?",
                          //         "SUBMIT",
                          //         "CANCEL");
                          //     if (confirmation) {
                          //       NetworkService networkService =
                          //           NetworkService();
                          //       http.StreamedResponse response =
                          //           await networkService.post("/delete-color/",
                          //               {"colNo": '${data['colNo'] ?? "-"}'});
                          //       if (response.statusCode == 204) {
                          //         provider.getMaterialClassificationReport();
                          //       }
                          //     }
                          //   },
                          //   child: const Text(
                          //     'Delete',
                          //     style: TextStyle(
                          //         fontSize: 16,
                          //         fontWeight: FontWeight.w300,
                          //         color: Colors.white),
                          //   ),
                          // )),
                        ]);
                      }).toList(),
                    )
                  : const SizedBox(),
            ),
          ),
        )),
      );
    });
  }
}
