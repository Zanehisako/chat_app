import 'package:chat_app/componets/chat_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Chatrooms extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final recivedData =
        ModalRoute.of(context)!.settings.arguments as List<String>;
    final username = recivedData.first;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Chats",
          style: TextStyle(fontSize: 20),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, 'AddChat', arguments: [username]);
            },
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('ChatRooms')
            .where('Persones', arrayContains: username)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            var data = snapshot.data!.docs;
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                var message = data[index]["message"];
                final List<dynamic> persones = data[index]["Persones"];
                var name = persones.firstWhere(
                  (element) => element != username,
                );

                return ChatTile(
                  name: username,
                  sender: name,
                  message: message,
                );
              },
            );
          }
        },
      ),
    );
  }
}
