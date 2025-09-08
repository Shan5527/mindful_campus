import 'package:dio/dio.dart';
import 'dart:convert';
import 'dart:io';

class GeminiClient {
  final Dio dio;
  final String apiKey;

  GeminiClient(this.dio, this.apiKey);

  Future<Completion> createChat({
    required List<Message> messages,
    String model = 'gemini-1.5-flash-002',
    int maxTokens = 1024,
    double temperature = 0.8,
  }) async {
    try {
      final contents = messages
          .map((m) => {
                'role': m.role,
                'parts': m.content is String
                    ? [
                        {'text': m.content}
                      ]
                    : m.content,
              })
          .toList();

      final response = await dio.post(
        '/models/$model:generateContent',
        queryParameters: {
          'key': apiKey,
        },
        data: {
          'contents': contents,
          'generationConfig': {
            'maxOutputTokens': maxTokens,
            'temperature': temperature,
          },
          'safetySettings': [
            {
              'category': 'HARM_CATEGORY_HARASSMENT',
              'threshold': 'BLOCK_MEDIUM_AND_ABOVE',
            },
            {
              'category': 'HARM_CATEGORY_HATE_SPEECH',
              'threshold': 'BLOCK_MEDIUM_AND_ABOVE',
            },
            {
              'category': 'HARM_CATEGORY_SEXUALLY_EXPLICIT',
              'threshold': 'BLOCK_MEDIUM_AND_ABOVE',
            },
            {
              'category': 'HARM_CATEGORY_DANGEROUS_CONTENT',
              'threshold': 'BLOCK_MEDIUM_AND_ABOVE',
            },
          ],
        },
      );

      if (response.data['candidates'] != null &&
          response.data['candidates'].isNotEmpty &&
          response.data['candidates'][0]['content'] != null) {
        final parts = response.data['candidates'][0]['content']['parts'];
        final text = parts.isNotEmpty ? parts[0]['text'] : '';
        return Completion(text: text.trim());
      } else {
        throw GeminiException(
          statusCode: response.statusCode ?? 500,
          message: 'Failed to parse response or empty response',
        );
      }
    } on DioException catch (e) {
      throw GeminiException(
        statusCode: e.response?.statusCode ?? 500,
        message: e.response?.data?['error']?['message'] ??
            e.message ??
            'Request failed',
      );
    }
  }

  Stream<String> streamChat({
    required List<Message> messages,
    String model = 'gemini-1.5-flash-002',
    int maxTokens = 1024,
    double temperature = 0.8,
  }) async* {
    try {
      final contents = messages
          .map((m) => {
                'role': m.role,
                'parts': m.content is String
                    ? [
                        {'text': m.content}
                      ]
                    : m.content,
              })
          .toList();

      final response = await dio.post(
        '/models/$model:streamGenerateContent',
        queryParameters: {
          'key': apiKey,
          'alt': 'sse',
        },
        data: {
          'contents': contents,
          'generationConfig': {
            'maxOutputTokens': maxTokens,
            'temperature': temperature,
          },
          'safetySettings': [
            {
              'category': 'HARM_CATEGORY_HARASSMENT',
              'threshold': 'BLOCK_MEDIUM_AND_ABOVE',
            },
            {
              'category': 'HARM_CATEGORY_HATE_SPEECH',
              'threshold': 'BLOCK_MEDIUM_AND_ABOVE',
            },
            {
              'category': 'HARM_CATEGORY_SEXUALLY_EXPLICIT',
              'threshold': 'BLOCK_MEDIUM_AND_ABOVE',
            },
            {
              'category': 'HARM_CATEGORY_DANGEROUS_CONTENT',
              'threshold': 'BLOCK_MEDIUM_AND_ABOVE',
            },
          ],
        },
        options: Options(responseType: ResponseType.stream),
      );

      final stream = response.data as ResponseBody;
      final buffer = StringBuffer();

      await for (var line
          in LineSplitter().bind(utf8.decoder.bind(stream.stream))) {
        if (line.startsWith('data: ')) {
          final data = line.substring(6).trim();
          if (data == '[DONE]') break;

          try {
            final json = jsonDecode(data) as Map<String, dynamic>;
            if (json.containsKey('candidates') &&
                json['candidates'].isNotEmpty &&
                json['candidates'][0].containsKey('content') &&
                json['candidates'][0]['content'].containsKey('parts') &&
                json['candidates'][0]['content']['parts'].isNotEmpty) {
              final text = json['candidates'][0]['content']['parts'][0]['text'];
              if (text != null && text.isNotEmpty) {
                buffer.write(text);
                yield buffer.toString();
              }
            }
          } catch (e) {
            // Skip malformed data
            continue;
          }
        }
      }
    } on DioException catch (e) {
      throw GeminiException(
        statusCode: e.response?.statusCode ?? 500,
        message: e.response?.data?['error']?['message'] ??
            e.message ??
            'Stream request failed',
      );
    }
  }

  Future<Completion> createMultimodal({
    required String prompt,
    required File image,
    String model = 'gemini-1.5-flash-002',
    int maxTokens = 1024,
  }) async {
    final imageBytes = await image.readAsBytes();
    final base64Image = base64Encode(imageBytes);

    try {
      final response = await dio.post(
        '/models/$model:generateContent',
        queryParameters: {
          'key': apiKey,
        },
        data: {
          'contents': [
            {
              'role': 'user',
              'parts': [
                {'text': prompt},
                {
                  'inlineData': {
                    'mimeType': 'image/jpeg',
                    'data': base64Image,
                  }
                }
              ]
            }
          ],
          'generationConfig': {
            'maxOutputTokens': maxTokens,
          },
          'safetySettings': [
            {
              'category': 'HARM_CATEGORY_HARASSMENT',
              'threshold': 'BLOCK_MEDIUM_AND_ABOVE',
            },
            {
              'category': 'HARM_CATEGORY_HATE_SPEECH',
              'threshold': 'BLOCK_MEDIUM_AND_ABOVE',
            },
            {
              'category': 'HARM_CATEGORY_SEXUALLY_EXPLICIT',
              'threshold': 'BLOCK_MEDIUM_AND_ABOVE',
            },
            {
              'category': 'HARM_CATEGORY_DANGEROUS_CONTENT',
              'threshold': 'BLOCK_MEDIUM_AND_ABOVE',
            },
          ],
        },
      );

      if (response.data['candidates'] != null &&
          response.data['candidates'].isNotEmpty &&
          response.data['candidates'][0]['content'] != null) {
        final parts = response.data['candidates'][0]['content']['parts'];
        final text = parts.isNotEmpty ? parts[0]['text'] : '';
        return Completion(text: text.trim());
      } else {
        throw GeminiException(
          statusCode: response.statusCode ?? 500,
          message: 'Failed to parse response or empty response',
        );
      }
    } on DioException catch (e) {
      throw GeminiException(
        statusCode: e.response?.statusCode ?? 500,
        message: e.response?.data?['error']?['message'] ??
            e.message ??
            'Multimodal request failed',
      );
    }
  }

  Future<List<String>> listModels() async {
    try {
      final response = await dio.get(
        '/models',
        queryParameters: {
          'key': apiKey,
        },
      );

      final modelList = (response.data['models'] as List)
          .map((model) => model['name'] as String)
          .where((name) => name.contains('gemini'))
          .toList();
      return modelList;
    } on DioException catch (e) {
      throw GeminiException(
        statusCode: e.response?.statusCode ?? 500,
        message: e.response?.data?['error']?['message'] ??
            e.message ??
            'Failed to fetch models',
      );
    } catch (e) {
      throw GeminiException(
        statusCode: 500,
        message: 'Unexpected error fetching models: ${e.toString()}',
      );
    }
  }
}

class Message {
  final String role;
  final dynamic content; // String or List<Map<String, dynamic>>

  Message({required this.role, required this.content});

  Map<String, dynamic> toJson() => {
        'role': role,
        'content': content,
      };
}

class Completion {
  final String text;

  Completion({required this.text});

  Map<String, dynamic> toJson() => {
        'text': text,
      };
}

class GeminiException implements Exception {
  final int statusCode;
  final String message;

  GeminiException({required this.statusCode, required this.message});

  @override
  String toString() => 'GeminiException: $statusCode - $message';
}
