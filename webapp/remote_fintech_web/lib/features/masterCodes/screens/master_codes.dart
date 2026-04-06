import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:flutter/material.dart';

import '../../common/widgets/comman_appbar.dart';
import 'package:provider/provider.dart';
import 'package:hexcolor/hexcolor.dart';

import '../provider/master_provider.dart';

class MasterCodes extends StatefulWidget {
  static String routeName = "/masterCodes";
  const MasterCodes({super.key});

  @override
  State<MasterCodes> createState() => _MasterCodesState();
}

class _MasterCodesState extends State<MasterCodes>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  late MasterProvider provider;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 4, vsync: this);
    provider = Provider.of<MasterProvider>(context, listen: false);
    provider.init();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize:
              Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
          child: const CommonAppbar(title: 'Master Code')),
      body: Column(
        children: [
          TabBar(
              controller: tabController,
              labelColor: Colors.blue,
              unselectedLabelColor: Colors.black,
              indicatorSize: TabBarIndicatorSize.tab,
              tabs: const [
                Tab(text: 'State Codes'),
                Tab(text: 'Hsn Codes'),
                Tab(text: 'Country Codes'),
                Tab(text: 'Tax Rates'),
              ]),
          Expanded(
            child: TabBarView(controller: tabController, children: [
              // STATES
              Align(
                alignment: Alignment.topCenter,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Visibility(
                      visible: provider.states.isNotEmpty,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        child: DataTable(
                          border: TableBorder.all(color: HexColor("#dee2e6")),
                          columns: [
                            const DataColumn(
                                label: Text("State Code",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(
                                label: SizedBox(
                              width: GlobalVariables.deviceWidth * 0.35,
                              child: const Text("State Name",
                                  style: TextStyle(fontWeight: FontWeight.bold)),
                            ))
                          ],
                          rows: List<DataRow>.generate(
                            provider.states.length,
                            (index) => DataRow(
                              color: WidgetStateProperty.resolveWith<Color?>(
                                (Set<WidgetState> states) {
                                  // Alternate row color
                                  return index % 2 == 0
                                      ? HexColor("#f2f2f2")
                                      : null;
                                },
                              ),
                              cells: [
                                DataCell(Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                        '${provider.states[index]['Stcd'] ?? "-"}'))),
                                DataCell(Text(
                                    '${provider.states[index]['sname'] ?? "-"}'))
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // HSN CODES
              Align(
                alignment: Alignment.topCenter,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Visibility(
                      visible: provider.hsnCodes.isNotEmpty,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        child: DataTable(
                          border: TableBorder.all(color: HexColor("#dee2e6")),
                          columns: [
                            const DataColumn(
                                label: Text("HSN Code",
                                    style:
                                    TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(
                                label: SizedBox(
                                  width: GlobalVariables.deviceWidth * 0.35,
                                  child: const Text("HSN Description",
                                      style: TextStyle(fontWeight: FontWeight.bold)),
                                ))
                          ],
                          rows: List<DataRow>.generate(
                            provider.hsnCodes.length,
                                (index) => DataRow(
                              color: WidgetStateProperty.resolveWith<Color?>(
                                    (Set<WidgetState> states) {
                                  // Alternate row color
                                  return index % 2 == 0
                                      ? HexColor("#f2f2f2")
                                      : null;
                                },
                              ),
                              cells: [
                                DataCell(Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                        '${provider.hsnCodes[index]['hsnCode'] ?? "-"}'))),
                                DataCell(Text(
                                    '${provider.hsnCodes[index]['hsnShortDescription'] ?? "-"}'))
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Countries
              Align(
                alignment: Alignment.topCenter,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Visibility(
                      visible: provider.country.isNotEmpty,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        child: DataTable(
                          border: TableBorder.all(color: HexColor("#dee2e6")),
                          columns: [
                            const DataColumn(
                                label: Text("Country Code",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(
                                label: SizedBox(
                              width: GlobalVariables.deviceWidth * 0.35,
                              child: const Text("Country Name",
                                  style: TextStyle(fontWeight: FontWeight.bold)),
                            ))
                          ],
                          rows: List<DataRow>.generate(
                            provider.country.length,
                            (index) => DataRow(
                              color: WidgetStateProperty.resolveWith<Color?>(
                                (Set<WidgetState> states) {
                                  // Alternate row color
                                  return index % 2 == 0
                                      ? HexColor("#f6f6f6")
                                      : null;
                                },
                              ),
                              cells: [
                                DataCell(Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                        '${provider.country[index]['cid'] ?? "-"}'))),
                                DataCell(Text(
                                    '${provider.country[index]['cname'] ?? "-"}'))
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // GST Tax Rates
              Align(
                alignment: Alignment.topCenter,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Visibility(
                      visible: provider.gstTaxRates.isNotEmpty,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        child: DataTable(
                          border: TableBorder.all(color: HexColor("#dee2e6")),
                          columns: [
                            DataColumn(
                                label: SizedBox(
                              width: GlobalVariables.deviceWidth * 0.25,
                              child: const Text("GST Tax Rates",
                                  style: TextStyle(fontWeight: FontWeight.bold)),
                            ))
                          ],
                          rows: List<DataRow>.generate(
                            provider.gstTaxRates.length,
                            (index) => DataRow(
                              color: WidgetStateProperty.resolveWith<Color?>(
                                (Set<WidgetState> states) {
                                  // Alternate row color
                                  return index % 2 == 0
                                      ? HexColor("#f2f2f2")
                                      : null;
                                },
                              ),
                              cells: [
                                DataCell(Text(
                                    '${provider.gstTaxRates[index]['rgst'] ?? "-"}'))
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ]),
          )
        ],
      ),
    );
  }
}
