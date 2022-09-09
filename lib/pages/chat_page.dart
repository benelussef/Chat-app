import 'package:chat_app/constants.dart';
import 'package:chat_app/models/message.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../widgets/chat_bubble.dart';

class ChatPage extends StatelessWidget {
  ChatPage({Key? key}) : super(key: key);

  CollectionReference message =
      FirebaseFirestore.instance.collection('messages');
  TextEditingController controller = TextEditingController();
  final _controller = ScrollController();
  @override
  Widget build(BuildContext context) {
    var email = ModalRoute.of(context)!.settings.arguments;
    return StreamBuilder<QuerySnapshot>(
        stream: message.orderBy('createdAt', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Message> messagesList = [];
            for (int i = 0; i < snapshot.data!.docs.length; i++) {
              messagesList.add(Message.fromJson(snapshot.data!.docs[i]));
            }
            return Scaffold(
                appBar: AppBar(
                  backgroundColor: kPrimaryColor,
                  automaticallyImplyLeading: false,
                  title: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          kLogo,
                          height: 50,
                          width: 50,
                        ),
                        Text('Chat')
                      ]),
                ),
                body: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                          reverse: true,
                          controller: _controller,
                          itemCount: messagesList.length,
                          itemBuilder: (context, index) {
                            return messagesList[index].id == email
                                ? ChatBubble(message: messagesList[index])
                                : ChatBubbleFriend(
                                    message: messagesList[index]);
                          }),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: TextField(
                        controller: controller,
                        onSubmitted: (data) {
                          message.add({
                            'message': data,
                            'createdAt': DateTime.now(),
                            'id': email
                          });
                          controller.clear();
                          _controller.animateTo(0,
                              duration: Duration(milliseconds: 500),
                              curve: Curves.easeIn);
                        },
                        decoration: InputDecoration(
                            suffixIcon: Icon(
                              Icons.send,
                              color: kPrimaryColor,
                            ),
                            hintText: "Send Message",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                            )),
                      ),
                    )
                  ],
                ));
          } else {
            return Container();
          }
        });
  }
}
