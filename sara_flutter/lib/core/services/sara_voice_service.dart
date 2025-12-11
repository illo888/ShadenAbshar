import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'groq_fallback_service.dart';
import 'groq_whisper_service.dart';

class SaraVoiceService {
  static const String wsUrl = 'ws://134.209.234.124:8000/ws/voice';
  
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  final AudioPlayer _player = AudioPlayer();
  final GroqFallbackService _groqFallback = GroqFallbackService();
  final GroqWhisperService _whisperService = GroqWhisperService();
  
  bool _useFallback = false;
  Timer? _connectionTimeout;
  bool _recorderIsOpen = false;
  
  WebSocketChannel? _channel;
  StreamSubscription? _wsSubscription;
  
  bool _isConnected = false;
  bool _isRecording = false;
  bool _isSaraResponding = false;
  
  // Callbacks
  Function(bool)? onConnectionChange;
  Function(bool)? onRecordingChange;
  Function(bool)? onSaraRespondingChange;
  Function(String)? onUserSpoke;
  Function(String)? onSaraResponded;
  Function(String)? onError;

  bool get isConnected => _isConnected;
  bool get isRecording => _isRecording;
  bool get isSaraResponding => _isSaraResponding;

  /// Initialize
  Future<void> initialize() async {
    try {
      // Request microphone permission
      final status = await Permission.microphone.request();
      if (!status.isGranted) {
        debugPrint('⚠️ Microphone permission denied');
        onError?.call('يرجى السماح باستخدام الميكروفون');
        return;
      }
      
      if (!_recorderIsOpen) {
        await _recorder.openRecorder();
        _recorderIsOpen = true;
        debugPrint('✅ Sara Voice Service initialized');
      }
    } catch (e) {
      debugPrint('❌ Initialize error: $e');
      onError?.call('خطأ في تهيئة خدمة الصوت');
    }
  }

  /// Connect to WebSocket with fallback
  Future<void> connect() async {
    if (_isConnected) return;

    // Initialize recorder if not already done
    if (!_recorderIsOpen) {
      await initialize();
      // If still not open after initialize, return early
      if (!_recorderIsOpen) {
        debugPrint('⚠️ Cannot connect - recorder not initialized');
        return;
      }
    }

    try {
      debugPrint('🔌 Connecting to Sara voice server...');
      _channel = WebSocketChannel.connect(Uri.parse(wsUrl));
      
      // Set connection timeout
      _connectionTimeout = Timer(const Duration(seconds: 5), () {
        if (!_isConnected) {
          debugPrint('⚠️ Connection timeout, switching to Groq fallback');
          _useFallback = true;
          _isConnected = true;
          onConnectionChange?.call(true);
        }
      });
      
      _wsSubscription = _channel!.stream.listen(
        (data) {
          _connectionTimeout?.cancel();
          _handleResponse(data);
        },
        onError: (error) {
          debugPrint('❌ WebSocket error: $error, switching to fallback');
          _useFallback = true;
          _isConnected = true;
          onConnectionChange?.call(true);
        },
        onDone: () {
          debugPrint('🔌 WebSocket closed, switching to fallback');
          if (!_useFallback) {
            _useFallback = true;
            _isConnected = true;
            onConnectionChange?.call(true);
          }
        },
      );
      
      // Give it a moment to connect
      await Future.delayed(const Duration(milliseconds: 500));
      
      if (!_useFallback) {
        _isConnected = true;
        onConnectionChange?.call(true);
        debugPrint('✅ Connected to Sara voice server');
      } else {
        debugPrint('✅ Using Groq fallback mode');
      }
      
    } catch (e) {
      debugPrint('❌ Connection failed, using Groq fallback: $e');
      _useFallback = true;
      _isConnected = true;
      onConnectionChange?.call(true);
    }
  }

  /// Disconnect
  Future<void> disconnect() async {
    await _wsSubscription?.cancel();
    await _channel?.sink.close();
    _isConnected = false;
    onConnectionChange?.call(false);
  }

  /// Handle Sara's audio response
  void _handleResponse(dynamic message) async {
    if (message is List<int>) {
      debugPrint('🎤 Received Sara\'s response (${message.length} bytes)');
      
      _isSaraResponding = true;
      onSaraRespondingChange?.call(true);
      
      // Notify with a placeholder text (in production, you'd get text from server)
      onSaraResponded?.call('استجابة من سارة');
      
      await _playSaraResponse(Uint8List.fromList(message));
      
      _isSaraResponding = false;
      onSaraRespondingChange?.call(false);
    }
  }

  /// Play Sara's audio response
  Future<void> _playSaraResponse(Uint8List audioBytes) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final tempFile = File(
        '${tempDir.path}/sara_${DateTime.now().millisecondsSinceEpoch}.wav'
      );
      await tempFile.writeAsBytes(audioBytes);
      
      await _player.play(DeviceFileSource(tempFile.path));
      
      // Wait for completion
      final completer = Completer();
      _player.onPlayerComplete.listen((_) {
        tempFile.delete().catchError((_) {
          return tempFile; // Return value for catchError
        });
        completer.complete();
      });
      
      await completer.future;
      
    } catch (e) {
      debugPrint('❌ Playback error: $e');
      onError?.call('خطأ في تشغيل صوت سارة');
    }
  }

  /// Start voice recording
  Future<void> startTalking() async {
    if (_isRecording || !_isConnected) return;
    
    try {
      // Ensure recorder is open
      if (!_recorderIsOpen) {
        await _recorder.openRecorder();
        _recorderIsOpen = true;
        debugPrint('✅ Recorder opened');
      }
      
      final tempDir = await getTemporaryDirectory();
      final recordPath = '${tempDir.path}/recording_${DateTime.now().millisecondsSinceEpoch}.wav';
      
      await _recorder.startRecorder(
        toFile: recordPath,
        codec: Codec.pcm16WAV,
        sampleRate: 22050,
        numChannels: 1,
      );
      
      _isRecording = true;
      onRecordingChange?.call(true);
      debugPrint('🎙️ User started talking...');
      
    } catch (e) {
      debugPrint('❌ Recording failed: $e');
      onError?.call('فشل في التسجيل');
    }
  }

  /// Stop recording and send to Sara (with fallback)
  Future<void> stopTalking() async {
    if (!_isRecording) return;
    
    try {
      final path = await _recorder.stopRecorder();
      _isRecording = false;
      onRecordingChange?.call(false);
      
      if (path == null) return;
      
      if (_useFallback) {
        // Use Groq fallback: Whisper + Chat + TTS
        debugPrint('🔄 Using Groq fallback for processing...');
        await _handleFallbackResponse(path);
        await File(path).delete().catchError((_) {});
      } else {
        // Send to Sara voice server via WebSocket
        final file = File(path);
        final bytes = await file.readAsBytes();
        debugPrint('� Sending to Sara (${bytes.length} bytes)...');
        _channel?.sink.add(bytes);
        onUserSpoke?.call('جاري المعالجة...');
        await file.delete().catchError((_) {});
      }
      
    } catch (e) {
      debugPrint('❌ Send failed: $e');
      _isRecording = false;
      onRecordingChange?.call(false);
      onError?.call('فشل في إرسال الصوت');
    }
  }
  
  /// Handle fallback response using Groq (Whisper + Chat + TTS)
  Future<void> _handleFallbackResponse(String audioPath) async {
    try {
      _isSaraResponding = true;
      onSaraRespondingChange?.call(true);
      
      // Step 1: Transcribe audio using Groq Whisper
      debugPrint('🎤 Transcribing audio with Whisper...');
      final transcribedText = await _whisperService.transcribeAudio(audioPath);
      
      if (transcribedText.isEmpty) {
        debugPrint('⚠️ No transcription received');
        onUserSpoke?.call('لم أتمكن من سماع ما قلته');
        onSaraResponded?.call('عذراً، ما سمعت أي صوت. حاول تتكلم مرة ثانية.');
        _isSaraResponding = false;
        onSaraRespondingChange?.call(false);
        return;
      }
      
      debugPrint('✅ Transcription: $transcribedText');
      onUserSpoke?.call(transcribedText);
      
      // Step 2: Generate response using Groq Chat + TTS
      debugPrint('🤖 Generating AI response...');
      final response = await _groqFallback.generateResponse(
        message: transcribedText,
        generateAudio: true,
      );
      
      debugPrint('✅ AI Response: ${response.text}');
      onSaraResponded?.call(response.text);
      
      // Step 3: Play audio response
      if (response.audioPath != null) {
        debugPrint('🔊 Playing audio response...');
        await _playAudioFile(response.audioPath!);
      }
      
      _isSaraResponding = false;
      onSaraRespondingChange?.call(false);
      
    } catch (e) {
      debugPrint('❌ Fallback error: $e');
      _isSaraResponding = false;
      onSaraRespondingChange?.call(false);
      onError?.call('حدث خطأ في المعالجة');
    }
  }
  
  /// Play audio file
  Future<void> _playAudioFile(String filePath) async {
    try {
      await _player.play(DeviceFileSource(filePath));
      
      final completer = Completer();
      _player.onPlayerComplete.listen((_) {
        File(filePath).delete().catchError((_) {
          return File(filePath); // Return value for catchError
        });
        completer.complete();
      });
      
      await completer.future;
    } catch (e) {
      debugPrint('❌ Audio playback error: $e');
    }
  }

  /// Dispose
  Future<void> dispose() async {
    await disconnect();
    if (_recorderIsOpen) {
      await _recorder.closeRecorder();
      _recorderIsOpen = false;
    }
    await _player.dispose();
  }
}
