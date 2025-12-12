import 'package:logger/logger.dart';
import 'sara_server_service.dart';
import 'groq_chat_service.dart';

/// Which AI service was used for the response
enum AiServiceUsed {
  saraFast,
  saraAccurate,
  groqFallback,
}

/// Response from AI Service Manager
class AiResponse {
  final String text;
  final AiServiceUsed serviceUsed;
  final int responseTimeMs;
  final List<String> suggestedActions;

  AiResponse({
    required this.text,
    required this.serviceUsed,
    required this.responseTimeMs,
    this.suggestedActions = const [],
  });
}

/// Manages AI services with SARA-first, Groq-fallback strategy
class AiServiceManager {
  final SaraServerService _saraService;
  final GroqChatService _groqService;
  final Logger _logger;

  bool _saraAvailable = true;
  DateTime? _lastSaraFailure;

  AiServiceManager({
    SaraServerService? saraService,
    GroqChatService? groqService,
    Logger? logger,
  })  : _saraService = saraService ?? SaraServerService(),
        _groqService = groqService ?? GroqChatService(),
        _logger = logger ?? Logger();

  /// Send a message with automatic SARA → Groq fallback
  Future<AiResponse> sendMessage(String message, {String? scenario}) async {
    final startTime = DateTime.now();

    // Check if we should skip SARA (if it failed recently)
    if (!_saraAvailable && _lastSaraFailure != null) {
      final timeSinceFailure = DateTime.now().difference(_lastSaraFailure!);
      if (timeSinceFailure.inSeconds < 60) {
        _logger.w('SARA recently failed, using Groq directly');
        return _useGroqFallback(message, startTime);
      } else {
        // Reset after 60 seconds
        _saraAvailable = true;
        _lastSaraFailure = null;
      }
    }

    // Determine if message needs accurate mode
    final needsAccurate = _isComplexQuery(message);
    final model = needsAccurate ? 'accurate' : 'fast';

    _logger.i('Sending message (model: $model, length: ${message.length})');

    // Try SARA server first
    try {
      final response = await _saraService.sendMessage(
        message: message,
        useNajdi: true,
        model: model,
      );

      _saraAvailable = true;
      _lastSaraFailure = null;

      final duration = DateTime.now().difference(startTime).inMilliseconds;
      _logger.i('✅ SARA $model response received in ${duration}ms');

      return AiResponse(
        text: response.response,
        serviceUsed: needsAccurate ? AiServiceUsed.saraAccurate : AiServiceUsed.saraFast,
        responseTimeMs: duration,
        suggestedActions: response.suggestedActions,
      );
    } catch (e) {
      _logger.e('❌ SARA failed: $e');
      _saraAvailable = false;
      _lastSaraFailure = DateTime.now();

      // Fallback to Groq
      return _useGroqFallback(message, startTime);
    }
  }

  /// Fallback to Groq API
  Future<AiResponse> _useGroqFallback(String message, DateTime startTime) async {
    try {
      _logger.i('🔄 Using Groq fallback');
      
      final response = await _groqService.sendMessage(
        message: message,
        useNajdi: true,
      );

      final duration = DateTime.now().difference(startTime).inMilliseconds;
      _logger.i('✅ Groq response received in ${duration}ms');

      return AiResponse(
        text: response,
        serviceUsed: AiServiceUsed.groqFallback,
        responseTimeMs: duration,
      );
    } catch (e) {
      _logger.e('❌ Groq fallback also failed: $e');
      throw Exception('عذراً، الخدمة غير متاحة حالياً. يرجى المحاولة لاحقاً');
    }
  }

  /// Determine if message needs accurate mode (ALLaM-7B)
  /// 
  /// Uses accurate mode when:
  /// - Message contains complex keywords (شرح، تفصيل، etc.)
  /// - Message is longer than 100 characters
  /// - Message contains multiple questions
  bool _isComplexQuery(String message) {
    // Keywords that indicate need for detailed response
    final complexKeywords = [
      'شرح',
      'اشرح',
      'تفصيل',
      'فصل',
      'فسر',
      'وضح',
      'اشرح لي',
      'بالتفصيل',
      'كيف يعمل',
      'ما الفرق',
      'قارن',
      'compare',
      'explain',
      'detail',
      'difference',
    ];

    // Check for complex keywords
    final hasComplexKeywords = complexKeywords.any(
      (keyword) => message.toLowerCase().contains(keyword),
    );

    // Check message length
    final isLongMessage = message.length > 100;

    // Check for multiple questions
    final questionMarks = '؟?'.split('');
    final questionCount = questionMarks.fold<int>(
      0,
      (count, mark) => count + mark.allMatches(message).length,
    );
    final hasMultipleQuestions = questionCount > 1;

    final needsAccurate = hasComplexKeywords || isLongMessage || hasMultipleQuestions;

    if (needsAccurate) {
      _logger.d('Complex query detected - using accurate mode');
    }

    return needsAccurate;
  }

  /// Check if SARA server is currently available
  Future<bool> isSaraAvailable() async {
    try {
      return await _saraService.testConnection();
    } catch (e) {
      return false;
    }
  }

  /// Get current service status
  Future<ServiceStatus> getServiceStatus() async {
    final saraHealthy = await isSaraAvailable();
    
    return ServiceStatus(
      saraAvailable: saraHealthy,
      groqAvailable: true, // Assume Groq is always available (cloud service)
      lastSaraCheck: DateTime.now(),
    );
  }

  /// Force refresh SARA availability status
  void resetSaraStatus() {
    _saraAvailable = true;
    _lastSaraFailure = null;
    _logger.i('SARA status reset');
  }

  /// Dispose resources
  void dispose() {
    _saraService.dispose();
  }
}

/// Service status information
class ServiceStatus {
  final bool saraAvailable;
  final bool groqAvailable;
  final DateTime lastSaraCheck;

  ServiceStatus({
    required this.saraAvailable,
    required this.groqAvailable,
    required this.lastSaraCheck,
  });

  /// Get status indicator color
  /// Green: SARA available
  /// Orange: Groq fallback only
  /// Red: Both unavailable
  ServiceStatusColor get statusColor {
    if (saraAvailable) {
      return ServiceStatusColor.green;
    } else if (groqAvailable) {
      return ServiceStatusColor.orange;
    } else {
      return ServiceStatusColor.red;
    }
  }

  /// Get status text in Arabic
  String get statusTextAr {
    if (saraAvailable) {
      return 'متصل بخادم سارة';
    } else if (groqAvailable) {
      return 'استخدام الخادم البديل';
    } else {
      return 'غير متصل';
    }
  }
}

enum ServiceStatusColor {
  green,
  orange,
  red,
}
