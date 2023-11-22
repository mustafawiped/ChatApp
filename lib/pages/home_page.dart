import 'package:chatapp/pages/chat_page.dart';
import 'package:chatapp/services/auth/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // firebase auth
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // çıkış yap
  void signOut() {
    // auth servisini çek
    final authService = Provider.of<AuthService>(context, listen: false);

    authService.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
        actions: [
          //çıkış yap butonu
          IconButton(onPressed: signOut, icon: const Icon(Icons.logout))
        ],
      ),
      body: _buildUserList(),
    );
  }

  // kullanıcı listesini oluştur
  Widget _buildUserList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection("users").snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text("Hata!");
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Yükleniyor..");
        }

        return ListView(
          children: snapshot.data!.docs
              .map<Widget>((doc) => _buildUserListItem(doc))
              .toList(),
        );
      },
    );
  }

  // Liste itemlerini olusturuyoruz.
  Widget _buildUserListItem(DocumentSnapshot document) {
    Map<String, dynamic> datas = document.data()! as Map<String, dynamic>;

    // tüm kullanıcıları listelioz
    if (_auth.currentUser!.email != datas["email"]) {
      return ListTile(
        title: Text(datas["email"]),
        onTap: () {
          // mesajlaşmaya git.
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                  receiverUserEmail: datas["email"],
                  receiverUserID: datas["uid"]),
            ),
          );
        },
      );
    } else {
      // boş container dönder.
      return Container();
    }
  }
}
