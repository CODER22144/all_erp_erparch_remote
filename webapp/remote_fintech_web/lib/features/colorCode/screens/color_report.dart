import 'package:fintech_new_web/features/colorCode/provider/color_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../../common/widgets/comman_appbar.dart';
import '../../common/widgets/pop_ups.dart';
import '../../network/service/network_service.dart';

class ColorReport extends StatefulWidget {
  static String routeName = "ColorReport";

  const ColorReport({super.key});

  @override
  State<ColorReport> createState() => _ColorReportState();
}

class _ColorReportState extends State<ColorReport> {
  @override
  void initState() {
    ColorProvider provider = Provider.of<ColorProvider>(context, listen: false);
    provider.getColorReport();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ColorProvider>(builder: (context, provider, child) {
      return Material(
        child: SafeArea(
            child: Scaffold(
          appBar: PreferredSize(
              preferredSize:
                  Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
              child: const CommonAppbar(title: 'Color Report')),
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: provider.colorReport.isNotEmpty
                  ? DataTable(
                      columns: const [
                        DataColumn(label: Text("Colour Code")),
                        DataColumn(label: Text("Colour Name")),
                        DataColumn(label: Text("")),
                      ],
                      rows: provider.colorReport.map((data) {
                        return DataRow(cells: [
                          DataCell(Text('${data['colNo'] ?? "-"}')),
                          DataCell(Text('${data['colName'] ?? "-"}')),
                          DataCell(ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.redAccent,
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)))),
                            onPressed: () async {
                              bool confirmation = await showConfirmationDialogue(
                                  context,
                                  "Do you want delete colour: ${data['colNo']}?",
                                  "SUBMIT",
                                  "CANCEL");
                              if (confirmation) {
                                NetworkService networkService =
                                    NetworkService();
                                http.StreamedResponse response =
                                    await networkService.post("/delete-color/",
                                        {"colNo": '${data['colNo'] ?? "-"}'});
                                if (response.statusCode == 204) {
                                  provider.getColorReport();
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
                    )
                  : const SizedBox(),
            ),
          ),
        )),
      );
    });
  }
}
