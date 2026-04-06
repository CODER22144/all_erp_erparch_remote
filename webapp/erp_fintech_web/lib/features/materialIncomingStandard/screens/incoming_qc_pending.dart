import 'package:fintech_new_web/features/colorCode/provider/color_provider.dart';
import 'package:fintech_new_web/features/materialIncomingStandard/provider/material_incoming_standard_provider.dart';
import 'package:fintech_new_web/features/materialIncomingStandard/screens/incoming_standard_reading_post.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:go_router/go_router.dart';

import '../../common/widgets/comman_appbar.dart';
import '../../common/widgets/pop_ups.dart';
import '../../network/service/network_service.dart';

class IncomingQcPending extends StatefulWidget {
  static String routeName = "/incomingQcPending";

  const IncomingQcPending({super.key});

  @override
  State<IncomingQcPending> createState() => _IncomingQcPendingState();
}

class _IncomingQcPendingState extends State<IncomingQcPending> {
  @override
  void initState() {
    MaterialIncomingStandardProvider provider =
        Provider.of<MaterialIncomingStandardProvider>(context, listen: false);
    provider.getQcPending();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MaterialIncomingStandardProvider>(
        builder: (context, provider, child) {
      return Material(
        child: SafeArea(
            child: Scaffold(
          appBar: PreferredSize(
              preferredSize:
                  Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
              child: const CommonAppbar(title: 'Incoming QC Pending')),
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: provider.qcPending.isNotEmpty
                  ? DataTable(
                      columns: const [
                        DataColumn(label: Text("GR No.")),
                        DataColumn(label: Text("GR Date")),
                        DataColumn(label: Text("Partner Name")),
                        DataColumn(label: Text("City")),
                        DataColumn(label: Text("State")),
                        DataColumn(label: Text("Material no.")),
                        DataColumn(label: Text("Qty")),
                        DataColumn(label: Text("")),
                      ],
                      rows: provider.qcPending.map((data) {
                        return DataRow(cells: [
                          DataCell(Text('${data['grno'] ?? ""}')),
                          DataCell(Text('${data['grDate'] ?? ""}')),
                          DataCell(Text(
                              '${data['bpCode'] ?? ""} - ${data['bpName'] ?? ""}')),
                          DataCell(Text('${data['bpCity'] ?? ""}')),
                          DataCell(Text('${data['stateName'] ?? ""}')),
                          DataCell(Text('${data['matno'] ?? ""}')),
                          DataCell(Text('${data['grQty'] ?? ""}')),
                          DataCell(ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)))),
                            onPressed: () {
                              context.pushNamed(
                                  IncomingStandardReadingPost.routeName,
                                  queryParameters: {
                                    "matno": '${data['matno'] ?? ""}',
                                    "grdId" : '${data['grdId']}'
                                  });
                            },
                            child: const Text(
                              'Post',
                              style: TextStyle(
                                  fontSize: 16,
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
