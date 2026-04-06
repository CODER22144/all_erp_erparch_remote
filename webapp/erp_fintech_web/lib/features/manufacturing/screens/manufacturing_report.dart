import 'package:fintech_new_web/features/manufacturing/provider/manufacturing_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../../common/widgets/comman_appbar.dart';
import '../../common/widgets/pop_ups.dart';
import '../../network/service/network_service.dart';

class ManufacturingReport extends StatefulWidget {
  static String routeName = "ManufacturingReport";

  const ManufacturingReport({super.key});

  @override
  State<ManufacturingReport> createState() => _ManufacturingReportState();
}

class _ManufacturingReportState extends State<ManufacturingReport> {
  @override
  void initState() {
    super.initState();
    ManufacturingProvider provider =
    Provider.of<ManufacturingProvider>(context, listen: false);
    provider.getManufacturingReport();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ManufacturingProvider>(builder: (context, provider, child) {
      return Material(
        child: SafeArea(
            child: Scaffold(
              appBar: PreferredSize(
                  preferredSize:
                  Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
                  child: const CommonAppbar(title: 'Manufacturing Report')),
              body: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text("Tran Date")),
                        DataColumn(label: Text("Material no.")),
                        DataColumn(label: Text("Quantity")),
                        DataColumn(label: Text("")),
                      ],
                      rows: provider.manufacturingReport.map((data) {
                        return DataRow(cells: [
                          DataCell(Text('${data['dtDate'] ?? "-"}')),
                          DataCell(Text('${data['matno'] ?? "-"}')),
                          DataCell(Text('${data['qty'] ?? "-"}')),
                          DataCell(ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.redAccent,
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(5)))),
                            onPressed: () async {
                              bool confirmation =
                              await showConfirmationDialogue(
                                  context,
                                  "Do you want to Delete manufacturing : ${data['mId'] ?? "-"}?",
                                  "SUBMIT",
                                  "CANCEL");
                              if(confirmation) {
                                NetworkService networkService = NetworkService();
                                http.StreamedResponse response = await networkService.post("/delete-manufacturing/", {"mId" : '${data['mId'] ?? "-"}'});
                                if(response.statusCode == 204) {
                                  provider.getManufacturingReport();
                                }
                              }
                            },
                            child: const Text(
                              'Delete',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.white),
                            ),
                          )),
                        ]);
                      }).toList(),
                    ),
                  ),
                ),
              ),
            )),
      );
    });
  }
}
