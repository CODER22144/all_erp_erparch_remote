import 'dart:convert';

import 'package:fintech_new_web/features/salesOrder/provider/sales_order_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../common/widgets/comman_appbar.dart';
import '../../common/widgets/pop_ups.dart';
import '../../network/service/network_service.dart';
import '../../utility/services/common_utility.dart';

class EinvoicePending extends StatefulWidget {
  static String routeName = "/EinvoicePending";

  const EinvoicePending({super.key});

  @override
  State<EinvoicePending> createState() => _EinvoicePendingState();
}

class _EinvoicePendingState extends State<EinvoicePending> {
  @override
  void initState() {
    SalesOrderProvider provider =
        Provider.of<SalesOrderProvider>(context, listen: false);
    provider.getEInvoicePending();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SalesOrderProvider>(builder: (context, provider, child) {
      return Material(
        child: SafeArea(
            child: Scaffold(
          appBar: PreferredSize(
              preferredSize:
                  Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
              child: const CommonAppbar(title: 'E-Invoice Pending')),
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: provider.invoicePending.isNotEmpty
                  ? DataTable(
                      columns: const [
                        DataColumn(label: Text("Invoice No.")),
                        DataColumn(label: Text("Date")),
                        DataColumn(label: Text("Partner Code")),
                        DataColumn(label: Text("Partner Name")),
                        DataColumn(label: Text("City")),
                        DataColumn(label: Text("State")),
                        DataColumn(label: Text("Total Amount")),
                        DataColumn(label: Text("")),
                      ],
                      rows: provider.invoicePending.map((tabData) {
                        return DataRow(cells: [
                          DataCell(InkWell(
                              onTap: () async {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                var cid = prefs.getString("currentLoginCid");
                                final Uri uri = Uri.parse(
                                    "${NetworkService.baseUrl}/get-sale-invc-pdf/${tabData['invNo']}/$cid/");
                                if (await canLaunchUrl(uri)) {
                                  await launchUrl(uri,
                                      mode: LaunchMode.inAppBrowserView);
                                } else {
                                  throw 'Could not launch';
                                }
                              },
                              child: Text('${tabData['invNo'] ?? "-"}',
                                  style: const TextStyle(
                                      color: Colors.blueAccent,
                                      fontWeight: FontWeight.w500)))),
                          DataCell(Text('${tabData['dtdate'] ?? "-"}')),
                          DataCell(Text('${tabData['custCode'] ?? "-"}')),
                          DataCell(Text('${tabData['custName'] ?? "-"}')),
                          DataCell(Text('${tabData['custCity'] ?? "-"}')),
                          DataCell(Text('${tabData['custStateName'] ?? "-"}')),
                          DataCell(Text('${tabData['sumtamount'] ?? "-"}')),
                          DataCell(ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)))),
                            onPressed: () async {
                              NetworkService networkService = NetworkService();
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();

                              String gstBaseUrl = NetworkService.productionGstBaseUrl;

                              if(checkForEmptyOrNullString(prefs.getString("userData"))) {
                                if(jsonDecode(prefs.getString("userData")!)['cid'] == "OW") {
                                  gstBaseUrl = "https://apisandbox.whitebooks.in";
                                }
                              }

                              prefs.remove("gstToken");
                              prefs.remove("gstTokenExpiry");

                              http.StreamedResponse response =
                                  await networkService.post(
                                      "/export-einvoice-api/",
                                      {"docno": tabData['invNo']});
                              if (response.statusCode == 200) {
                                var eInvoiceJson = jsonDecode(
                                    await response.stream.bytesToString());

                                // AUTHERIZATION
                                http.StreamedResponse gstApiResponse =
                                    await networkService.get("/get-gst-api/");

                                var heads = jsonDecode(await gstApiResponse
                                    .stream
                                    .bytesToString())[0];

                                String? authToken = heads['token'];
                                String? expiry = heads['exdate'];

                                if (tokenExpired(expiry)) {
                                  // update api and set token and exdate to null
                                  updateGstCreds(null, null);
                                  authToken = null;
                                  expiry = null;
                                }

                                if (!checkForEmptyOrNullString(authToken) &&
                                    !checkForEmptyOrNullString(expiry)) {
                                  http.StreamedResponse gstResp =
                                      await networkService.authorizeGst(heads, gstBaseUrl);

                                  if (gstResp.statusCode == 200) {
                                    var gstCreds = jsonDecode(
                                        await gstResp.stream.bytesToString());

                                    // UPDATE REAL TOKEN AND EXPIRY DATE TO DATABASE
                                    updateGstCreds(gstCreds['data']['AuthToken'], gstCreds['data']['TokenExpiry']);

                                    authToken = gstCreds['data']['AuthToken'];
                                    expiry = gstCreds['data']['TokenExpiry'];
                                  } else {
                                    var responseBody = jsonDecode(
                                        await gstResp.stream.bytesToString());
                                    var error = responseBody['error'];
                                    if (error != null) {
                                      await showAlertDialog(
                                          context,
                                          responseBody['error']['message'],
                                          "Continue",
                                          false);
                                    } else {
                                      await showAlertDialog(
                                          context,
                                          responseBody['status_desc'],
                                          "Continue",
                                          false);
                                    }
                                  }
                                }

                                Map<String, String> headers = {
                                  'accept': '*/*',
                                  'ip_address': heads['ipAddress'],
                                  'client_id': heads['clId'],
                                  'client_secret': heads['clSec'],
                                  'username': heads['usrname'],
                                  'auth-token': authToken!,
                                  'gstin': heads['gstin'],
                                  'Content-Type': 'application/json'
                                };

                                var request = http.Request(
                                    'POST',
                                    Uri.parse(
                                        '$gstBaseUrl/einvoice/type/GENERATE/version/V1_03?email=${heads['email']}'));

                                request.body = json.encode(eInvoiceJson);
                                request.headers.addAll(headers);

                                http.StreamedResponse resp =
                                    await request.send();
                                var responseBody = jsonDecode(
                                    await resp.stream.bytesToString());

                                if (resp.statusCode == 200 &&
                                    responseBody['status_cd'] == "1") {
                                  var irnData = jsonDecode(jsonDecode(
                                      decodeBase64(responseBody['data']
                                              ['SignedQRCode']
                                          .toString()
                                          .split(".")[1]))['data']);

                                  var obPayload = {
                                    "docno": irnData['DocNo'],
                                    "doctype": irnData['DocTyp'],
                                    "docdate": irnData['DocDt'],
                                    "billValue": irnData['TotInvVal'],
                                    "rgstin": irnData['BuyerGstin'],
                                    "ewbno": responseBody['data']['EwbNo'],
                                    "irn": responseBody['data']['Irn'],
                                    "ackno": responseBody['data']['AckNo'],
                                    "ackdate": responseBody['data']['AckDt'],
                                    "sqrcode": responseBody['data']
                                        ['SignedQRCode'],
                                    "status": responseBody['data']['Status'],
                                    "ordId": tabData['invNo']
                                  };

                                  http.StreamedResponse orderBilledResponse =
                                      await networkService.post(
                                          "/append-order-billed/", obPayload);
                                  if (orderBilledResponse.statusCode == 200) {
                                    await showAlertDialog(
                                        context,
                                        "Bill Upload For Document No: ${tabData['invNo']}",
                                        "Continue",
                                        false);
                                    provider.getEInvoicePending();
                                  } else if (orderBilledResponse.statusCode ==
                                      400) {
                                    var message = jsonDecode(
                                        await orderBilledResponse.stream
                                            .bytesToString());
                                    await showAlertDialog(
                                        context,
                                        message['message'].toString(),
                                        "Continue",
                                        false);
                                  } else if (orderBilledResponse.statusCode ==
                                      500) {
                                    var message = jsonDecode(
                                        await orderBilledResponse.stream
                                            .bytesToString());
                                    await showAlertDialog(context,
                                        message['message'], "Continue", false);
                                  } else {
                                    var message = jsonDecode(
                                        await orderBilledResponse.stream
                                            .bytesToString());
                                    await showAlertDialog(context,
                                        message['message'], "Continue", false);
                                  }
                                } else {
                                  var error = responseBody['error'];
                                  if (error != null) {
                                    await showAlertDialog(
                                        context,
                                        responseBody['error']['message'],
                                        "Continue",
                                        false);
                                  } else {
                                    await showAlertDialog(
                                        context,
                                        responseBody['status_desc'],
                                        "Continue",
                                        false);
                                  }
                                }
                              } else {
                                showAlertDialog(
                                  context,
                                  "Invalid Invoice No. or no data is fetched for Invoice No : ${tabData['invNo']}",
                                  "CONTINUE",
                                  false,
                                );
                              }
                            },
                            child: const Text(
                              'Generate E-Invoice',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.white),
                            ),
                          )),
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

  bool tokenExpired(String? expiry) {
    bool timeOkay = true;
    if (checkForEmptyOrNullString(expiry)) {
      DateTime targetTime = DateTime.parse(expiry!);

      final now = DateTime.now();
      if (now.isBefore(targetTime.add(const Duration(seconds: 1)))) {
        timeOkay = false;
      }
    }
    return timeOkay;
  }

  void updateGstCreds(String? token, String? exdate) async {
    NetworkService networkService = NetworkService();
    networkService.post("/update-gst-api/", {"token" : token, "exdate" : exdate});
  }
}
