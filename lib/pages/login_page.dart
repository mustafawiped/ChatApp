import 'package:chatapp/components/button_style1.dart';
import 'package:chatapp/components/text_field.dart';
import 'package:chatapp/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // text kontrolcüleri
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // giriş yapma fonksiyonu
  void signIn() async {
    // giriş yap
    final authService = Provider.of<AuthService>(context, listen: false);

    try {
      await authService.signInWithEmailanPassword(
          emailController.text, passwordController.text);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
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

                // tekrar hoşgeldin mesajı
                const Text(
                  "Hoşgeldin! Seni tekrar görmek güzel.",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),

                const SizedBox(
                  height: 25,
                ),

                // eposta text field i
                createTextField(
                    controller: emailController,
                    hintText: "Eposta",
                    obscureText: false),

                const SizedBox(
                  height: 10,
                ),

                // şifre text field i
                createTextField(
                    controller: passwordController,
                    hintText: "Şifre",
                    obscureText: true),

                const SizedBox(
                  height: 25,
                ),

                // giriş yap butonu
                createButtonStyle1(onTap: signIn, text: "Giriş Yap"),

                const SizedBox(
                  height: 50,
                ),

                // üye değil misin hemen kayıt ol widget ları
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Üye değil misin?",
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        "Hemen Kayıt ol!",
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
