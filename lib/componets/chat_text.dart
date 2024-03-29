// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

enum UserType { sender, receiver }

class ChatText extends StatelessWidget {
  String text;
  UserType type;

  ChatText({super.key, required this.text, required this.type});

  @override
  Widget build(BuildContext context) {
    if (type == UserType.receiver) {
      return Text(
        text,
        style: const TextStyle(backgroundColor: Colors.blue, fontSize: 20),
      );
    } else {
      return Text(
        text,
        style: const TextStyle(backgroundColor: Colors.red, fontSize: 20),
      );
    }
  }
}
