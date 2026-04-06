import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

import '../../utility/global_variables.dart';
import '../provider/sales_order_provider.dart';

class SaleOrderFormTab extends StatefulWidget {
  const SaleOrderFormTab({super.key});

  @override
  State<SaleOrderFormTab> createState() => _SaleOrderFormTabState();
}

class _SaleOrderFormTabState extends State<SaleOrderFormTab> with AutomaticKeepAliveClientMixin{
  var formKey = GlobalKey<FormState>();

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<SalesOrderProvider>(builder: (context, provider, child) {
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
                          // if (formKey.currentState!.validate()) {
                          //   tabController.animateTo(1);
                          // }
                        },
                        child: const Text('Next ->',
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
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
