import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class MessageImagePicker extends StatefulWidget {
  const MessageImagePicker({super.key, required this.onPickImage});

  final void Function(File userImage) onPickImage;

  @override
  State<MessageImagePicker> createState() => _MessageImagePickerState();
}

class _MessageImagePickerState extends State<MessageImagePicker> {
  File? pickedImageFile;

  // method to pick image
  void pickImage() async {
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );

    if (pickedImage == null) return;

    setState(() {
      pickedImageFile = File(pickedImage.path);
    });

    widget.onPickImage(pickedImageFile!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          foregroundImage:
              pickedImageFile != null ? FileImage(pickedImageFile!) : null,
        ),
        TextButton.icon(
          onPressed: pickImage,
          icon: const Icon(Icons.image),
          label: Text(
            "Add Image",
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
        )
      ],
    );
  }
}
