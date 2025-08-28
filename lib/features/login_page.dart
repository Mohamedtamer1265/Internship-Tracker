import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:internship_tracker/core/app_theme.dart';
import 'package:internship_tracker/core/widgets/item_weidgt.dart';
import 'package:internship_tracker/core/widgets/form.dart';
import 'package:internship_tracker/features/home_page.dart';
import 'package:internship_tracker/features/signup_page.dart';
import 'package:internship_tracker/main.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

Future<Map<String, dynamic>> sign(Map<String, dynamic> data) async {
  try {
    final response = await http.post(
      Uri.parse("http://10.0.2.2:3000/auth/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      return decoded;
    } else {
      return {
        "success": false,
        "message": "Server error: ${response.statusCode}",
      };
    }
  } catch (e) {
    return {"success": false, "message": "Exception: $e"};
  }
}

class _SignInState extends State<SignIn> {
  @override
  Widget build(BuildContext context) {
    final password = TextEditingController();
    final email = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text("Login", style: styleText(25, FontWeight.w800)),
        ),
      ),
      /*
      2 options 
      1- center the singleChildScrollView
      2- without scrolling using mainAxis and crossAxis
       */
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/photos/login_vector.png", height: 300),
            Field(
              fieldName: "Enter your Email",
              hintText: "Mo@gmail.com",
              controller: email,
            ),
            const SizedBox(height: 25),
            Field(
              fieldName: "Enter your password",
              hintText: "*********",
              controller: password,
              password: true,
            ),
            const SizedBox(height: 25),
            GestureDetector(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: const BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: const Text(
                  "Sign In",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'SFProDisplay',
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              onTap: () async {
                if (email.text.trim().isNotEmpty &&
                    password.text.trim().isNotEmpty) {
                      
                  if (email.text.trim().endsWith("@gmail.com")) {
                    final data = {
                      "email": email.text.trim(),
                      "password": password.text.trim(),
                    };
                    final result = await sign(data);
                    if (result["success"] == true) {
                      print(result);
                      await storage.write(key: 'token', value: result["token"]);
                      nickName = result["nickname"]??"";

                      if (context.mounted) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                HomePage(token: result["token"]),
                          ),
                        );
                      }
                    } else {
                      if (context.mounted) {
                        showNicePopup(
                          context,
                          "Error",
                          result["message"] ?? "Unknown error",
                          Icons.error,
                        );
                      }
                    }
                  } else {
                    showNicePopup(
                      context,
                      "Warning",
                      "Email should end with @gmail.com",
                      Icons.email,
                    );
                  }
                } else {
                  showNicePopup(
                    context,
                    "Warning",
                    "Fill all the fields",
                    Icons.warning_amber_sharp,
                  );
                }
              },
            ),
            SizedBox(height: 15),
            Text.rich(
              TextSpan(
                text: "Don't have an account? ",
                style: styleText(
                  15,
                  FontWeight.w500,
                ).copyWith(color: AppTheme.grayDark),
                children: [
                  TextSpan(
                    text: "Sign up",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => SignUp()),
                        );
                      },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
