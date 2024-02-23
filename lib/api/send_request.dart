import 'package:bot/models/message.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<String> sendRequest(List<Message> chat) async {
  String apiKey = dotenv.env['API_KEY']!;

  Dio dio = Dio();

  List<Map<String, dynamic>> contents = [];

  // for chatting
  for (Message message in chat) {
    contents.add({
      'role': message.isUser ? 'user' : 'model',
      'parts': [
        {
          "text": message.message,
        },
      ]
    });
  }

  final Response response;
  String generatedText = 'abc';
  try {
    final requestBody = {
      "contents": contents,
    };
    response = await dio.post(
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=$apiKey',
      data: requestBody,
    );

    generatedText =
        response.data['candidates'][0]['content']['parts'][0]['text'];
  } catch (error) {
    return error.toString();
  } finally {}

  return generatedText;
}
