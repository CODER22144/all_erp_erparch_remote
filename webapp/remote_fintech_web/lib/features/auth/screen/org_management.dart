import 'dart:convert';

import 'package:fintech_new_web/features/auth/screen/add_company.dart';
import 'package:fintech_new_web/features/auth/screen/update_user.dart';
import 'package:fintech_new_web/features/home.dart';
import 'package:fintech_new_web/features/utility/services/common_utility.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

import '../../common/widgets/comman_appbar.dart';
import '../../common/widgets/pop_ups.dart';
import '../provider/auth_provider.dart';
import 'add_company_group.dart';
import 'add_user.dart';

class OrgManagement extends StatefulWidget {
  static String routeName = "orgManagement";
  final String usrDetails;
  const OrgManagement({super.key, required this.usrDetails});

  @override
  State<OrgManagement> createState() => _OrgManagementState();
}

class _OrgManagementState extends State<OrgManagement> {
  @override
  void initState() {
    super.initState();
    AuthProvider provider = Provider.of<AuthProvider>(context, listen: false);
    provider.getAllOrgCompanyByGroupId();
  }

  @override
  Widget build(BuildContext context) {
    var data = jsonDecode(widget.usrDetails);
    return Consumer<AuthProvider>(builder: (context, provider, child) {
      return Scaffold(
        appBar: PreferredSize(
            preferredSize:
                Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
            child: const CommonAppbar(title: 'Org. Management')),
        body: Center(
          child: checkForEmptyOrNullString(data['cgId'])
              ? _buildCompanyTable(provider.orgComp, provider)
              : _buildEmptyState(),
        ),
      );
    });
  }

  // ✅ Empty State
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.network(
            "https://t3.ftcdn.net/jpg/01/35/34/34/360_F_135343441_7xf3a1GtqdRbb3qckfiqvKpaya2xk0Zi.jpg", // Add your image
            height: 200,
          ),
          const SizedBox(height: 20),
          const Text(
            "No Company Data Available",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(1), // Square shape
              ),
              padding: EdgeInsets.zero,
              // Remove internal padding to make it square
              minimumSize:
                  const Size(200, 50), // Width and height for the button
            ),
            child: const Text(
              "Add Company",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            onPressed: () {
              context.pushNamed(AddOrgCompany.routeName);
            },
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(1), // Square shape
              ),
              padding: EdgeInsets.zero,
              // Remove internal padding to make it square
              minimumSize:
                  const Size(200, 50), // Width and height for the button
            ),
            child: const Text(
              "Add Company Group",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            onPressed: () {
              context.pushNamed(AddCompanyGroup.routeName);
            },
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(1), // Square shape
              ),
              padding: EdgeInsets.zero,
              // Remove internal padding to make it square
              minimumSize:
                  const Size(200, 50), // Width and height for the button
            ),
            child: const Text(
              "Add User",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            onPressed: () {
              context.pushNamed(AddUser.routeName);
            },
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(1), // Square shape
              ),
              padding: EdgeInsets.zero,
              // Remove internal padding to make it square
              minimumSize:
                  const Size(200, 50), // Width and height for the button
            ),
            child: const Text(
              "Manage Users",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            onPressed: () {
              context.pushNamed(UpdateUser.routeName);
            },
          ),
        ],
      ),
    );
  }

  // ✅ Table UI
  Widget _buildCompanyTable(List<dynamic> orgComp, AuthProvider provider) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Visibility(
        visible: orgComp.isNotEmpty,
        child: DataTable(
          border: const TableBorder(
            top: BorderSide(color: Colors.black),
            bottom: BorderSide(color: Colors.black),
            left: BorderSide(color: Colors.black),
            right: BorderSide(color: Colors.black),
            // horizontalInside: BorderSide(color: Colors.black),
          ),
          columns: const [
            DataColumn(
                label: Text("COMPANY ID",
                    style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(
                label: Text("COMPANY NAME",
                    style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: SizedBox()),
          ],
          rows: orgComp.map((company) {
            return DataRow(
              cells: [
                DataCell(Text(company["cid"] ?? "")),
                DataCell(Text(company["company_name"] ?? "")),
                DataCell(ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)))),
                  onPressed: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.setString("currentLoginCid", company["cid"]);
                    http.StreamedResponse result =
                        await provider.updateUserCid(company["cid"]);
                    var message =
                        jsonDecode(await result.stream.bytesToString());
                    if (result.statusCode == 200) {
                      context.goNamed(HomePageScreen.routeName);
                    } else if (result.statusCode == 400) {
                      await showAlertDialog(context,
                          message['message'].toString(), "Continue", false);
                    } else if (result.statusCode == 500) {
                      await showAlertDialog(
                          context, message['message'], "Continue", false);
                    } else {
                      await showAlertDialog(
                          context, message['message'], "Continue", false);
                    }
                  },
                  child: const Row(
                    children: [
                      Text(
                        'Connect',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      Icon(Icons.play_arrow, color: Colors.white)
                    ],
                  ),
                ))
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
