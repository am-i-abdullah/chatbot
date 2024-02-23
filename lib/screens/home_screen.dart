import 'dart:io';

import 'package:bot/api/send_request.dart';
import 'package:bot/models/message.dart';
import 'package:bot/widgets/message_tile.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController messageController = TextEditingController();
  // messages to be displayed on screen
  List<Message> chat = [];
  File? pickedImageFile;

  void pickImage() async {
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (pickedImage == null) return;

    setState(() {
      pickedImageFile = File(pickedImage.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Chat Name",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.purple.shade700,
      ),
      body: Column(
        children: [
          Expanded(
            child: chat.isEmpty
                ? const Center(
                    child: Text('Start Chatting, nothing yet '),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(
                      left: 15,
                      right: 15,
                      bottom: 15,
                    ),
                    reverse: true,
                    itemCount: chat.length,
                    itemBuilder: (context, index) {
                      return MessageTile(
                          instance: chat.reversed.toList()[index]);
                    },
                  ),
          ),

          // message sending mechanism
          Container(
            color: Colors.purple.shade50,
            padding: const EdgeInsets.only(
              left: 20,
              right: 10,
              bottom: 20,
              top: 10,
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    minLines: 1,
                    maxLines: 4,
                    controller: messageController,
                    decoration: const InputDecoration(
                        hintText: 'Enter Message to Send: '),
                  ),
                ),

                // image selection button
                IconButton(
                  onPressed: () async {
                    // add or remove image
                    pickImage();
                  },
                  icon: Icon(pickedImageFile == null
                      ? Icons.image
                      : Icons.image_not_supported_outlined),
                ),

                // message sending button
                IconButton(
                  onPressed: () async {
                    setState(() {
                      chat.add(Message(
                        isUser: true,
                        message: messageController.text,
                        imageFile: pickedImageFile,
                      ));
                    });

                    // prompting
                    try {
                      String response = await sendRequest(chat);

                      setState(() {
                        chat.add(Message(
                          isUser: false,
                          message: response,
                        ));
                      });
                    } catch (error) {
                      chat.removeAt(0);
                    }
                  },
                  icon: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
