import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

/// Response from SARA server chat endpoint
class SaraChatResponse {
  final String response;
  final bool needsConfirmation;
  final List<String> suggestedActions;
  final String modelUsed;
  final int responseTimeMs;

  SaraChatResponse({
    required this.response,
    required this.needsConfirmation,
    required this.suggestedActions,
    required this.modelUsed,
    required this.responseTimeMs,
  });

  factory SaraChatResponse.fromJson(Map<String, dynamic> json) {
    return SaraChatResponse(
      response: json['response'] as String,
      needsConfirmation: json['needs_confirmation'] as bool? ?? false,
      suggestedActions: (json['suggested_actions'] as List?)?.cast<String>() ?? [],
      modelUsed: json['model_used'] as String? ?? 'unknown',
      responseTimeMs: json['response_time_ms'] as int? ?? 0,
    );
  }
}

/// Server health status
class ServerHealth {
  final bool isHealthy;
  final List<String> modelsLoaded;
  final DateTime serverTime;

  ServerHealth({
    required this.isHealthy,
    required this.modelsLoaded,
    required this.serverTime,
  });

  factory ServerHealth.fromJson(Map<String, dynamic> json) {
    return ServerHealth(
      isHealthy: json['status'] == 'healthy',
      modelsLoaded: (json['models_loaded'] as List?)?.cast<String>() ?? [],
      serverTime: DateTime.parse(json['server_time'] as String),
    );
  }
}

/// Service for communicating with SARA AI server
class SaraServerService {
  static const String baseUrl = 'https://ai.saraagent.com/api';
  
  final Dio _dio;
  final Logger _logger;

  SaraServerService({Dio? dio, Logger? logger})
      : _dio = dio ??
            Dio(BaseOptions(
              baseUrl: baseUrl,
              connectTimeout: const Duration(seconds: 10),
              receiveTimeout: const Duration(seconds: 30),
              headers: {
                'Content-Type': 'application/json',
              },
            )),
        _logger = logger ?? Logger();

  /// Send a chat message to SARA server
  /// 
  /// [message] - User's message text
  /// [useNajdi] - Use Najdi dialect (default: true)
  /// [model] - 'fast' (llama3.2:3b, ~3.4s) or 'accurate' (ALLaM-7B, ~6s)
  Future<SaraChatResponse> sendMessage({
    required String message,
    bool useNajdi = true,
    String model = 'fast',
  }) async {
    try {
      _logger.d('Sending message to SARA server (model: $model): $message');
      
      final startTime = DateTime.now();
      
      final response = await _dio.post(
        '/chat',
        data: {
          'message': message,
          'use_najdi': useNajdi,
          'model': model,
        },
      );

      final duration = DateTime.now().difference(startTime).inMilliseconds;
      _logger.i('SARA response received in ${duration}ms');

      if (response.statusCode == 200 && response.data != null) {
        return SaraChatResponse.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw Exception('Invalid response from SARA server: ${response.statusCode}');
      }
    } on DioException catch (e) {
      _logger.e('SARA server error: ${e.type} - ${e.message}');
      
      // Provide specific error messages for different failure types
      if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception('خطأ في الاتصال بخادم سارة: انتهت مهلة الاتصال');
      } else if (e.type == DioExceptionType.receiveTimeout) {
        throw Exception('خطأ في الاتصال بخادم سارة: انتهت مهلة الاستجابة');
      } else if (e.type == DioExceptionType.connectionError) {
        throw Exception('خطأ في الاتصال بخادم سارة: فشل الاتصال');
      } else {
        throw Exception('خطأ في خادم سارة: ${e.message}');
      }
    } catch (e) {
      _logger.e('Unexpected error in SARA service: $e');
      throw Exception('خطأ غير متوقع: $e');
    }
  }

  /// Check SARA server health
  Future<ServerHealth> checkHealth() async {
    try {
      _logger.d('Checking SARA server health');
      
      final response = await _dio.get(
        '/health',
        options: Options(
          receiveTimeout: const Duration(seconds: 5),
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        final health = ServerHealth.fromJson(response.data as Map<String, dynamic>);
        _logger.i('SARA server health: ${health.isHealthy ? "healthy" : "unhealthy"}');
        return health;
      } else {
        throw Exception('Invalid health check response');
      }
    } on DioException catch (e) {
      _logger.w('SARA health check failed: ${e.type}');
      return ServerHealth(
        isHealthy: false,
        modelsLoaded: [],
        serverTime: DateTime.now(),
      );
    } catch (e) {
      _logger.w('SARA health check error: $e');
      return ServerHealth(
        isHealthy: false,
        modelsLoaded: [],
        serverTime: DateTime.now(),
      );
    }
  }

  /// Test connection to SARA server with a simple ping
  Future<bool> testConnection() async {
    try {
      final health = await checkHealth();
      return health.isHealthy;
    } catch (e) {
      _logger.e('Connection test failed: $e');
      return false;
    }
  }

  /// Dispose resources
  void dispose() {
    _dio.close();
  }
}
