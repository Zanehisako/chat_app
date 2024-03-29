// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:chat_app/componets/chat_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class ChatScaffold extends StatefulWidget {
  List<QueryDocumentSnapshot<Map<String, dynamic>>> data;
  final String username;
  final String sender;

  ChatScaffold(
      {required this.data, required this.username, required this.sender});

  @override
  State<ChatScaffold> createState() => _ChatScaffoldState();
}

class _ChatScaffoldState extends State<ChatScaffold> {
  Future Pickfile() async {
    var result = await FilePicker.platform.pickFiles(allowMultiple: false);
    setState(() {
      chatIMG = File(result!.paths.first!);
      _fileopened = true;
    });
  }

  TextEditingController _messageController = TextEditingController();

  bool _fileopened = false;

  File? chatIMG;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.sender),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios_new)),
      ),
      body: _fileopened == true
          ? Image.file(chatIMG!)
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    reverse: true,
                    itemCount: widget.data.length,
                    itemBuilder: (context, index) {
                      var messages = widget.data[index]['message'];
                      var sender = widget.data[index]['Sender'];

                      if (sender == widget.username) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ChatText(
                              text: messages,
                              type: UserType.receiver,
                            ),
                          ],
                        );
                      } else {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ChatText(
                              text: messages,
                              type: UserType.sender,
                            ),
                          ],
                        );
                      }
                    },
                  ),
                ),
                BottomAppBar(
                  clipBehavior: Clip.hardEdge,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                          onPressed: () {
                            Pickfile();
                          },
                          icon: Icon(Icons.add)),
                      Container(
                        width: 250,
                        child: TextField(
                          maxLength: null,
                          textInputAction: TextInputAction.send,
                          showCursor: true,
                          controller: _messageController,
                          onSubmitted: (value) {
                            SendMessage(value, widget.username, widget.sender);
                            _messageController.clear();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

void SendMessage(String message, String sender, String receiver) async {
  await FirebaseFirestore.instance.collection('Messages').add({
    'Persones': [receiver, sender],
    'Reciver': receiver,
    'Sender': sender,
    'message': message,
    'time': FieldValue.serverTimestamp(),
  });
}

List<QueryDocumentSnapshot<Map<String, dynamic>>> Mergedata(
  List<QueryDocumentSnapshot<Map<String, dynamic>>> docs1,
  List<QueryDocumentSnapshot<Map<String, dynamic>>> docs2,
) {
  List<QueryDocumentSnapshot<Map<String, dynamic>>> merged_docs = [];
  for (QueryDocumentSnapshot<Map<String, dynamic>> doc1 in docs1) {
    for (QueryDocumentSnapshot<Map<String, dynamic>> doc2 in docs2) {
      if (doc1.id == doc2.id) {
        merged_docs.add(doc1);
      }
    }
  }
  return merged_docs;
}

class Chat extends StatelessWidget {
  bool _isloading = true;

  @override
  Widget build(BuildContext context) {
    final recivedData =
        ModalRoute.of(context)!.settings.arguments as List<String>;
    final username = recivedData[0];
    final sender = recivedData[1];

    List<QueryDocumentSnapshot<Map<String, dynamic>>> pervouisdata = [];

    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('Messages')
          .orderBy('time', descending: true)
          .where('Persones', arrayContains: sender)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _isloading
              ? Center(
                  child: Container(
                    color: Colors.white,
                  ),
                )
              : ChatScaffold(
                  data: pervouisdata, username: username, sender: sender);
        } else {
          var data1 = snapshot.data!.docs;
          return StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('Messages')
                  .orderBy('time', descending: true)
                  .where('Persones', arrayContains: username)
                  .snapshots(),
              builder: (context, snapshot1) {
                if (snapshot1.connectionState == ConnectionState.waiting) {
                  return _isloading
                      ? Center(
                          child: Container(
                            color: Colors.white,
                          ),
                        )
                      : ChatScaffold(
                          data: pervouisdata,
                          username: username,
                          sender: sender);
                } else {
                  if (_isloading == true) {
                    _isloading = false;
                  }
                  var data2 = snapshot1.data!.docs;

                  var data = Mergedata(data1, data2);
                  pervouisdata = data;

                  return ChatScaffold(
                      data: data, username: username, sender: sender);
                }
              });
        }
      },
    );
  }
}
