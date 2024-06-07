import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:invoice/view_models/account_view_model.dart';

enum Language {
  Vietnamese,
  English,
}

Language currentLanguage = Language.Vietnamese;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _username = TextEditingController();
  TextEditingController _password = TextEditingController();

  void toggleLanguage() {
    if (currentLanguage == Language.Vietnamese) {
      currentLanguage = Language.English;
    } else {
      currentLanguage = Language.Vietnamese;
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
  }

  bool isValidPhoneNumber(String input) {
    RegExp regex = RegExp('/([3|5|7|8|9])+([0-9]{8})\b/g');
    if (regex.hasMatch(input)) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    // GlobalKey<FormState> phoneKey = GlobalKey<FormState>();
    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      // key: phoneKey,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          children: [
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.logout),
                      onPressed: () {
                        Get.find<AccountViewModel>().signOut();
                      },
                    )
                  ],
                ),
                TextButton(
                  onPressed: toggleLanguage,
                  child: Text(
                    currentLanguage == Language.Vietnamese
                        ? "English"
                        : "Tiếng Việt",
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              "Login",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(20),
              child: TextFormField(
                controller: _username,
                decoration: const InputDecoration(
                  labelText: "Username",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter country code";
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: TextFormField(
                controller: _password,
                decoration: const InputDecoration(
                  labelText: "Password",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter phone number";
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Get.find<AccountViewModel>().onLogin(
                  _username.text,
                  _password.text,
                );
              },
              child: const Text("Login"),
            ),
          ],
        ),
      ),
    );
  }
}
