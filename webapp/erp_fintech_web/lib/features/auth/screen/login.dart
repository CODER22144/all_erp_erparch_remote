// ignore_for_file: use_build_context_synchronously
import 'dart:convert';

import 'package:fintech_new_web/features/auth/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/widgets/pop_ups.dart';
import '../../home.dart';
import '../../utility/global_variables.dart';
import 'forget_password.dart';

class LoginScreen extends StatefulWidget {
  static String routeName = "/login";

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AuthProvider>(context, listen: false);
    return Material(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              child: Image.asset("assets/login.png", height: GlobalVariables.deviceHeight*0.50),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 29, vertical: 10),
              child: Text(
                "Login Details",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    fontFamily: "Outfit-SemiBold"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 29, vertical: 10),
              child: Form(
                key: provider.formKey,
                child: Column(
                  children: [
                    TextFormField(
                        controller: provider.usernameController,
                        decoration: const InputDecoration(
                          labelText: "Username",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(5),
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter you username';
                          }
                          return null;
                        }),
                    const SizedBox(height: 20),
                    TextFormField(
                        controller: provider.passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: "Password",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(5),
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter you password';
                          }
                          return null;
                        }),
                    const SizedBox(height: 5),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: InkWell(
                        onTap: () {
                          context.pushNamed(ForgetPassword.routeName);
                        },
                        child: const Text(
                          "Forget Password",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: HexColor("#0B6EFE"),
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)))),
                        onPressed: () async {
                          setState(() {
                            loading = true;
                          });
                          if (provider.formKey.currentState!.validate()) {
                            http.StreamedResponse result =
                                await provider.login();
                            if (result.statusCode == 200) {
                              // context
                              //     .pushNamed(OTPVerificationScreen.routeName);
                              var data = jsonDecode(
                                  await result.stream.bytesToString());
                              SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                              prefs.setString("auth_token", data['access']);
                              prefs.setString("currentLoginId", data['userId']);
                              prefs.setString("currentLoginCid", data['cid']);
                              prefs.setString("userData", jsonEncode(data));
                              provider.reset();
                              context.goNamed(HomePageScreen.routeName);
                            }
                            // else if (result.statusCode == 204) {
                            //   http.StreamedResponse response =
                            //       await provider.register_2FA();
                            //   if (response.statusCode == 201) {
                            //     var data = jsonDecode(
                            //         await response.stream.bytesToString());
                            //     context.pushNamed(Register2fa.routeName,
                            //         queryParameters: {
                            //           "qrUrl": data['otp_auth_url']
                            //         });
                            //   }
                            // }
                            else {
                              var message = jsonDecode(
                                  await result.stream.bytesToString());
                              await showAlertDialog(context, message['message'],
                                  "Continue", false);
                            }
                          }
                          setState(() {
                            loading = false;
                          });
                        },
                        child: loading
                            ? const SpinKitFadingCircle(
                                color: Colors.white,
                                size: 25,
                              )
                            : const Text(
                                'Login',
                                style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
