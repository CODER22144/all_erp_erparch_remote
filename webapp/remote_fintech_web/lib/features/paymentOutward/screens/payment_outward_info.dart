// ignore_for_file: use_build_context_synchronously
import 'package:fintech_new_web/features/paymentOutward/provider/payment_outward_provider.dart';
import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

import '../../common/widgets/comman_appbar.dart';

class PaymentOutwardInfo extends StatefulWidget {
  static String routeName = "PaymentOutwardInfo";

  const PaymentOutwardInfo({super.key});

  @override
  State<PaymentOutwardInfo> createState() => _PaymentOutwardInfoState();
}

class _PaymentOutwardInfoState extends State<PaymentOutwardInfo> {
  late PaymentOutwardProvider provider;

  @override
  void initState() {
    super.initState();
    provider = Provider.of<PaymentOutwardProvider>(context, listen: false);
    provider.initEditWidget();
  }

  @override
  Widget build(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    return Consumer<PaymentOutwardProvider>(builder: (context, provider, child) {
      return Scaffold(
        backgroundColor: HexColor('#f9f9ff'),
        appBar: PreferredSize(
            preferredSize:
            Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
            child: const CommonAppbar(
                title:"Payment Outward Info")),
        body: SingleChildScrollView(
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                  border: provider.widgetList.isNotEmpty
                      ? Border.all(width: 1, color: Colors.black)
                      : null),
              width: kIsWeb
                  ? GlobalVariables.deviceWidth / 2.0
                  : GlobalVariables.deviceWidth,
              padding: const EdgeInsets.all(10),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    ListView.builder(
                      itemCount: provider.widgetList.length,
                      physics: const ClampingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return provider.widgetList[index];
                      },
                    ),
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
