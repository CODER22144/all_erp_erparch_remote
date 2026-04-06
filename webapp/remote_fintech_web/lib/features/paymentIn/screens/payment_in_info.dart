// ignore_for_file: use_build_context_synchronously
import 'dart:convert';
import 'dart:io';

import 'package:fintech_new_web/features/common/widgets/pop_ups.dart';
import 'package:fintech_new_web/features/paymentIn/provider/payment_in_provider.dart';
import 'package:fintech_new_web/features/paymentOutward/provider/payment_outward_provider.dart';
import 'package:fintech_new_web/features/utility/global_variables.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:file_picker/file_picker.dart';
import 'package:excel/excel.dart' as exl;

import '../../common/widgets/comman_appbar.dart';

class PaymentInInfo extends StatefulWidget {
  static String routeName = "PaymentInInfo";

  const PaymentInInfo({super.key});

  @override
  State<PaymentInInfo> createState() => _PaymentInInfoState();
}

class _PaymentInInfoState extends State<PaymentInInfo> {
  late PaymentInProvider provider;

  @override
  void initState() {
    super.initState();
    provider = Provider.of<PaymentInProvider>(context, listen: false);
    provider.initEditWidget();
  }

  @override
  Widget build(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    return Consumer<PaymentInProvider>(builder: (context, provider, child) {
      return Scaffold(
        backgroundColor: HexColor('#f9f9ff'),
        appBar: PreferredSize(
            preferredSize:
                Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
            child: const CommonAppbar(title: "Add Payment Info")),
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
