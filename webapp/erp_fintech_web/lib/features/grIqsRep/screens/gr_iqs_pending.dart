import 'package:fintech_new_web/features/grIqsRep/screens/add_gr_iqs_rep.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

import '../../common/widgets/comman_appbar.dart';
import '../provider/gr_iqs_rep_provider.dart';

class GrIqsPending extends StatefulWidget {
  static String routeName = "grIqsPending";

  const GrIqsPending({super.key});

  @override
  State<GrIqsPending> createState() => _GrIqsPendingState();
}

class _GrIqsPendingState extends State<GrIqsPending> {
  @override
  void initState() {
    GrIqsRepProvider provider =
    Provider.of<GrIqsRepProvider>(context, listen: false);
    provider.getGrIqsPending();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GrIqsRepProvider>(builder: (context, provider, child) {
      return Material(
        child: SafeArea(
            child: Scaffold(
              appBar: PreferredSize(
                  preferredSize:
                  Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
                  child: const CommonAppbar(title: 'Pending GR Iqs')),
              body: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text("GR No.")),
                      DataColumn(label: Text("GR Date")),
                      DataColumn(label: Text("Material No.")),
                      DataColumn(label: Text("Quantity")),
                      DataColumn(label: Text("Business Partner Name")),
                      DataColumn(label: Text("City")),
                      DataColumn(label: Text("State")),
                      DataColumn(label: Text("IQS Id")),
                      DataColumn(label: Text("Post IQS")),
                    ],
                    rows: provider.grIqsPending.map((data) {
                      return DataRow(cells: [
                        DataCell(Text('${data['grno'] ?? "-"}')),
                        DataCell(Text('${data['grDate'] ?? "-"}')),
                        DataCell(Text('${data['matno'] ?? "-"}')),
                        DataCell(Text('${data['grQty'] ?? "-"}')),
                        DataCell(Text('${data['bpName'] ?? "-"}')),
                        DataCell(Text('${data['bpCity'] ?? "-"}')),
                        DataCell(Text('${data['stateName'] ?? "-"}')),
                        DataCell(Text('${data['iqsid'] ?? "-"}')),
                        DataCell(ElevatedButton(
                            onPressed: () {
                              context.pushNamed(AddGrIqsRep.routeName);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: HexColor("#183D41"),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(1), // Square shape
                              ),
                              padding: EdgeInsets.zero,
                              // Remove internal padding to make it square
                              minimumSize: const Size(
                                  120, 50), // Width and height for the button
                            ),
                            child: const Text(
                              "Post GR Iqs",
                              style: TextStyle(color: Colors.white),
                            ))),
                      ]);
                    }).toList(),
                  ),
                ),
              ),
            )),
      );
    });
  }

  Future<bool> _showConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: Text('Are you sure you want to proceed?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(false); // Return false
              },
            ),
            TextButton(
              child: Text('Confirm'),
              onPressed: () {
                Navigator.of(context).pop(true); // Return true
              },
            ),
          ],
        );
      },
    ) ??
        false; // Return false if dialog is dismissed by other means
  }
}
