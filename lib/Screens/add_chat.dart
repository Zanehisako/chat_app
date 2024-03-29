import 'package:chat_app/Screens/chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

void CreateChatroom(String sender, String receiver, String message) async {
  await FirebaseFirestore.instance.collection('ChatRooms').add({
    'Persones': [sender, receiver],
    'message': message,
  });
}

class AddChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final recivedData =
        ModalRoute.of(context)!.settings.arguments as List<String>;
    final sender = recivedData.first;
    String? message;
    String? name;
    TextEditingController _messageController = TextEditingController();
    TextEditingController _nameController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Message'),
        actions: [
          IconButton(
              onPressed: () {
                SendMessage(message!, sender, name!);
                CreateChatroom(sender, name!, message!);
                Navigator.pop(context);
              },
              icon: const Icon(Icons.send))
        ],
      ),
      body: Column(
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(hintText: "To:"),
            onChanged: (value) {
              name = value;
            },
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            decoration: const InputDecoration(hintText: "Message:"),
            onChanged: (value) {
              message = value;
              print(message);
            },
            controller: _messageController,
          )
        ],
      ),
    );
  }
}
