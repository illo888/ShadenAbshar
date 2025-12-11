import 'package:dio/dio.dart';
import '../models/message_model.dart';
import '../../config/constants.dart';

class GroqService {
  final Dio _dio;
  
  static const String _baseSystemPrompt = '''
انتي سارة، مساعدة ذكية للخدمات الحكومية السعودية، وتتكلمين حصرياً بلهجة نجدية دارجة جدًا (وش، شلون، ليه، عشان، ياخي، ياختي، زين، ايه، لا، خلاص، تمام، مافي، ابغى، الحين، ودي...). خليك بسيطة، ودودة، وجمل قصيرة مباشرة بدون تعقيد أو فصحى. لو أحد طلب تعيدين الكلام، أعيدي بصيغة أوضح وبنفس اللهجة. إذا ناداكي المستخدم باسمك ردي بسرعة بكلمة قصيرة مثل: أبشر، سَم، لبيه.

الصلاحيات:
- عندك وصول كامل لنظام "Saimaltor" المرتبط بكل خدمات "أبشر" الرسمية. تتصرفين كموظفة موثوقة وتنجزين الطلبات بنفسك (تجديد جواز/هوية، حجز مواعيد، إضافة تابع، دفع مخالفات، إصدار تصاريح، رفع بلاغات...).
- كل رد لازم يشرح بإيجاز وش الخدمة اللي نفذتيها داخل Saimaltor، وش الخطوة الجاية، ورقم الطلب/المرجع لو توفر.
- تجنبي عبارات من نوع "ما أقدر" إلا إذا الخدمة فعلاً خارج الصلاحيات. إذا احتجتي معلومة إضافية خذيها بسؤال واضح وبلهجة محلية.

تنسيق أزرار CTA:
1. بعد أي رد فيه خطوة تالية، اختمي ببلوك \`\`\`cta ... \`\`\` يحتوي JSON Array.
2. العناصر تكون بشكل { "label": "...", "action": "...", "variant": "primary" | "secondary" } بعدد من 1 إلى 3.
3. أي زر يمثل مهمة تنفذينها مباشرة لازم action يبدأ بـ "saimaltor:" مثل saimaltor:renew-passport?person=self.
4. خلي زر Primary وحيد يمثل الخيار الأهم، والباقي Secondary.
5. لو ما فيه إلا تأكيد نهائي، خلي زر يقول مثلاً "اطلب خدمة ثانية" مع action واضح.

تذكري: سارة مو مجرد معلومة؛ انتي جهة تنفيذ كاملة القدرة عبر Saimaltor لكل خدمات أبشر.''';

  GroqService({String? apiKey})
      : _dio = Dio(BaseOptions(
          baseUrl: AppConstants.groqBaseUrl,
          headers: {
            'Authorization': 'Bearer ${apiKey ?? AppConstants.groqApiKey}',
            'Content-Type': 'application/json',
          },
        ));

  Future<String> sendMessage({
    required String message,
    String? context,
    List<MessageModel>? history,
  }) async {
    try {
      final messages = <Map<String, dynamic>>[
        {
          'role': 'system',
          'content': _buildSystemPrompt(context),
        },
      ];

      if (history != null && history.isNotEmpty) {
        for (final msg in history.take(AppConstants.maxHistoryLength)) {
          messages.add({
            'role': msg.role,
            'content': msg.text,
          });
        }
      }

      messages.add({
        'role': 'user',
        'content': message,
      });

      final response = await _dio.post(
        '/chat/completions',
        data: {
          'model': AppConstants.groqChatModel,
          'messages': messages,
          'temperature': 0.7,
          'max_tokens': 500,
        },
      );

      final content = response.data['choices'][0]['message']['content'];
      return content as String;
    } on DioException catch (e) {
      if (e.response?.data?['error'] != null) {
        final error = e.response!.data['error'];
        if (error is Map && error['message'] != null) {
          return 'عذراً، حدث خطأ: ${error['message']}';
        }
      }
      return 'عذراً، حدث خطأ في الاتصال';
    } catch (e) {
      return 'عذراً، حدث خطأ غير متوقع';
    }
  }

  String _buildSystemPrompt(String? additionalContext) {
    if (additionalContext == null || additionalContext.isEmpty) {
      return _baseSystemPrompt;
    }
    return '$_baseSystemPrompt\n\n$additionalContext';
  }
}
