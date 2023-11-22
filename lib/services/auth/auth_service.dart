import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService extends ChangeNotifier {
  // yetkilendirme örneği
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // firestore u yetkilendir
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  // kullanıcı girişi yap
  Future<UserCredential> signInWithEmailanPassword(
      String email, String password) async {
    try {
      // giriş yapmayı dene
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      // user collection ına eğer daha önceden eklenmediyse yeni döküman ekle
      _fireStore.collection("users").doc(userCredential.user!.uid).set(
          {"uid": userCredential.user!.uid, "email": email},
          SetOptions(merge: true));

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  // yeni kullanıcı hesabı oluştur
  Future<UserCredential> signUpWithEmailandPassword(
      String email, String password) async {
    try {
      UserCredential credential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      // kullanıcı oluşturduktan sonra, users collection da yeni bir document oluştur.
      _fireStore
          .collection("users")
          .doc(credential.user!.uid)
          .set({"uid": credential.user!.uid, "email": email});

      return credential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  // kullanıcı çıkışı yap
  Future<void> signOut() async {
    return await FirebaseAuth.instance.signOut();
  }
}
