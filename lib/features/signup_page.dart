import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:internship_tracker/core/app_theme.dart';
import 'package:internship_tracker/core/widgets/form.dart';
import 'package:internship_tracker/core/widgets/item_weidgt.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:internship_tracker/features/home_page.dart';
import 'package:internship_tracker/features/login_page.dart';
import 'package:internship_tracker/main.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});
  @override
  State<SignUp> createState() => _SignUpState();
}

Future<Map<String, dynamic>> registerUser(Map<String, dynamic> data) async {
  try {
    final response = await http.post(
      Uri.parse("http://10.0.2.2:3000/auth/signup"),
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

class _SignUpState extends State<SignUp> {
  final nickname = TextEditingController();
  final password1 = TextEditingController();
  final password2 = TextEditingController();
  final email = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text("Register", style: styleText(25, FontWeight.w800)),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Field(
              fieldName: "Enter your NickName",
              hintText: "MO",
              controller: nickname,
            ),
            const SizedBox(height: 25),
            Field(
              fieldName: "Enter your Email",
              hintText: "Mo@gmail.com",
              controller: email,
            ),
            const SizedBox(height: 25),
            Field(
              fieldName: "Enter your password",
              hintText: "*********",
              controller: password1,
              password: true,
            ),
            const SizedBox(height: 25),
            Field(
              fieldName: "Re-enter your password",
              hintText: "*********",
              controller: password2,
              password: true,
            ),
            const SizedBox(height: 30),
            GestureDetector(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: const BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: const Text(
                  "Sign Up",
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
                if (nickname.text.trim().isNotEmpty &&
                    password1.text.trim().isNotEmpty &&
                    password2.text.trim().isNotEmpty &&
                    email.text.trim().isNotEmpty) {
                  if (email.text.trim().endsWith("@gmail.com")) {
                    if (password1.text.trim() == password2.text.trim()) {
                      final data = {
                        "nickname": nickname.text.trim(),
                        "email": email.text.trim(),
                        "password": password1.text.trim(),
                      };

                      final result = await registerUser(data);

                      if (result["success"] == true) {
                        await storage.write(
                          key: 'token',
                          value: result["token"],
                        );
                        nickName = result["nickname"];
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
                        "Passwords don't match",
                        Icons.password,
                      );
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
                text: "have an account? ",
                style: styleText(
                  15,
                  FontWeight.w500,
                ).copyWith(color: AppTheme.grayDark),
                children: [
                  TextSpan(
                    text: "Sign in",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => SignIn()),
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
