import 'dart:convert';

import 'package:fintech_new_web/features/auth/screen/login.dart';
import 'package:fintech_new_web/features/network/service/network_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../common/widgets/pop_ups.dart';
import '../provider/auth_provider.dart';
import 'package:http/http.dart' as http;

class UpdatePassword extends StatelessWidget {
  static String routeName = 'updatePassword';
  final String email;
  const UpdatePassword({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    TextEditingController tokenController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    return Consumer<AuthProvider>(builder: (context, provider, child) {
      return Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Password Reset',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),
                Container(
                  padding: const EdgeInsets.all(24),
                  width: 500,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Forgot Password',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Please confirm your email address via which your account is registered.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: tokenController,
                        decoration: const InputDecoration(
                          hintText: 'Token',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          hintText: 'New Password',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            var headers = {'Content-Type': 'application/json'};
                            var request = http.Request(
                                'POST',
                                Uri.parse(
                                    "${NetworkService.baseUrl}/user/update-password/"));
                            request.body = jsonEncode({
                              "email": email,
                              "new_password": passwordController.text,
                              "token": tokenController.text
                            });
                            request.headers.addAll(headers);
                            http.StreamedResponse result = await request.send();

                            var message =
                                jsonDecode(await result.stream.bytesToString());
                            if (result.statusCode == 200) {
                              await showAlertDialog(
                                  context,
                                  "Your new password is ready. Try to login again.",
                                  "Continue",
                                  false);
                              context.pushNamed(LoginScreen.routeName);
                            } else if (result.statusCode == 400) {
                              await showAlertDialog(
                                  context,
                                  message['message'].toString(),
                                  "Continue",
                                  false);
                            } else if (result.statusCode == 500) {
                              await showAlertDialog(context, message['message'],
                                  "Continue", false);
                            } else {
                              await showAlertDialog(context, message['message'],
                                  "Continue", false);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF007BFF),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: const Text('Reset Password',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500)),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      );
    });
  }
}
