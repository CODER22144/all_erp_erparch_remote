// import 'package:flutter/material.dart';
// import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
//
// class BarcodeScanner extends StatefulWidget {
//   static String routeName = "/barcodeScanner";
//   const BarcodeScanner({super.key});
//
//   @override
//   State<BarcodeScanner> createState() => _BarcodeScannerState();
// }
//
// class _BarcodeScannerState extends State<BarcodeScanner> {
//   String _scanResult = 'Unknown';
//
//   Future<void> startBarcodeScan() async {
//     String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
//         "#ff6666",
//         "Cancel",
//         false,
//         ScanMode.DEFAULT
//     );
//     setState(() {
//       _scanResult = barcodeScanRes;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Barcode Scanner'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Text('Scan result: $_scanResult\n'),
//             ElevatedButton(
//               onPressed: startBarcodeScan,
//               child: const Text('Start Barcode Scan'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
