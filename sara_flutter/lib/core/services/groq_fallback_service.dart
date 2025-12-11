import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/message_model.dart';

class GroqFallbackService {
  static const String apiKey = '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';
  static const String baseUrl = 'https://api.groq.com/openai/v1';
  
  final Dio _dio = Dio(BaseOptions(
    baseUrl: baseUrl,
    headers: {
      'Authorization': 'Bearer $apiKey',
      'Content-Type': 'application/json',
    },
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
  ));

  /// Generate text response using Groq
  Future<String> generateText({
    required String message,
    List<MessageModel>? history,
  }) async {
    try {
      debugPrint('🔄 Fallback: Using Groq text generation...');
      
      final messages = <Map<String, dynamic>>[
        {
          'role': 'system',
          'content': '''أنت سارة، مساعدة ذكية سعودية تتحدث باللهجة النجدية من الرياض.

تساعد المستخدمين في:
• تجديد الجوازات والهويات الوطنية
• استخراج تصاريح السفر
• دفع المخالفات المرورية
• حجز المواعيد الحكومية
• خدمات أبشر المختلفة

تحدثي بطريقة ودودة ومهنية باللهجة النجدية. استخدمي كلمات مثل: "وش", "ليش", "كيف", "عندك", "تبي".'''
        }
      ];

      // Add conversation history
      if (history != null && history.isNotEmpty) {
        for (var msg in history.take(10)) {
          messages.add({
            'role': msg.role,
            'content': msg.text,
          });
        }
      }

      // Add current message
      messages.add({
        'role': 'user',
        'content': message,
      });

      final response = await _dio.post(
        '/chat/completions',
        data: {
          'model': 'groq/compound-mini',
          'messages': messages,
          'temperature': 0.7,
          'max_tokens': 500,
        },
      );

      if (response.statusCode == 200) {
        final content = response.data['choices'][0]['message']['content'];
        debugPrint('✅ Groq text response: ${content.substring(0, 50)}...');
        return content;
      } else {
        throw Exception('Groq API returned ${response.statusCode}');
      }
    } on DioException catch (e) {
      debugPrint('❌ Groq text error: ${e.message}');
      throw Exception('فشل في الاتصال بخدمة Groq: ${e.message}');
    } catch (e) {
      debugPrint('❌ Groq text error: $e');
      throw Exception('خطأ في معالجة الطلب');
    }
  }

  /// Generate speech using Groq PlayAI TTS
  Future<String> generateSpeech({
    required String text,
  }) async {
    try {
      debugPrint('🔄 Fallback: Using Groq TTS...');
      
      final response = await _dio.post(
        '/audio/speech',
        data: {
          'model': 'playai-tts-arabic',
          'voice': 'Amira-PlayAI',
          'response_format': 'wav',
          'input': text,
        },
        options: Options(
          responseType: ResponseType.bytes,
        ),
      );

      if (response.statusCode == 200) {
        // Save audio to temporary file
        final tempDir = await getTemporaryDirectory();
        final audioPath = '${tempDir.path}/groq_speech_${DateTime.now().millisecondsSinceEpoch}.wav';
        final file = File(audioPath);
        await file.writeAsBytes(response.data);
        
        debugPrint('✅ Groq TTS saved: $audioPath');
        return audioPath;
      } else {
        throw Exception('Groq TTS returned ${response.statusCode}');
      }
    } on DioException catch (e) {
      debugPrint('❌ Groq TTS error: ${e.message}');
      throw Exception('فشل في توليد الصوت: ${e.message}');
    } catch (e) {
      debugPrint('❌ Groq TTS error: $e');
      throw Exception('خطأ في توليد الصوت');
    }
  }

  /// Combined text + speech generation
  Future<({String text, String? audioPath})> generateResponse({
    required String message,
    List<MessageModel>? history,
    bool generateAudio = true,
  }) async {
    // Generate text
    final text = await generateText(
      message: message,
      history: history,
    );

    // Generate audio if requested
    String? audioPath;
    if (generateAudio) {
      try {
        audioPath = await generateSpeech(text: text);
      } catch (e) {
        debugPrint('⚠️ TTS failed, continuing with text only: $e');
      }
    }

    return (text: text, audioPath: audioPath);
  }
}
