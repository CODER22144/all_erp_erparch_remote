import 'package:fintech_new_web/features/carrier/provider/carrier_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/widgets/comman_appbar.dart';

class CarrierReport extends StatefulWidget {
  static String routeName = "CarrierReport";

  const CarrierReport({super.key});

  @override
  State<CarrierReport> createState() => _CarrierReportState();
}

class _CarrierReportState extends State<CarrierReport> {
  @override
  void initState() {
    super.initState();
    CarrierProvider provider =
    Provider.of<CarrierProvider>(context, listen: false);
    provider.getAllCarriers();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CarrierProvider>(builder: (context, provider, child) {
      return Material(
        child: SafeArea(
            child: Scaffold(
              appBar: PreferredSize(
                  preferredSize:
                  Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
                  child: const CommonAppbar(title: 'Carrier Report')),
              body: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text("ID")),
                        DataColumn(label: Text("Carrier Name")),
                        DataColumn(label: Text("GSTIN")),
                        DataColumn(label: Text("Address")),
                        DataColumn(label: Text("City")),
                        DataColumn(label: Text("State")),
                        DataColumn(label: Text("Zipcode")),
                        DataColumn(label: Text("Contact Person")),
                        DataColumn(label: Text("Phone")),
                      ],
                      rows: provider.carriers.map((data) {
                        return DataRow(cells: [
                          DataCell(Text('${data['carId'] ?? "-"}')),
                          DataCell(Text('${data['carName'] ?? "-"}')),
                          DataCell(Text('${data['carGSTIN'] ?? "-"}')),
                          DataCell(Text('${data['carAdd'] ?? "-"} ${data['carAdd1'] ?? ""}')),
                          DataCell(Text('${data['carCity'] ?? "-"}')),
                          DataCell(Text('${data['carStateName'] ?? "-"}')),
                          DataCell(Text('${data['carZipCode'] ?? "-"}')),
                          DataCell(Text('${data['carCPerson'] ?? "-"}')),
                          DataCell(Text('${data['carPhone'] ?? "-"}')),

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
