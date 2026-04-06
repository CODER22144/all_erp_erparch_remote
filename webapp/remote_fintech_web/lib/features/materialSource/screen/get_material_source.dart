import 'package:fintech_new_web/features/materialSource/provider/material_source_provider.dart';
import 'package:fintech_new_web/features/materialSource/screen/material_source.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:searchable_paginated_dropdown/searchable_paginated_dropdown.dart';

import '../../common/widgets/comman_appbar.dart';
import '../../utility/global_variables.dart';

class GetMaterialSource extends StatefulWidget {
  static String routeName = 'edit-material-source';
  const GetMaterialSource({super.key});

  @override
  State<GetMaterialSource> createState() => _GetMaterialSourceState();
}

class _GetMaterialSourceState extends State<GetMaterialSource> {

  @override
  void initState() {
    super.initState();
    MaterialSourceProvider provider =
    Provider.of<MaterialSourceProvider>(context, listen: false);
    provider.editController.clear();
    provider.getBusinessPartner();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MaterialSourceProvider>(
        builder: (context, provider, child) {
          return Scaffold(
            appBar: PreferredSize(
                preferredSize:
                Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
                child: const CommonAppbar(title: 'Get Material Source')),
            body: SingleChildScrollView(
              child: Center(
                child: Visibility(
                  visible: provider.businessPartner.isNotEmpty,
                  child: Container(
                    width: kIsWeb
                        ? GlobalVariables.deviceWidth / 2.0
                        : GlobalVariables.deviceWidth,
                    padding: const EdgeInsets.all(10),
                    child: Form(
                      // key: formKey,
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
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
                                    items: provider.businessPartner,
                                    onChanged: (value) {
                                      setState(() {
                                        provider.setBpController(value!);
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
                                        "Business Partner Code",
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
                                    text: "Material No.",
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
                                context.pushNamed(MaterialSource.routeName,
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
            ),
          );
        });
  }
}
