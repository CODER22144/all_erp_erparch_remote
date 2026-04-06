import 'dart:convert';

import 'package:fintech_new_web/features/materialTechDetails/provider/material_tech_details_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:go_router/go_router.dart';

import '../../common/widgets/comman_appbar.dart';
import '../../network/service/network_service.dart';
import '../../utility/global_variables.dart';

class DeleteMaterialTechDetails extends StatefulWidget {
  static String routeName = 'DeleteMaterialTechDetails';
  const DeleteMaterialTechDetails({super.key});

  @override
  State<DeleteMaterialTechDetails> createState() =>
      _DeleteMaterialTechDetailsState();
}

class _DeleteMaterialTechDetailsState extends State<DeleteMaterialTechDetails> {
  TextEditingController matController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<MaterialTechDetailsProvider>(
        builder: (context, provider, child) {
      return Scaffold(
        appBar: PreferredSize(
            preferredSize:
                Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
            child: const CommonAppbar(title: 'Delete Material Tech Details')),
        body: SingleChildScrollView(
          child: Center(
            child: Container(
              width: kIsWeb
                  ? GlobalVariables.deviceWidth / 2.0
                  : GlobalVariables.deviceWidth,
              padding: const EdgeInsets.all(10),
              child: Form(
                // key: formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: TextFormField(
                        style:
                            const TextStyle(color: Colors.black, fontSize: 14),
                        readOnly: false,
                        controller: matController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          border: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black)),
                          focusedBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey, width: 2),
                          ),
                          label: RichText(
                            text: const TextSpan(
                              text: "Material No.",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                fontWeight: FontWeight.w300,
                              ),
                              children: [
                                TextSpan(
                                    text: "*",
                                    style: TextStyle(color: Colors.red))
                              ],
                            ),
                          ),
                        ),
                        validator: (String? val) {
                          if ((val == null || val.isEmpty)) {
                            return 'This field is Mandatory';
                          }
                        },
                        maxLines: 1,
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 10),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: HexColor("#0B6EFE"),
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)))),
                        onPressed: () async {
                          NetworkService networkService = NetworkService();
                          http.StreamedResponse response = await networkService
                              .post("/get-material-tech-details/",
                                  {"matno": matController.text});
                          if (response.statusCode == 200) {
                            materialTechDetailsTable(
                                context,
                                jsonDecode(
                                    await response.stream.bytesToString()));
                          }
                        },
                        child: const Text(
                          'Submit',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  void materialTechDetailsTable(
      BuildContext context, List<dynamic> materialDetails) {
    List<DataRow> rows = [];
    for (var data in materialDetails) {
      rows.add(DataRow(cells: [
        DataCell(Text('${data['matno'] ?? "-"}')),
        DataCell(Visibility(
          visible: data['drawing'] != null && data['drawing'] != "",
          child: InkWell(
            child: const Icon(
              Icons.file_present_outlined,
              color: Colors.green,
            ),
            onTap: () async {
              final Uri uri =
                  Uri.parse("${NetworkService.baseUrl}${data['drawing']}");
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
              } else {
                throw 'Could not launch';
              }
            },
          ),
        )),
        DataCell(Visibility(
          visible: data['images'] != null && data['images'] != "",
          child: InkWell(
            child: const Icon(
              Icons.file_present_outlined,
              color: Colors.green,
            ),
            onTap: () async {
              final Uri uri =
                  Uri.parse("${NetworkService.baseUrl}${data['images']}");
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
              } else {
                throw 'Could not launch';
              }
            },
          ),
        )),
        DataCell(Visibility(
          visible: data['asdrawing'] != null && data['asdrawing'] != "",
          child: InkWell(
            child: const Icon(
              Icons.file_present_outlined,
              color: Colors.green,
            ),
            onTap: () async {
              final Uri uri =
                  Uri.parse("${NetworkService.baseUrl}${data['asdrawing']}");
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
              } else {
                throw 'Could not launch';
              }
            },
          ),
        )),
        DataCell(Visibility(
          visible: data['qcformat'] != null && data['qcformat'] != "",
          child: InkWell(
            child: const Icon(
              Icons.file_present_outlined,
              color: Colors.green,
            ),
            onTap: () async {
              final Uri uri =
                  Uri.parse("${NetworkService.baseUrl}${data['qcformat']}");
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
              } else {
                throw 'Could not launch';
              }
            },
          ),
        )),
        DataCell(Visibility(
          visible: data['cp'] != null && data['cp'] != "",
          child: InkWell(
            child: const Icon(
              Icons.file_present_outlined,
              color: Colors.green,
            ),
            onTap: () async {
              final Uri uri =
                  Uri.parse("${NetworkService.baseUrl}${data['cp']}");
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
              } else {
                throw 'Could not launch';
              }
            },
          ),
        )),
        DataCell(Visibility(
          visible: data['fmea'] != null && data['fmea'] != "",
          child: InkWell(
            child: const Icon(
              Icons.file_present_outlined,
              color: Colors.green,
            ),
            onTap: () async {
              final Uri uri =
                  Uri.parse("${NetworkService.baseUrl}${data['fmea']}");
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
              } else {
                throw 'Could not launch';
              }
            },
          ),
        )),
        DataCell(Visibility(
          visible: data['pfd'] != null && data['pfd'] != "",
          child: InkWell(
            child: const Icon(
              Icons.file_present_outlined,
              color: Colors.green,
            ),
            onTap: () async {
              final Uri uri =
                  Uri.parse("${NetworkService.baseUrl}${data['pfd']}");
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
              } else {
                throw 'Could not launch';
              }
            },
          ),
        )),
        DataCell(Visibility(
          visible: data['ccr'] != null && data['ccr'] != "",
          child: InkWell(
            child: const Icon(
              Icons.file_present_outlined,
              color: Colors.green,
            ),
            onTap: () async {
              final Uri uri =
              Uri.parse("${NetworkService.baseUrl}${data['ccr']}");
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
              } else {
                throw 'Could not launch';
              }
            },
          ),
        )),
        DataCell(Visibility(
          visible: data['vendrawing'] != null && data['vendrawing'] != "",
          child: InkWell(
            child: const Icon(
              Icons.file_present_outlined,
              color: Colors.green,
            ),
            onTap: () async {
              final Uri uri =
                  Uri.parse("${NetworkService.baseUrl}${data['vendrawing']}");
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
              } else {
                throw 'Could not launch';
              }
            },
          ),
        )),
        DataCell(ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5)))),
          onPressed: () async {
            NetworkService networkService = NetworkService();
            http.StreamedResponse response = await networkService.post(
                "/delete-material-tech-details/",
                {"matno": matController.text});
            if (response.statusCode == 200) {
              context.pop();
            }
          },
          child: const Text(
            'Delete',
            style: TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ))
      ]));
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Material Tech Details',
              style: TextStyle(fontWeight: FontWeight.w500)),
          content: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DataTable(
                    columnSpacing: 25,
                    columns: const [
                      DataColumn(label: Text('Material no.')),
                      DataColumn(label: Text('Drawing')),
                      DataColumn(label: Text('Images')),
                      DataColumn(label: Text('AsDrawing')),
                      DataColumn(label: Text('QC Format')),
                      DataColumn(label: Text('CP')),
                      DataColumn(label: Text('FMEA')),
                      DataColumn(label: Text('PFD')),
                      DataColumn(label: Text('CCR')),
                      DataColumn(label: Text('Venn Drawing')),
                      DataColumn(label: Text('')),
                    ],
                    rows: rows,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    // Navigator.pop(context, false);
                    Navigator.of(context, rootNavigator: true).pop(false);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 5),
                    width: GlobalVariables.deviceWidth * 0.15,
                    height: GlobalVariables.deviceHeight * 0.05,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.grey,
                          blurRadius: 2,
                          offset: Offset(
                            2,
                            3,
                          ),
                        )
                      ],
                    ),
                    child: const Text("CLOSE",
                        style: TextStyle(fontSize: 11, color: Colors.black)),
                  ),
                ),
              ],
            )
          ],
        );
      },
    );
  }
}
