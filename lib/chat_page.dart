import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'firebase_storage.dart';

class ChatPage extends StatefulWidget {
  final String messageTo;

  const ChatPage({Key? key, required this.messageTo}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  String message = '';
  List<dynamic> chatHistory = [];

  getChatHistory() async {
    var data = await FirebaseStorage('${FirebaseAuth.instance.currentUser?.uid}').getChatData();
    if (data != null) {
      chatHistory.addAll(data['ChatHistory']);
      print(chatHistory);
    }
  }

  @override
  void initState() {
    getChatHistory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text('Chat')),
      body: GestureDetector(
        child: Column(children: [
          Expanded(
              child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  itemCount: chatHistory.length,
                  itemBuilder: (context, index) {
                    if (FirebaseAuth.instance.currentUser?.uid ==
                        chatHistory[index].toString().split('-').first) {
                      return Container(
                          alignment: Alignment.centerRight,
                          margin: const EdgeInsets.only(bottom: 5, left: 50, right: 10),
                          width: 400,
                          child: Text(chatHistory[index].toString().split('-')[1],
                              style: const TextStyle(fontSize: 20)));
                    } else {
                      return Container(
                          alignment: Alignment.centerLeft,
                          margin: const EdgeInsets.only(bottom: 5, right: 60, left: 5),
                          width: 400,
                          child: Text(chatHistory[index].toString().split('-')[1],
                              style: const TextStyle(fontSize: 20)));
                    }
                  })),
          TextField(
              enableInteractiveSelection: true,
              textCapitalization: TextCapitalization.characters,
              textInputAction: TextInputAction.none,
              onChanged: (text) {
                setState(() {
                  message = text;
                });
              },
              style: const TextStyle(color: Colors.white, fontSize: 22),
              decoration: InputDecoration(
                  suffixIcon: GestureDetector(
                      onTap: () async {
                        chatHistory.clear();
                        var data =
                            await FirebaseStorage('${FirebaseAuth.instance.currentUser?.uid}').getChatData();

                         if (data != null) {
                           chatHistory.addAll(data['ChatHistory']);
                           chatHistory
                               .add('${FirebaseAuth.instance.currentUser?.uid}-$message-${widget.messageTo}');
                           FirebaseStorage('${FirebaseAuth.instance.currentUser?.uid}')
                               .uploadAndUpdateChat(chatHistory);

                        } else {
                          chatHistory
                              .add('${FirebaseAuth.instance.currentUser?.uid}-$message-${widget.messageTo}');
                          FirebaseStorage('${FirebaseAuth.instance.currentUser?.uid}')
                              .uploadAndUpdateChat(chatHistory);
                        }
                        var chatData =
                            await FirebaseStorage('${FirebaseAuth.instance.currentUser?.uid}').getChatData();
                        if (chatData != null) {
                          setState(() {
                            chatHistory.addAll(data['ChatHistory']);
                          });
                        }
                      },
                      child: const Icon(Icons.send, color: Color(0xFF9E824F), size: 30)),
                  filled: true,
                  fillColor: Colors.grey,
                  border: OutlineInputBorder(
                      borderSide: BorderSide.none, borderRadius: BorderRadius.circular(15)),
                  hintText: 'Send message')),
          const SizedBox(height: 4)
        ]),
        onTap: () {
          FocusScope.of(context).unfocus();
        },
      ),
    );
  }
}
