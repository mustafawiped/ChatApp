import 'package:chatapp/components/button_style1.dart';
import 'package:chatapp/components/text_field.dart';
import 'package:chatapp/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;
  const RegisterPage({super.key, this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // text controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // signUp user
  void signUp() async {
    if (passwordController.text.isEmpty ||
        confirmPasswordController.text != passwordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Şifre tekrarı birbirleriyle aynı değil"),
        ),
      );
      return;
    }

    // auth servisini çek
    final authService = Provider.of<AuthService>(context, listen: false);
    try {
      await authService.signUpWithEmailandPassword(
          emailController.text, passwordController.text);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Hata! ${e.toString()}"),
        ),
      );
    }

    // Videonun tam 21:00 ında kaldık.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 50,
                ),
                // logo
                Icon(
                  Icons.message,
                  size: 100,
                  color: Colors.grey.shade800,
                ),

                const SizedBox(
                  height: 50,
                ),

                // create account message
                const Text(
                  "Hadi senin için hesap oluşturalım!",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),

                const SizedBox(
                  height: 25,
                ),

                // email textfied
                createTextField(
                    controller: emailController,
                    hintText: "Eposta",
                    obscureText: false),

                const SizedBox(
                  height: 10,
                ),

                // password textfield
                createTextField(
                    controller: passwordController,
                    hintText: "Şifre",
                    obscureText: true),

                const SizedBox(
                  height: 10,
                ),

                // password again textfield
                createTextField(
                    controller: confirmPasswordController,
                    hintText: "Şifre Tekrarı",
                    obscureText: true),

                const SizedBox(
                  height: 25,
                ),

                // sign up button
                createButtonStyle1(onTap: signUp, text: "Kayıt Ol"),

                const SizedBox(
                  height: 50,
                ),

                // not a member? register now
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Zaten hesabın var mı?",
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        "Giriş Yap!",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
