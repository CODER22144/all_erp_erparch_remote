import 'package:fintech_new_web/features/partAssembly/provider/part_assembly_provider.dart';
import 'package:fintech_new_web/features/partAssembly/screens/not_in_bill_of_material_report.dart';
import 'package:fintech_new_web/features/partAssembly/screens/part_search_report.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:searchable_paginated_dropdown/searchable_paginated_dropdown.dart';

import '../../common/widgets/comman_appbar.dart';
import '../../utility/global_variables.dart';

class NotInBillOfMaterial extends StatefulWidget {
  static String routeName = 'NotInBillOfMaterial';
  const NotInBillOfMaterial({super.key});

  @override
  State<NotInBillOfMaterial> createState() => _NotInBillOfMaterialState();
}

class _NotInBillOfMaterialState extends State<NotInBillOfMaterial> {

  late PartAssemblyProvider provider;
  @override
  void initState() {
    super.initState();
    provider = Provider.of<PartAssemblyProvider>(context, listen: false);
    provider.getRmType();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PartAssemblyProvider>(
        builder: (context, provider, child) {
          return Scaffold(
            appBar: PreferredSize(
                preferredSize:
                Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
                child: const CommonAppbar(title: 'Not-In Bill Of Material')),
            body: SingleChildScrollView(
              child: Center(
                child: Container(
                  width: kIsWeb
                      ? GlobalVariables.deviceWidth / 2.0
                      : GlobalVariables.deviceWidth,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Form(
                    // key: formKey,
                    child: Column(
                      children: [
                        Visibility(
                          visible: provider.rmType.isNotEmpty,
                          child: Stack(
                            children: [

                              Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  child: SearchableDropdown<String>(
                                    isEnabled: true,
                                    backgroundDecoration: (child) => Container(
                                      height: 40,
                                      margin: EdgeInsets.zero,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(color: Colors.black, width: 0.5),
                                      ),
                                      child: child,
                                    ),
                                    items: provider.rmType,
                                    onChanged: (value) {
                                      setState(() {
                                        provider.rmTypeController.text = value!;
                                      });
                                    },
                                    hasTrailingClearIcon: false,
                                  )),
                              Positioned(
                                left: 15,
                                top: 1,
                                child: Container(
                                  color: Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 2),
                                  child: const Wrap(
                                    children: [
                                      Text(
                                        "Raw Material Type",
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        "*",
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
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
                              context.pushNamed(NotInBillOfMaterialReport.routeName);
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
}
