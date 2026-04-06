import 'package:fintech_new_web/features/additionalOrder/provider/additional_order_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/widgets/comman_appbar.dart';

class AdditionalPurchaseOrderReport extends StatefulWidget {
  static String routeName = "AdditionalPurchaseOrderReport";

  const AdditionalPurchaseOrderReport({super.key});

  @override
  State<AdditionalPurchaseOrderReport> createState() =>
      _AdditionalPurchaseOrderReportState();
}

class _AdditionalPurchaseOrderReportState extends State<AdditionalPurchaseOrderReport> {
  @override
  void initState() {
    super.initState();
    AdditionalOrderProvider provider =
    Provider.of<AdditionalOrderProvider>(context, listen: false);
    provider.nestedTable();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AdditionalOrderProvider>(builder: (context, provider, child) {
      return Material(
        child: SafeArea(
            child: Scaffold(
              appBar: PreferredSize(
                  preferredSize:
                  Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
                  child: const CommonAppbar(title: 'Additional Purchase Order Report')),
              body: Center(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal, child:provider.table),
                ),
              ),
            )),
      );
    });
  }
}
