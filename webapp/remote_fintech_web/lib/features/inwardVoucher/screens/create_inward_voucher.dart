// ignore_for_file: use_build_context_synchronously
import 'dart:convert';
import 'dart:io';

import 'package:fintech_new_web/features/common/widgets/pop_ups.dart';
import 'package:fintech_new_web/features/inwardVoucher/provider/inward_voucher_provider.dart';
import 'package:fintech_new_web/features/inwardVoucher/screens/inward_voucher.dart';
import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:excel/excel.dart' as exc;
import 'package:url_launcher/url_launcher.dart';

import '../../camera/widgets/camera_widget.dart';
import '../../common/widgets/comman_appbar.dart';
import '../../utility/services/import_widget.dart';
import 'inward_voucher_row_fields.dart';

class CreateInwardVoucher extends StatefulWidget {
  static String routeName = "/createInwardVoucher";
  final String? editing;
  const CreateInwardVoucher({super.key, this.editing});

  @override
  State<CreateInwardVoucher> createState() => _CreateInwardVoucherState();
}

class _CreateInwardVoucherState extends State<CreateInwardVoucher>
    with SingleTickerProviderStateMixin {
  List<List<String>> tableRows = [];
  var formKey = GlobalKey<FormState>();
  late TabController tabController;
  late InwardVoucherProvider provider;

  bool manualOrder = true;
  bool autoOrder = false;
  bool isFileUploaded = false;

  @override
  void initState() {
    super.initState();
    provider = Provider.of<InwardVoucherProvider>(context, listen: false);
    if (widget.editing == "true") {
      provider.initEditWidget();
    } else {
      provider.initWidget();
    }
    tableRows.add([
      '',
      '',
      '',
      '',
      '',
      '0',
      'N',
      '0',
      '0',
      '0',
      '0',
      '0',
      '0',
      '0',
      '0',
      '0',
      '0'
    ]);
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  // Function to add a new row
  void addRow() {
    setState(() {
      tableRows.add([
        '',
        '',
        '',
        '',
        '',
        '0',
        'N',
        '0',
        '0',
        '0',
        '0',
        '0',
        '0',
        '0',
        '0',
        '0',
        '0'
      ]);
    });
    provider.addRowController();
  }

  // Function to delete a row
  void deleteRow(int index) {
    setState(() {
      tableRows.removeAt(index);
    });
    provider.deleteRowController(index);
  }

  @override
  Widget build(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    return Consumer<InwardVoucherProvider>(builder: (context, provider, child) {
      return Scaffold(
        appBar: PreferredSize(
            preferredSize:
                Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
            child: const CommonAppbar(title: 'Inward Voucher')),
        body: Center(
          child: Column(
            children: [
              TabBar(
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  unselectedLabelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                  physics: const NeverScrollableScrollPhysics(),
                  controller: tabController,
                  isScrollable: false,
                  tabs: const [
                    Tab(text: "Fixed / Master"),
                    Tab(text: "Item Detail"),
                  ]),
              Expanded(
                  child: TabBarView(
                      physics: const NeverScrollableScrollPhysics(),
                      controller: tabController,
                      children: [
                        InwardVoucher(controller: tabController),
                        SingleChildScrollView(
                          child: Center(
                            child: SizedBox(
                              width: kIsWeb
                                  ? GlobalVariables.deviceWidth / 2
                                  : GlobalVariables.deviceWidth,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8, left: 10),
                                    child: ImportWidget(
                                        toggleManual: () {
                                          setState(() {
                                            manualOrder = false;
                                            autoOrder = true;
                                          });
                                        },
                                        toggleAuto: () {
                                          setState(() {
                                            manualOrder = true;
                                            autoOrder = false;
                                            isFileUploaded = false;
                                          });
                                        },
                                        feature: InwardVoucherProvider.featureName,
                                        sampleFileUrl: "https://docs.google.com/spreadsheets/d/1ieMXeai9GdBJO0KnKRSQJTYbyDI0PSgRVF20KEzYKug/edit?usp=sharing",
                                        isMaster: false,
                                        groupBy: "id",
                                        masterDetailFeatureName: InwardVoucherProvider.masterDetailFeatureName,
                                        manualOrder: manualOrder,
                                        autoOrder: autoOrder,
                                        isFileUploaded: isFileUploaded),
                                  ),
                                  const SizedBox(height: 10),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8, left: 10),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: HexColor("#0B6EFE"),
                                          minimumSize: const Size(200, 50),
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(1)))),
                                      onPressed: () async {
                                        {
                                          http.StreamedResponse result =
                                          await provider.processFormInfo(tableRows, manualOrder);
                                          var message =
                                          jsonDecode(await result.stream.bytesToString());
                                          if (result.statusCode == 200) {
                                            context.pushReplacementNamed(CreateInwardVoucher.routeName);
                                          } else if (result.statusCode == 400) {
                                            await showAlertDialog(context,
                                                message['message'].toString(), "Continue", false);
                                          } else if (result.statusCode == 500) {
                                            await showAlertDialog(
                                                context, message['message'], "Continue", false);
                                          } else {
                                            await showAlertDialog(
                                                context, message['message'], "Continue", false);
                                          }
                                        }
                                      },
                                      child: const Text(
                                        'Submit',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  for (int i = 0; i < tableRows.length; i++)
                                    Visibility(
                                      visible: manualOrder,
                                      child: InwardVoucherRowFields(
                                          hsnCodes: provider.hsnCodes,
                                          units: provider.units,
                                          index: i,
                                          tableRows: tableRows,
                                          deleteRow: deleteRow, controllers: provider.rowControllers),
                                    ),
                                  const SizedBox(height:10),
                                  Visibility(
                                    visible: manualOrder,
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 8, left: 10),
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: HexColor("#0B6EFE"),
                                            minimumSize: const Size(200,50),
                                            shape: const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(1)))),
                                        onPressed: addRow,
                                        child: const Text('Add Row',
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.white)),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ]))
            ],
          ),
        ),
      );
    });
  }
}
