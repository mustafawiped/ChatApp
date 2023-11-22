import 'package:chatapp/pages/home_page.dart';
import 'package:chatapp/services/login_or_register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // kullanıcı eğer giriş yapmışsa
          if (snapshot.hasData) {
            return const HomePage();
          }

          // kullanıcı giriş yapmmamışsa
          else {
            return const LoginOrRegister();
          }
        },
      ),
    );
  }
}
