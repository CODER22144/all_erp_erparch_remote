import 'package:fintech_new_web/features/orderDelivery/provider/order_delivery_provider.dart';
import 'package:fintech_new_web/features/orderDelivery/screens/add_order_delivery.dart';
import 'package:fintech_new_web/features/purchaseOrder/provider/purchase_order_provider.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../../common/widgets/comman_appbar.dart';

class PurchaseOrderReportScreen extends StatefulWidget {
  static String routeName = "purchaseOrderReportScreen";

  const PurchaseOrderReportScreen({super.key});

  @override
  State<PurchaseOrderReportScreen> createState() =>
      _PurchaseOrderReportScreenState();
}

class _PurchaseOrderReportScreenState extends State<PurchaseOrderReportScreen> {
  @override
  void initState() {
    super.initState();
    PurchaseOrderProvider provider =
        Provider.of<PurchaseOrderProvider>(context, listen: false);
    provider.nestedTable();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PurchaseOrderProvider>(builder: (context, provider, child) {
      return Material(
        child: SafeArea(
            child: Scaffold(
          appBar: PreferredSize(
              preferredSize:
                  Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
              child: const CommonAppbar(title: 'Purchase Order Report')),
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
