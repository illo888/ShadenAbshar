import { GROQ_API_KEY, GROQ_BASE_URL, GROQ_CHAT_MODEL } from '../constants/config';

interface SendMessageOptions {
  model?: string;
  context?: string;
  history?: Array<{ role: 'user' | 'assistant'; content: string }>;
}

const BASE_SYSTEM_PROMPT = `
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

تذكري: سارة مو مجرد معلومة؛ انتي جهة تنفيذ كاملة القدرة عبر Saimaltor لكل خدمات أبشر.`;

export async function sendMessageToGroq(userMessage: string, options: SendMessageOptions = {}): Promise<string> {
  try {
    const usedModel = options.model || GROQ_CHAT_MODEL;

    const messages: Array<{ role: 'system' | 'user' | 'assistant'; content: string }> = [
      { role: 'system', content: BASE_SYSTEM_PROMPT }
    ];

    if (options.context) {
      messages.push({ role: 'system', content: options.context });
    }

    if (options.history) {
      options.history.forEach((entry) => {
        messages.push({ role: entry.role, content: entry.content });
      });
    }

    messages.push({ role: 'user', content: userMessage });

    const response = await fetch(`${GROQ_BASE_URL}/chat/completions`, {
      method: 'POST',
      headers: {
        Authorization: `Bearer ${GROQ_API_KEY}`,
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        model: usedModel,
        messages,
        temperature: 0.7,
        max_tokens: 500
      })
    });

    const data = await response.json();
    // If the API returns an error indicating that the model is unavailable, try fallback model
    if (data?.error && /model|not supported|deprecated|decommission|is not available|is not a valid model/i.test(String(data.error?.message || data.error || ''))) {
      // If a custom model was provided and failed, try the default chat model
      const fallbackModel = GROQ_CHAT_MODEL || 'mixtral-8x7b';
      if (usedModel !== fallbackModel) {
        console.warn(`Groq model ${usedModel} failed, retrying with fallback model ${fallbackModel}`);
        return await sendMessageToGroq(userMessage, { ...options, model: fallbackModel });
      }
    }
    // Normalize the response: return a string if possible, otherwise extract message if error object
    const content = data?.choices?.[0]?.message?.content || data?.choices?.[0]?.text;
    if (typeof content === 'string' && content.trim() !== '') return content as string;
    if (data?.error) {
      if (typeof data.error === 'string') return data.error;
      if (data.error?.message) return String(data.error.message);
      return JSON.stringify(data.error);
    }
    return 'عذراً، لم أتلقَ ردًا';
  } catch (error) {
    console.error('Groq API Error:', error);
    return 'عذراً، حدث خطأ في الاتصال';
  }
}
