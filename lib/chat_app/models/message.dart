
import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String text;
  final String senderName;
  final String senderId;
  final Timestamp timestamp;

  Message({
    required this.text,
    required this.senderName,
    required this.senderId,
    required this.timestamp,
  });

  factory Message.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Message(
      text: data['text'] ?? '',
      senderName: data['senderName'] ?? '',
      senderId: data['senderId'] ?? '',
      timestamp: data['timestamp'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'senderName': senderName,
      'senderId': senderId,
      'timestamp': timestamp,
    };
  }
}
