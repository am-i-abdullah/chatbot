import 'package:bot/models/message.dart';
import 'package:flutter/material.dart';

class MessageTile extends StatelessWidget {
  const MessageTile({super.key, required this.instance});
  final Message instance;
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // icon -- model
        if (!instance.isUser)
          Container(
            padding: const EdgeInsets.all(4),
            width: MediaQuery.of(context).size.width * 0.1,
            child: Image.asset('assets/chatbot.png'),
          ),

        // instance text
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: Colors.purple.shade50,
              borderRadius: BorderRadius.circular(5),
            ),
            child: ListTile(
              title: Text(
                instance.message,
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ),
        ),
        // icon -- user
        if (instance.isUser)
          Container(
            padding: const EdgeInsets.all(5),
            width: MediaQuery.of(context).size.width * 0.1,
            child: Image.asset('assets/user.png'),
          ),
      ],
    );
  }
}
