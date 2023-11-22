import 'package:chatapp/model/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatService extends ChangeNotifier {
  // instance yi çekelim.
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  // Mesaj Gönder
  Future<void> sendMessage(String receiverId, String msg) async {
    // güncel kullanıcı bilgisini al
    final String currentUserId = _firebaseAuth.currentUser!.uid;
    final String currentUserEmail = _firebaseAuth.currentUser!.email.toString();
    final Timestamp timestamp = Timestamp.now();

    // yeni mesaj oluştur
    Message newMessage = Message(
        senderId: currentUserId,
        senderEmail: currentUserEmail,
        receiverId: receiverId,
        message: msg,
        timestamp: timestamp);

    // kullanıcı id sinden ve alıcı id sinden sohbet odası oluştur
    List<String> ids = [currentUserId, receiverId];
    ids.sort(); // id leri sırala (Bu çift kişi için de her zaman aynı olmasını sağlar.)
    String chatRoomId = ids.join("_"); // birleştirme işlemi.

    // yeni mesajı veritabanına ekle
    await _fireStore
        .collection("chat_rooms")
        .doc(chatRoomId)
        .collection("messages")
        .add(newMessage.toMap());
  }

  // Mesajları Çek
  Stream<QuerySnapshot> getMessages(String userId, String otherUserId) {
    // kullanıcı kimliklerinden sohbet odası kimliği oluşturma (mesaj gönderirken kullanıcı kimliği ile eşleştiğinden emin olmak için sıralanır)
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join("_");

    return _fireStore
        .collection("chat_rooms")
        .doc(chatRoomId)
        .collection("messages")
        .orderBy("timestamp", descending: false)
        .snapshots();
  }
}
