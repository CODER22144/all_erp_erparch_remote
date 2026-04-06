import 'package:fintech_new_web/features/businessPartner/screen/business_partner.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:searchable_paginated_dropdown/searchable_paginated_dropdown.dart';

import '../../common/widgets/comman_appbar.dart';
import '../../utility/global_variables.dart';
import '../provider/business_partner_provider.dart';

class GetBusinessPartner extends StatefulWidget {
  static String routeName = 'edit-business-partner';
  const GetBusinessPartner({super.key});

  @override
  State<GetBusinessPartner> createState() => _GetBusinessPartnerState();
}

class _GetBusinessPartnerState extends State<GetBusinessPartner> {
  @override
  void initState() {
    super.initState();
    BusinessPartnerProvider provider = Provider.of<BusinessPartnerProvider>(context, listen:false);
    provider.getBusinessPartnerCodes();
    provider.editController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BusinessPartnerProvider>(
        builder: (context, provider, child) {
      return Scaffold(
        appBar: PreferredSize(
            preferredSize:
                Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
            child: const CommonAppbar(title: 'Get Business Partner')),
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
                                    provider.editController.text = value!;
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
                            context.pushNamed(BusinessPartner.routeName,
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
