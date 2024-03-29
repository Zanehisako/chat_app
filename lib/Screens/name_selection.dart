import 'package:flutter/material.dart';

class NameSelection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextEditingController _nameController = TextEditingController();
    return Scaffold(
      body: Center(
          child: Padding(
        padding: const EdgeInsets.all(100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Enter Your name:'),
            TextField(
              onSubmitted: (value) {
                Navigator.pushNamed(context, 'ChatScreen', arguments: [value]);
                _nameController.clear();
              },
              controller: _nameController,
            )
          ],
        ),
      )),
    );
  }
}
