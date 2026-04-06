// import 'dart:convert';
//
// import 'package:fintech_new_web/features/colorCode/provider/color_provider.dart';
// import 'package:fintech_new_web/features/utility/global_variables.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:http/http.dart' as http;
//
// import 'common/widgets/comman_appbar.dart';
//
//
// class DynamicJson extends StatefulWidget {
//   static String routeName = "/djson";
//   const DynamicJson({super.key});
//
//   @override
//   State<DynamicJson> createState() => _DynamicJsonState();
// }
//
// class _DynamicJsonState extends State<DynamicJson> {
//   @override
//   void initState() {
//     ColorProvider provider = Provider.of<ColorProvider>(context, listen: false);
//     provider.buildDynamicDataTable();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<ColorProvider>(
//         builder: (context, provider, child) {
//           return Scaffold(
//             appBar: PreferredSize(
//                 preferredSize:
//                 Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
//                 child: const CommonAppbar(title: 'Dynamic Tables from Dynamic Json.')),
//             body: SingleChildScrollView(
//               child: Center(
//                 child: Container(
//                   decoration: BoxDecoration(
//                       border: Border.all(width: 2, color: Colors.white54)),
//                   padding: const EdgeInsets.only(
//                       top: 10, bottom: 10, right: 20, left: 20),
//                   width: kIsWeb
//                       ? GlobalVariables.deviceWidth / 2.0
//                       : GlobalVariables.deviceWidth,
//                   child: Column(
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.only(top: 5, bottom: 5),
//                         child: ListView.builder(
//                           itemCount: provider.testWidgetList.length,
//                           physics: const ClampingScrollPhysics(),
//                           scrollDirection: Axis.vertical,
//                           shrinkWrap: true,
//                           itemBuilder: (context, index) {
//                             return provider.testWidgetList[index];
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           );
//         });
//   }
// }
