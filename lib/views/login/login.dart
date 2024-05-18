// import 'package:deer_coffee/view_models/account_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/route_constrant.dart';

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
  TextEditingController countrycode = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();

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
    countrycode.text = "+84";
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
    GlobalKey<FormState> phoneKey = GlobalKey<FormState>();
    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      key: phoneKey,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          children: [
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
                controller: countrycode,
                decoration: const InputDecoration(
                  labelText: "Country Code",
                  hintText: "+84",
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
                controller: phoneNumber,
                decoration: const InputDecoration(
                  labelText: "Phone Number",
                  hintText: "123456789",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter phone number";
                  }
                  if (!isValidPhoneNumber(value)) {
                    return "Invalid phone number";
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (phoneKey.currentState!.validate()) {
                  Get.toNamed(RouteHandler.OTP);
                }
              },
              child: const Text("Login"),
            ),
          ],
        ),
      ),
    );
  }
}
