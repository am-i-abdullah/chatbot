import 'dart:io';

class Message {
  final bool isUser;
  final String message;
  final File? imageFile;

  Message({
    required this.isUser,
    required this.message,
    this.imageFile,
  });
}
