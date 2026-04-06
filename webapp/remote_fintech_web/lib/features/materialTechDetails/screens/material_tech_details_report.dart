import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../common/widgets/comman_appbar.dart';
import '../../network/service/network_service.dart';
import '../provider/material_tech_details_provider.dart';

class MaterialTechDetailsReport extends StatefulWidget {
  static const String routeName = "MaterialTechDetailsReport";

  const MaterialTechDetailsReport({super.key});

  @override
  State<MaterialTechDetailsReport> createState() =>
      _MaterialTechDetailsReportState();
}

class _MaterialTechDetailsReportState extends State<MaterialTechDetailsReport> {
  @override
  void initState() {
    super.initState();
    MaterialTechDetailsProvider provider =
        Provider.of<MaterialTechDetailsProvider>(context, listen: false);
    provider.getMaterialTechDetailReport();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MaterialTechDetailsProvider>(
        builder: (context, provider, child) {
      return Material(
        child: SafeArea(
            child: Scaffold(
          appBar: PreferredSize(
              preferredSize:
                  Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
              child: const CommonAppbar(title: 'Material Tech Details Report')),
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Visibility(
                  visible: provider.repTechDetails.isNotEmpty,
                  child: DataTable(
                    columnSpacing: 30,
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
                    ],
                    rows: provider.repTechDetails.map((data) {
                      return DataRow(cells: [
                        DataCell(Text('${data['matno']}')),
                        DataCell(Visibility(
                          visible:
                              data['drawing'] != null && data['drawing'] != "",
                          child: InkWell(
                            child: const Icon(
                              Icons.file_present_outlined,
                              color: Colors.green,
                            ),
                            onTap: () async {
                              final Uri uri = Uri.parse(
                                  "${NetworkService.baseUrl}${data['drawing']}");
                              if (await canLaunchUrl(uri)) {
                                await launchUrl(uri,
                                    mode: LaunchMode.inAppBrowserView);
                              } else {
                                throw 'Could not launch';
                              }
                            },
                          ),
                        )),
                        DataCell(Visibility(
                          visible:
                              data['images'] != null && data['images'] != "",
                          child: InkWell(
                            child: const Icon(
                              Icons.file_present_outlined,
                              color: Colors.green,
                            ),
                            onTap: () async {
                              final Uri uri = Uri.parse(
                                  "${NetworkService.baseUrl}${data['images']}");
                              if (await canLaunchUrl(uri)) {
                                await launchUrl(uri,
                                    mode: LaunchMode.inAppBrowserView);
                              } else {
                                throw 'Could not launch';
                              }
                            },
                          ),
                        )),
                        DataCell(Visibility(
                          visible: data['asdrawing'] != null &&
                              data['asdrawing'] != "",
                          child: InkWell(
                            child: const Icon(
                              Icons.file_present_outlined,
                              color: Colors.green,
                            ),
                            onTap: () async {
                              final Uri uri = Uri.parse(
                                  "${NetworkService.baseUrl}${data['asdrawing']}");
                              if (await canLaunchUrl(uri)) {
                                await launchUrl(uri,
                                    mode: LaunchMode.inAppBrowserView);
                              } else {
                                throw 'Could not launch';
                              }
                            },
                          ),
                        )),
                        DataCell(Visibility(
                          visible: data['qcformat'] != null &&
                              data['qcformat'] != "",
                          child: InkWell(
                            child: const Icon(
                              Icons.file_present_outlined,
                              color: Colors.green,
                            ),
                            onTap: () async {
                              final Uri uri = Uri.parse(
                                  "${NetworkService.baseUrl}${data['qcformat']}");
                              if (await canLaunchUrl(uri)) {
                                await launchUrl(uri,
                                    mode: LaunchMode.inAppBrowserView);
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
                              final Uri uri = Uri.parse(
                                  "${NetworkService.baseUrl}${data['cp']}");
                              if (await canLaunchUrl(uri)) {
                                await launchUrl(uri,
                                    mode: LaunchMode.inAppBrowserView);
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
                              final Uri uri = Uri.parse(
                                  "${NetworkService.baseUrl}${data['fmea']}");
                              if (await canLaunchUrl(uri)) {
                                await launchUrl(uri,
                                    mode: LaunchMode.inAppBrowserView);
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
                              final Uri uri = Uri.parse(
                                  "${NetworkService.baseUrl}${data['pfd']}");
                              if (await canLaunchUrl(uri)) {
                                await launchUrl(uri,
                                    mode: LaunchMode.inAppBrowserView);
                              } else {
                                throw 'Could not launch';
                              }
                            },
                          ),
                        )),
                        DataCell(Visibility(
                          visible: data['ccr'] != null &&
                              data['ccr'] != "",
                          child: InkWell(
                            child: const Icon(
                              Icons.file_present_outlined,
                              color: Colors.green,
                            ),
                            onTap: () async {
                              final Uri uri = Uri.parse(
                                  "${NetworkService.baseUrl}${data['ccr']}");
                              if (await canLaunchUrl(uri)) {
                                await launchUrl(uri,
                                    mode: LaunchMode.inAppBrowserView);
                              } else {
                                throw 'Could not launch';
                              }
                            },
                          ),
                        )),
                        DataCell(Visibility(
                          visible: data['vendrawing'] != null &&
                              data['vendrawing'] != "",
                          child: InkWell(
                            child: const Icon(
                              Icons.file_present_outlined,
                              color: Colors.green,
                            ),
                            onTap: () async {
                              final Uri uri = Uri.parse(
                                  "${NetworkService.baseUrl}${data['vendrawing']}");
                              if (await canLaunchUrl(uri)) {
                                await launchUrl(uri,
                                    mode: LaunchMode.inAppBrowserView);
                              } else {
                                throw 'Could not launch';
                              }
                            },
                          ),
                        )),
                      ]);
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),
        )),
      );
    });
  }
}
