import 'dart:convert';

import 'package:fintech_new_web/features/auth/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:searchable_paginated_dropdown/searchable_paginated_dropdown.dart';
import 'package:http/http.dart' as http;
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/widgets/comman_appbar.dart';
import '../../common/widgets/pop_ups.dart';
import '../../utility/global_variables.dart';
import '../../utility/services/common_utility.dart';
import 'login.dart';

class UpdateUser extends StatefulWidget {
  static String routeName = "UpdateUser";

  const UpdateUser({super.key});

  @override
  State<UpdateUser> createState() => _UpdateUserState();
}

class _UpdateUserState extends State<UpdateUser> {
  String selectedCompanyGroup = "";

  @override
  void initState() {
    AuthProvider provider = Provider.of<AuthProvider>(context, listen: false);
    provider.getAllUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(builder: (context, provider, child) {
      return Material(
        child: SafeArea(
            child: Scaffold(
          appBar: PreferredSize(
              preferredSize:
                  Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
              child: const CommonAppbar(title: 'User Details')),
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: provider.users.isNotEmpty && provider.compGroups.isNotEmpty
                  ? DataTable(
                      columns: const [
                        DataColumn(
                            label: Text("User ID",
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text("First Name",
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text("Last Name",
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text("Email",
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text("Roles",
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text("Group ID",
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text("")),
                      ],
                      rows: provider.users.map((data) {
                        return DataRow(cells: [
                          DataCell(Text('${data['userId'] ?? "-"}')),
                          DataCell(Text('${data['first_name'] ?? "-"}')),
                          DataCell(Text('${data['last_name'] ?? "-"}')),
                          DataCell(Text('${data['email'] ?? "-"}')),
                          DataCell(Text('${data['roles'] ?? "-"}')),
                          DataCell(SizedBox(
                            width: 150,
                            child: SearchableDropdown<String>(
                              trailingIcon: const SizedBox(),
                              controller: SearchableDropdownController(
                                  initialItem: findDropdownMenuItem(
                                      provider.compGroups, data['cgId'] ?? "")),
                              backgroundDecoration: (child) => Container(
                                height: 48,
                                margin: EdgeInsets.zero,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(
                                      color: Colors.black45, width: 0.8),
                                ),
                                child: child,
                              ),
                              items: provider.compGroups,
                              onChanged: (String? value) {
                                setState(() {
                                  selectedCompanyGroup = value!;
                                });
                              },
                              hasTrailingClearIcon: false,
                            ),
                          )),
                          DataCell(ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueAccent,
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)))),
                            onPressed: () async {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              var userData = prefs.getString("userData");

                              http.StreamedResponse result = await provider
                                  .updateUserCompanyGroup(selectedCompanyGroup, data['userId']);
                              var message = jsonDecode(
                                  await result.stream.bytesToString());
                              if (result.statusCode == 200) {
                                if (data['userId'] ==
                                    jsonDecode(userData!)['userId']) {
                                  provider.updateUserCid(null);
                                  prefs.remove("auth_token");
                                  GlobalVariables.requestBody.clear();
                                  context.goNamed(LoginScreen.routeName);
                                } else {
                                  provider.getAllUsers();
                                  context.pushReplacementNamed(
                                      UpdateUser.routeName);
                                }
                              } else if (result.statusCode == 400) {
                                await showAlertDialog(
                                    context,
                                    message['message'].toString(),
                                    "Continue",
                                    false);
                              } else if (result.statusCode == 500) {
                                await showAlertDialog(context,
                                    message['message'], "Continue", false);
                              } else {
                                await showAlertDialog(context,
                                    message['message'], "Continue", false);
                              }
                            },
                            child: const Text(
                              'Update',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.white),
                            ),
                          ))
                        ]);
                      }).toList(),
                    )
                  : const SizedBox(),
            ),
          ),
        )),
      );
    });
  }
}
