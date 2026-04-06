import 'dart:convert';

import 'package:fintech_new_web/features/auth/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:provider/provider.dart';
import 'package:pinput/pinput.dart';
import 'package:http/http.dart' as http;
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/widgets/comman_appbar.dart';
import '../../common/widgets/pop_ups.dart';
import '../../home.dart';
import '../../utility/global_variables.dart';

class Register2fa extends StatefulWidget {
  static String routeName = 'register2fa';
  final String qrUrl;
  const Register2fa({super.key, required this.qrUrl});

  @override
  State<Register2fa> createState() => _Register2faState();
}

class _Register2faState extends State<Register2fa> {
  final TextEditingController otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(builder: (context, provider, child) {
      return Scaffold(
        appBar: PreferredSize(
            preferredSize:
                Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
            child: const CommonAppbar(title: 'Enable 2FA Authentication')),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Scan this barcode with your app",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                "Scan the image below with the two-factor authentication app on your phone. If you can't use the barcode, enter this text code instead.",
              ),
              const SizedBox(height: 20),
              Center(
                child: QrImageView(
                  data: widget.qrUrl,
                  version: QrVersions.auto,
                  size: 200.0,
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                "Enter the six-digit code from the application",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                "After scanning the barcode, the app will display a six-digit code that you can enter below.",
              ),
              const SizedBox(height: 10),
              Pinput(
                length: 6,
                controller: otpController,
                defaultPinTheme: PinTheme(
                  width: 50,
                  height: 50,
                  textStyle: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: GlobalVariables.deviceWidth/2,
                child: ElevatedButton(
                  onPressed: () async {
                    // Handle OTP verification logic
                    http.StreamedResponse result =
                        await provider.verifyOtp(otpController.text);
                    var data = jsonDecode(await result.stream.bytesToString());
                    if (result.statusCode == 200) {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.setString("auth_token", data['access']);
                      prefs.setString("currentLoginId", data['userId']);
                      prefs.setString("currentLoginCid", data['cid']);
                      prefs.setString("userData", jsonEncode(data));
                      provider.reset();
                      context.goNamed(HomePageScreen.routeName);
                    } else if (result.statusCode == 401) {
                      await showAlertDialog(
                          context, data['error'], "Continue", false);
                    } else {
                      await showAlertDialog(
                          context, data['message'], "Continue", false);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)))),
                  child: const Text("Verify",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                          color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
