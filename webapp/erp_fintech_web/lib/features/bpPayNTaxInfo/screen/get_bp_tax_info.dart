import 'package:fintech_new_web/features/bpPayNTaxInfo/screen/edit_bp_tax_info.dart';
import 'package:fintech_new_web/features/businessPartner/screen/business_partner.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:searchable_paginated_dropdown/searchable_paginated_dropdown.dart';

import '../../businessPartner/provider/business_partner_provider.dart';
import '../../common/widgets/comman_appbar.dart';
import '../../utility/global_variables.dart';

class GetBpTaxInfo extends StatefulWidget {
  static String routeName = 'GetBpTaxInfo';
  const GetBpTaxInfo({super.key});

  @override
  State<GetBpTaxInfo> createState() => _GetBpTaxInfoState();
}

class _GetBpTaxInfoState extends State<GetBpTaxInfo> {
  TextEditingController editingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    BusinessPartnerProvider provider = Provider.of<BusinessPartnerProvider>(context, listen: false);
    provider.getBusinessPartnerCodes();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BusinessPartnerProvider>(
        builder: (context, provider, child) {
          return Scaffold(
            appBar: PreferredSize(
                preferredSize:
                Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
                child: const CommonAppbar(title: 'Edit BP Pay & Tax Info')),
            body: SingleChildScrollView(
              child: Center(
                child: Visibility(
                  visible: provider.bpCodes.isNotEmpty,
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
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  child: SearchableDropdown<String>(
                                    isEnabled: true,
                                    backgroundDecoration: (child) => Container(
                                      height: 40,
                                      margin: EdgeInsets.zero,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(
                                            color: Colors.black, width: 0.5),
                                      ),
                                      child: child,
                                    ),
                                    items: provider.bpCodes,
                                    onChanged: (value) {
                                      setState(() {
                                        editingController.text = value!;
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
                                context.pushNamed(EditBpTaxInfo.routeName,
                                    queryParameters: {"bpCode": editingController.text});
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
