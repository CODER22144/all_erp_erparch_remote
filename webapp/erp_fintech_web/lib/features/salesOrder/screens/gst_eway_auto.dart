// import 'dart:convert';
//
// import 'package:fintech_new_web/features/common/widgets/pop_ups.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:hexcolor/hexcolor.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../../common/widgets/comman_appbar.dart';
// import '../../network/service/network_service.dart';
// import '../../utility/global_variables.dart';
// import '../../utility/services/common_utility.dart';
//
// class GstEwayAuto extends StatefulWidget {
//   static String routeName = '/GstEwayAuto';
//   const GstEwayAuto({super.key});
//
//   @override
//   State<GstEwayAuto> createState() => _GstEwayAutoState();
// }
//
// class _GstEwayAutoState extends State<GstEwayAuto> {
//   TextEditingController docnoController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: PreferredSize(
//           preferredSize:
//               Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
//           child: const CommonAppbar(title: 'Generate GST E-Invoice')),
//       body: SingleChildScrollView(
//         child: Center(
//           child: Container(
//             width: kIsWeb
//                 ? GlobalVariables.deviceWidth / 2.0
//                 : GlobalVariables.deviceWidth,
//             padding: const EdgeInsets.all(10),
//             child: Form(
//               // key: formKey,
//               child: Column(
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 5),
//                     child: TextFormField(
//                       style: const TextStyle(color: Colors.black, fontSize: 14),
//                       readOnly: false,
//                       controller: docnoController,
//                       keyboardType: TextInputType.text,
//                       decoration: InputDecoration(
//                         floatingLabelBehavior: FloatingLabelBehavior.always,
//                         border: const OutlineInputBorder(
//                             borderSide: BorderSide(color: Colors.black)),
//                         focusedBorder: const OutlineInputBorder(
//                           borderSide: BorderSide(color: Colors.grey, width: 2),
//                         ),
//                         label: RichText(
//                           text: const TextSpan(
//                             text: "Invoice No.",
//                             style: TextStyle(
//                               fontSize: 14,
//                               color: Colors.black,
//                               fontWeight: FontWeight.w300,
//                             ),
//                             children: [
//                               TextSpan(
//                                   text: "*",
//                                   style: TextStyle(color: Colors.red))
//                             ],
//                           ),
//                         ),
//                       ),
//                       validator: (String? val) {
//                         if ((val == null || val.isEmpty)) {
//                           return 'This field is Mandatory';
//                         }
//                       },
//                       maxLines: 1,
//                     ),
//                   ),
//                   Row(
//                     mainAxisAlignment:
//                         MainAxisAlignment.spaceEvenly, // Adjust alignment
//                     children: [
//                       // Expanded(
//                       //   // Ensures even spacing and prevents overflow
//                       //   child: Container(
//                       //     margin: const EdgeInsets.only(bottom: 10, right: 5),
//                       //     child: ElevatedButton(
//                       //       style: ElevatedButton.styleFrom(
//                       //         backgroundColor: HexColor("#0B6EFE"),
//                       //         shape: const RoundedRectangleBorder(
//                       //           borderRadius:
//                       //               BorderRadius.all(Radius.circular(5)),
//                       //         ),
//                       //       ),
//                       //       onPressed: () async {
//                       //         NetworkService networkService = NetworkService();
//                       //         http.StreamedResponse response =
//                       //             await networkService.post(
//                       //                 "/export-eway-bill-sale/",
//                       //                 {"docno": docnoController.text});
//                       //         if (response.statusCode == 200) {
//                       //           var data = jsonDecode(
//                       //               await response.stream.bytesToString());
//                       //           String fileName =
//                       //               'eway_bill_${docnoController.text}.json';
//                       //           String jsonString =
//                       //               const JsonEncoder.withIndent("  ")
//                       //                   .convert(data);
//                       //
//                       //           if (data['billLists'] != null) {
//                       //             if (kIsWeb) {
//                       //               downloadJsonWeb(jsonString, fileName);
//                       //             } else {
//                       //               downloadForAndroid(
//                       //                   jsonString, fileName, context);
//                       //             }
//                       //           } else {
//                       //             showAlertDialog(
//                       //               context,
//                       //               "Invalid Invoice No. or no data is fetched for Invoice No : ${docnoController.text}",
//                       //               "CONTINUE",
//                       //               false,
//                       //             );
//                       //           }
//                       //         }
//                       //       },
//                       //       child: const Text(
//                       //         'Eway Bill',
//                       //         style: TextStyle(
//                       //             fontSize: 20,
//                       //             fontWeight: FontWeight.bold,
//                       //             color: Colors.white),
//                       //       ),
//                       //     ),
//                       //   ),
//                       // ),
//                       Expanded(
//                         // Ensures even spacing and prevents overflow
//                         child: Container(
//                           margin: const EdgeInsets.only(bottom: 10, left: 5),
//                           child: ElevatedButton(
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: HexColor("#0B6EFE"),
//                               shape: const RoundedRectangleBorder(
//                                 borderRadius:
//                                     BorderRadius.all(Radius.circular(5)),
//                               ),
//                             ),
//                             onPressed: () async {
//                               NetworkService networkService = NetworkService();
//                               SharedPreferences prefs =
//                                   await SharedPreferences.getInstance();
//                               http.StreamedResponse response =
//                                   await networkService.post(
//                                       "/export-einvoice-api/",
//                                       {"docno": docnoController.text});
//                               if (response.statusCode == 200) {
//                                 var data = jsonDecode(
//                                     await response.stream.bytesToString());
//
//                                 // AUTHERIZATION
//                                 http.StreamedResponse gstApiResponse =
//                                     await networkService.get("/get-gst-api/");
//
//                                 var heads = jsonDecode(await gstApiResponse
//                                     .stream
//                                     .bytesToString())[0];
//
//                                 String? authToken = prefs.getString("gstToken");
//                                 String? expiry =
//                                     prefs.getString("gstTokenExpiry");
//
//                                 if (tokenExpired(expiry)) {
//                                   prefs.remove("gstToken");
//                                   prefs.remove("gstTokenExpiry");
//                                   authToken = null;
//                                   expiry = null;
//                                 }
//
//                                 if (!checkForEmptyOrNullString(authToken) &&
//                                     !checkForEmptyOrNullString(expiry)) {
//                                   http.StreamedResponse gstResp =
//                                       await networkService.authorizeGst(heads);
//
//                                   if (gstResp.statusCode == 200) {
//                                     var data = jsonDecode(
//                                         await gstResp.stream.bytesToString());
//                                     prefs.setString(
//                                         "gstToken", data['data']['AuthToken']);
//                                     prefs.setString("gstTokenExpiry",
//                                         data['data']['TokenExpiry']);
//                                     authToken = data['data']['AuthToken'];
//                                   } else {
//                                     var responseBody = jsonDecode(
//                                         await gstResp.stream.bytesToString());
//                                     var error = responseBody['error'];
//                                     if (error != null) {
//                                       await showAlertDialog(
//                                           context,
//                                           responseBody['error']['message'],
//                                           "Continue",
//                                           false);
//                                     } else {
//                                       await showAlertDialog(
//                                           context,
//                                           responseBody['status_desc'],
//                                           "Continue",
//                                           false);
//                                     }
//                                   }
//                                 }
//
//                                 Map<String, String> headers = {
//                                   'accept': '*/*',
//                                   'ip_address': heads['ipAddress'],
//                                   'client_id': heads['clId'],
//                                   'client_secret': heads['clSec'],
//                                   'username': heads['usrname'],
//                                   'auth-token': authToken!,
//                                   'gstin': heads['gstin'],
//                                   'Content-Type': 'application/json'
//                                 };
//                                 var request = http.Request(
//                                     'POST',
//                                     Uri.parse(
//                                         '${NetworkService.productionGstBaseUrl}/einvoice/type/GENERATE/version/V1_03?email=${heads['email']}'));
//                                 request.body = json.encode(data);
//                                 request.headers.addAll(headers);
//
//                                 http.StreamedResponse resp =
//                                     await request.send();
//                                 var responseBody = jsonDecode(
//                                     await resp.stream.bytesToString());
//
//                                 if (resp.statusCode == 200 &&
//                                     responseBody['status_cd'] == "1") {
//                                   var irnData = jsonDecode(jsonDecode(
//                                       decodeBase64(responseBody['data']
//                                               ['SignedQRCode']
//                                           .toString()
//                                           .split(".")[1]))['data']);
//
//                                   var obPayload = {
//                                     "docno": irnData['DocNo'],
//                                     "doctype": irnData['DocTyp'],
//                                     "docdate": irnData['DocDt'],
//                                     "billValue": irnData['TotInvVal'],
//                                     "rgstin": irnData['BuyerGstin'],
//                                     "ewbno": responseBody['data']['EwbNo'],
//                                     "irn": responseBody['data']['Irn'],
//                                     "ackno": responseBody['data']['AckNo'],
//                                     "ackdate": responseBody['data']['AckDt'],
//                                     "sqrcode": responseBody['data']
//                                         ['SignedQRCode'],
//                                     "status": responseBody['data']['Status'],
//                                     "ordId": docnoController.text
//                                   };
//
//                                   http.StreamedResponse orderBilledResponse =
//                                       await networkService.post(
//                                           "/append-order-billed/", obPayload);
//                                   if (orderBilledResponse.statusCode == 200) {
//                                     await showAlertDialog(
//                                         context,
//                                         "Bill Upload For Document No: ${docnoController.text}",
//                                         "Continue",
//                                         false);
//                                   } else if (orderBilledResponse.statusCode ==
//                                       400) {
//                                     var message = jsonDecode(
//                                         await orderBilledResponse.stream
//                                             .bytesToString());
//                                     await showAlertDialog(
//                                         context,
//                                         message['message'].toString(),
//                                         "Continue",
//                                         false);
//                                   } else if (orderBilledResponse.statusCode ==
//                                       500) {
//                                     var message = jsonDecode(
//                                         await orderBilledResponse.stream
//                                             .bytesToString());
//                                     await showAlertDialog(context,
//                                         message['message'], "Continue", false);
//                                   } else {
//                                     var message = jsonDecode(
//                                         await orderBilledResponse.stream
//                                             .bytesToString());
//                                     await showAlertDialog(context,
//                                         message['message'], "Continue", false);
//                                   }
//                                 } else {
//                                   var error = responseBody['error'];
//                                   if (error != null) {
//                                     await showAlertDialog(
//                                         context,
//                                         responseBody['error']['message'],
//                                         "Continue",
//                                         false);
//                                   } else {
//                                     await showAlertDialog(
//                                         context,
//                                         responseBody['status_desc'],
//                                         "Continue",
//                                         false);
//                                   }
//                                 }
//                               } else {
//                                 showAlertDialog(
//                                   context,
//                                   "Invalid Invoice No. or no data is fetched for Invoice No : ${docnoController.text}",
//                                   "CONTINUE",
//                                   false,
//                                 );
//                               }
//                             },
//                             child: const Text(
//                               'E-Invoice',
//                               style: TextStyle(
//                                   fontSize: 20,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.white),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   )
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   bool tokenExpired(String? expiry) {
//     bool timeOkay = true;
//     if (checkForEmptyOrNullString(expiry)) {
//       DateTime targetTime = DateTime.parse(expiry!);
//
//       final now = DateTime.now();
//       if (now.isBefore(targetTime.add(const Duration(seconds: 1)))) {
//         timeOkay = false;
//       }
//     }
//     return timeOkay;
//   }
// }
