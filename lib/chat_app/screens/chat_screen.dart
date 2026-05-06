
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/message.dart';
import '../services/auth_service.dart';
import '../services/chat_service.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  final chatService = ChatService();
  final authService = AuthService();
  final messageController = TextEditingController();
  final scrollController = ScrollController();

  void sendMessage() {
    if (messageController.text.trim().isNotEmpty) {
      chatService.sendMessage(messageController.text.trim());
      messageController.clear();
      // Scroll to the bottom after sending a message
      scrollToBottom();
    }
  }

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Real-Time Chat'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => authService.signOut(),
            tooltip: 'Sign Out',
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Message>>(
              stream: chatService.getMessages(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No messages yet. Say hi!'));
                }

                final messages = snapshot.data!;
                scrollToBottom(); // Scroll to bottom when new messages arrive

                return ListView.builder(
                  controller: scrollController,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final isMe = message.senderId == currentUser?.uid;

                    return buildMessageBubble(message, isMe);
                  },
                );
              },
            ),
          ),
          buildMessageInputField(),
        ],
      ),
    );
  }

  Widget buildMessageBubble(Message message, bool isMe) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isMe ? Colors.blue[100] : Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.senderName,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
            const SizedBox(height: 4),
            Text(message.text),
          ],
        ),
      ),
    );
  }

  Widget buildMessageInputField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: messageController,
              decoration: const InputDecoration(
                hintText: 'Enter a message...',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => sendMessage(),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: Colors.blue),
            onPressed: sendMessage,
          ),
        ],
      ),
    );
  }
}
