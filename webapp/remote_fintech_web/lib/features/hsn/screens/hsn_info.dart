// ignore_for_file: use_build_context_synchronously
import 'dart:convert';
import 'dart:io';

import 'package:fintech_new_web/features/common/widgets/pop_ups.dart';
import 'package:fintech_new_web/features/hsn/provider/hsn_provider.dart';
import 'package:fintech_new_web/features/hsn/screens/get_hsn.dart';
import 'package:fintech_new_web/features/inwardVoucher/provider/inward_voucher_provider.dart';
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
import '../../utility/services/common_utility.dart';

class HsnInfo extends StatefulWidget {
  static String routeName = "hsnInfo";
  const HsnInfo({super.key});

  @override
  State<HsnInfo> createState() => _HsnInfoState();
}

class _HsnInfoState extends State<HsnInfo> {
  late HsnProvider provider;

  @override
  void initState() {
    super.initState();
    provider = Provider.of<HsnProvider>(context, listen: false);
    provider.reset();
    provider.initEditWidget();
  }

  @override
  void dispose() {
    super.dispose();
    provider.reset();
  }

  @override
  Widget build(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    return Consumer<HsnProvider>(builder: (context, provider, child) {
      return Scaffold(
        appBar: PreferredSize(
            preferredSize:
            Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
            child: const CommonAppbar(
                title: "HSN Details")),
        body: SingleChildScrollView(
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(width: 2, color: Colors.white54)),
              padding: const EdgeInsets.only(
                  top: 10, bottom: 10, right: 20, left: 20),
              width: kIsWeb
                  ? GlobalVariables.deviceWidth / 2.0
                  : GlobalVariables.deviceWidth,
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Visibility(
                      visible: provider.widgetList.isNotEmpty,
                      child: Padding(
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
