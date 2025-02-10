import 'dart:io';

import 'package:google_generative_ai/google_generative_ai.dart';

class Ai {

  Future<void> AiModel() async {
    final apiKey = Platform.environment['GEMINI_API_KEY'];
    if (apiKey == null) {
      stderr.writeln(r'No $GEMINI_API_KEY environment variable');
      exit(1);
    }

    final model = GenerativeModel(
      model: 'gemini-2.0-flash-exp',
      apiKey: apiKey,
      generationConfig: GenerationConfig(
        temperature: 1,
        topK: 40,
        topP: 0.95,
        maxOutputTokens: 8192,
        responseMimeType: 'text/plain',
      ),
    );

    final chat = model.startChat(history: [
    ]);
    final message = 'INSERT_INPUT_HERE';
    final content = Content.text(message);

    final response = await chat.sendMessage(content);
    print(response.text);
  }
}