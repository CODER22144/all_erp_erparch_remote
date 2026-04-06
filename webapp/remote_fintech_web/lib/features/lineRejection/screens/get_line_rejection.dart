import 'package:fintech_new_web/features/lineRejection/provider/line_rejection_provider.dart';
import 'package:fintech_new_web/features/lineRejection/screens/line_rejection_pending.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:searchable_paginated_dropdown/searchable_paginated_dropdown.dart';

import '../../common/widgets/comman_appbar.dart';
import '../../utility/global_variables.dart';

class GetLineRejection extends StatefulWidget {
  static String routeName = 'GetLineRejection';
  const GetLineRejection({super.key});

  @override
  State<GetLineRejection> createState() => _GetLineRejectionState();
}

class _GetLineRejectionState extends State<GetLineRejection> {
  @override
  void initState() {
    super.initState();
    LineRejectionProvider provider =
        Provider.of<LineRejectionProvider>(context, listen: false);
    provider.editController.clear();
    provider.getBpCodes();
  }

  SearchableDropdownController<String> controller = SearchableDropdownController();

  @override
  Widget build(BuildContext context) {
    return Consumer<LineRejectionProvider>(builder: (context, provider, child) {
      return Scaffold(
        appBar: PreferredSize(
            preferredSize:
                Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
            child: const CommonAppbar(title: "Line Rejection Pending")),
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
                    Visibility(
                      visible: provider.bpCodes.isNotEmpty,
                      child: Stack(
                        children: [
                          Container(
                            color: Colors.white,
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            child: SearchableDropdown<String>(
                              controller: controller,
                              trailingIcon: const SizedBox(),
                              isEnabled: true,
                              backgroundDecoration: (child) => Container(
                                height: 40,
                                margin: EdgeInsets.zero,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border:
                                      Border.all(color: Colors.black, width: 0.5),
                                ),
                                child: child,
                              ),
                              items: provider.bpCodes,
                              onChanged: (value) {
                                provider.editController.text = value!;
                              },
                              hasTrailingClearIcon: false,
                            ),
                          ),
                          Positioned(
                            left: 10,
                            top: 3,
                            child: Container(
                              color: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 2),
                              child: const Wrap(
                                children: [
                                  Text(
                                    "Business Partner",
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
                          Positioned(
                              left: GlobalVariables.deviceWidth / 2.21,
                              top: 10,
                              child: IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  // Clear the text field and trigger onChanged
                                  setState(() {
                                    controller.selectedItem.value = null;
                                    provider.editController.clear();
                                  });
                                },
                              ))
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
                          context.pushNamed(LineRejectionPending.routeName);
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
