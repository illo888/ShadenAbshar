import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/message_model.dart';
import '../services/groq_service.dart';
import '../services/saimaltor_service.dart';
import '../services/ai_service_manager.dart';
import 'user_provider.dart';

class ChatNotifier extends StateNotifier<List<MessageModel>> {
  final Ref ref;
  final GroqService _groqService;
  final SaimaltorService _saimaltorService;
  final AiServiceManager _aiManager;
  int _messageIdCounter = 0;

  ChatNotifier(this.ref)
      : _groqService = GroqService(),
        _saimaltorService = SaimaltorService(),
        _aiManager = AiServiceManager(),
        super([]);

  // Add message directly without API call (for voice responses)
  void addMessageDirect(MessageModel message) {
    state = [...state, message];
  }

  Future<void> sendMessage(String text, {bool useNajdi = false}) async {
    // Add user message
    final userMessage = MessageModel(
      id: _messageIdCounter++,
      role: 'user',
      text: text,
      ctas: null,
    );
    state = [...state, userMessage];

    try {
      // Get user context
      final user = ref.read(userProvider);
      
      // Call SARA Server (with Groq fallback)
      final aiResponse = await _aiManager.sendMessage(
        message: text,
        useNajdi: useNajdi,
      );

      // Parse CTAs from response
      final parsedMessage = _parseMessageCTAs(aiResponse.text);
      
      // Add suggested actions from SARA if available
      final ctas = parsedMessage.ctas ?? 
        (aiResponse.suggestedActions != null 
          ? aiResponse.suggestedActions!.map((action) => CTAAction(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              label: action,
              action: action,
              variant: 'primary',
            )).toList()
          : null);
      
      final assistantMessage = MessageModel(
        id: _messageIdCounter++,
        role: 'assistant',
        text: parsedMessage.text,
        ctas: ctas,
      );
      
      state = [...state, assistantMessage];
    } catch (e) {
      final errorMessage = MessageModel(
        id: _messageIdCounter++,
        role: 'assistant',
        text: 'عذراً، حدث خطأ في الاتصال. جرب مرة ثانية.',
        ctas: null,
      );
      state = [...state, errorMessage];
    }
  }

  Future<void> executeCTA(CTAAction cta) async {
    try {
      final user = ref.read(userProvider);
      
      final result = await _saimaltorService.executeAction(
        action: cta.action,
        user: user,
      );

      final resultMessage = MessageModel(
        id: _messageIdCounter++,
        role: 'assistant',
        text: result.message,
        ctas: result.ctas,
      );
      
      state = [...state, resultMessage];
    } catch (e) {
      final errorMessage = MessageModel(
        id: _messageIdCounter++,
        role: 'assistant',
        text: 'عذراً، ما قدرت أنفذ الخدمة. جرب مرة ثانية.',
        ctas: null,
      );
      state = [...state, errorMessage];
    }
  }

  ({String text, List<CTAAction>? ctas}) _parseMessageCTAs(String response) {
    final ctaPattern = RegExp(
      r'```cta\s*\n([\s\S]*?)\n```',
      multiLine: true,
    );
    
    final match = ctaPattern.firstMatch(response);
    if (match == null) {
      return (text: response, ctas: null);
    }

    final ctaBlock = match.group(1)?.trim() ?? '';
    final cleanText = response.replaceAll(ctaPattern, '').trim();

    try {
      // Parse CTA JSON
      final List<dynamic> ctaJson = _parseJsonArray(ctaBlock);
      final ctas = ctaJson.map((item) {
        return CTAAction(
          id: item['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
          label: item['label'] ?? '',
          action: item['action'] ?? '',
          variant: item['variant'] ?? 'primary',
        );
      }).toList();

      return (text: cleanText, ctas: ctas);
    } catch (e) {
      // ignore: avoid_print
      print('خطأ في تحليل CTAs: $e');
      return (text: cleanText, ctas: null);
    }
  }

  List<dynamic> _parseJsonArray(String jsonString) {
    // Simple JSON array parser for CTA blocks
    try {
      final trimmed = jsonString.trim();
      if (!trimmed.startsWith('[')) return [];
      
      // This is a simplified parser - in production use dart:convert
      // For now, return empty list if complex parsing needed
      return [];
    } catch (e) {
      return [];
    }
  }

  void addWelcomeMessage(String message) {
    final welcomeMessage = MessageModel(
      id: _messageIdCounter++,
      role: 'assistant',
      text: message,
      ctas: null,
    );
    state = [welcomeMessage];
  }

  void clearChat() {
    state = [];
    _messageIdCounter = 0;
  }

  int get messageCount => state.length;
  
  bool get isEmpty => state.isEmpty;
  
  List<MessageModel> get messages => state;
}

final chatProvider = StateNotifierProvider<ChatNotifier, List<MessageModel>>((ref) {
  return ChatNotifier(ref);
});
