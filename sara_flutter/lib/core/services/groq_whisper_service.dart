import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Service for transcribing audio using Groq Whisper API
class GroqWhisperService {
  static const String _apiKey = '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';
  static const String _baseUrl = 'https://api.groq.com/openai/v1';
  
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: _baseUrl,
      headers: {
        'Authorization': 'Bearer $_apiKey',
      },
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ),
  );

  /// Transcribe audio file to text using Whisper
  /// 
  /// [audioPath] - Path to the audio file (WAV, M4A, MP3, etc.)
  /// Returns the transcribed Arabic text
  Future<String> transcribeAudio(String audioPath) async {
    try {
      debugPrint('🎤 Starting Whisper transcription: $audioPath');
      
      final file = File(audioPath);
      if (!await file.exists()) {
        throw Exception('Audio file not found: $audioPath');
      }

      final fileSize = await file.length();
      debugPrint('📁 Audio file size: ${fileSize} bytes');

      if (fileSize < 1000) {
        debugPrint('⚠️ Audio file too small, might be empty');
        return '';
      }

      // Create form data
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          audioPath,
          filename: 'audio.wav',
        ),
        'model': 'whisper-large-v3',
        'language': 'ar', // Arabic
        'response_format': 'json',
      });

      // Call Whisper API
      final response = await _dio.post(
        '/audio/transcriptions',
        data: formData,
      );

      if (response.statusCode == 200 && response.data != null) {
        final text = response.data['text'] as String? ?? '';
        debugPrint('✅ Whisper transcription: $text');
        return text.trim();
      }

      debugPrint('⚠️ Whisper API returned no text');
      return '';
      
    } on DioException catch (e) {
      debugPrint('❌ Whisper API Error: ${e.message}');
      if (e.response != null) {
        debugPrint('Response: ${e.response?.data}');
      }
      throw Exception('فشل في تحويل الصوت إلى نص');
    } catch (e) {
      debugPrint('❌ Whisper Error: $e');
      throw Exception('عذراً، حدث خطأ في معالجة الصوت');
    }
  }
}
