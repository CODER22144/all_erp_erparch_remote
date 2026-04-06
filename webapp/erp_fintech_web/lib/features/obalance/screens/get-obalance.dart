import 'package:fintech_new_web/features/materialIQS/screens/create_material_iqs.dart';
import 'package:fintech_new_web/features/obalance/provider/oblance_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

import '../../common/widgets/comman_appbar.dart';
import '../../utility/global_variables.dart';

class GetOBalance extends StatefulWidget {
  static String routeName = 'edit-obalance';
  const GetOBalance({super.key});

  @override
  State<GetOBalance> createState() => _GetOBalanceState();
}

class _GetOBalanceState extends State<GetOBalance> {
  @override
  Widget build(BuildContext context) {
    return Consumer<OBalanceProvider>(builder: (context, provider, child) {
      return Scaffold(
        appBar: PreferredSize(
            preferredSize:
                Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
            child: const CommonAppbar(title: 'Get OBalance')),
        body: SingleChildScrollView(
          child: Center(
            child: Container(
              width: kIsWeb
                  ? GlobalVariables.deviceWidth / 2.0
                  : GlobalVariables.deviceWidth,
              padding: const EdgeInsets.all(10),
              child: Form(
                // key: formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: TextFormField(
                        style:
                            const TextStyle(color: Colors.black, fontSize: 14),
                        readOnly: false,
                        controller: provider.editController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          border: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black)),
                          focusedBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey, width: 2),
                          ),
                          label: RichText(
                            text: const TextSpan(
                              text: "Material IQS code",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                fontWeight: FontWeight.w300,
                              ),
                              children: [
                                TextSpan(
                                    text: "*",
                                    style: TextStyle(color: Colors.red))
                              ],
                            ),
                          ),
                        ),
                        validator: (String? val) {
                          if ((val == null || val.isEmpty)) {
                            return 'This field is Mandatory';
                          }
                        },
                        maxLines: 1,
                        onChanged: (value) {
                          // GlobalVariables.requestBody[widget.feature][widget.field.id] = value;
                        },
                        inputFormatters: <TextInputFormatter>[
                          // FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9#\$&*!₹%.@_ ]')),
                          LengthLimitingTextInputFormatter(15)
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
                          context.pushNamed(CreateMaterialIqs.routeName,
                              queryParameters: {"editing": 'true'});
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
