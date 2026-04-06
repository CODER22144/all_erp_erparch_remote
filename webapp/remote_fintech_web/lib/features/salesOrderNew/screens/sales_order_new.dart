import 'package:fintech_new_web/features/salesOrderNew/provider/sales_order_new_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

import '../../utility/global_variables.dart';

class SalesOrderNew extends StatefulWidget {
  final TabController controller;
  const SalesOrderNew({super.key, required this.controller});

  @override
  State<SalesOrderNew> createState() => _SalesOrderNewState();
}

class _SalesOrderNewState extends State<SalesOrderNew>
    with AutomaticKeepAliveClientMixin {
  var formKey = GlobalKey<FormState>();

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<SalesOrderNewProvider>(
        builder: (context, provider, child) {
          return SingleChildScrollView(
            child: Center(
              child: Container(
                width: kIsWeb
                    ? GlobalVariables.deviceWidth / 2
                    : GlobalVariables.deviceWidth,
                padding: const EdgeInsets.all(10),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 5, bottom: 5),
                        child: ListView.builder(
                          itemCount: provider.widgetList.length,
                          physics: const ClampingScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return provider.widgetList[index];
                          },
                        ),
                      ),
                      Visibility(
                        visible: provider.widgetList.isNotEmpty,
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: HexColor("#1abc9c"),
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(5)))),
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                widget.controller.animateTo(1);
                              }
                            },
                            child: const Text('Next ->',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
