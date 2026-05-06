
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/message.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionPath = 'messages';

  // Get stream of messages
  Stream<List<Message>> getMessages() {
    return _firestore
        .collection(_collectionPath)
        .orderBy('timestamp', descending: true) // Newest messages first
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Message.fromFirestore(doc)).toList();
    });
  }

  // Send a message
  Future<void> sendMessage(String text, User user) async {
    if (text.trim().isEmpty) {
      return;
    }

    await _firestore.collection(_collectionPath).add({
      'text': text,
      'userId': user.uid,
      'userName': user.displayName ?? 'Anonymous',
      'timestamp': FieldValue.serverTimestamp(), // Use server time
    });
  }
}
