import 'package:flutter/material.dart';

class ChatTile extends StatelessWidget {
  final String name;
  final String message;
  final String sender;
  const ChatTile({
    super.key,
    required this.name,
    required this.message,
    required this.sender,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, 'Chat', arguments: [name, sender]);
      },
      child: ListTile(
        leading: const Icon(Icons.person),
        title: Text(sender),
        subtitle: Text(message),
      ),
    );
  }
}
