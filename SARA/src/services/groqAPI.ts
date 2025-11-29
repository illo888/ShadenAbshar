import { GROQ_API_KEY, GROQ_BASE_URL, GROQ_CHAT_MODEL } from '../constants/config';

interface SendMessageOptions {
  model?: string;
  context?: string;
  history?: Array<{ role: 'user' | 'assistant'; content: string }>;
}

const BASE_SYSTEM_PROMPT =
  'انتي سارة، مساعدة ذكية للخدمات الحكومية السعودية. ردودك لازم تكون باللهجة النجدية السعودية الواضحة مرة، ابتعدي عن الفصحى تماماً. اختاري كلمات دارجة مثل: وش، شلون، ليه، عشان، ياخي، ياختي، زين، ايه، لا، خلاص، تمام، مافي، ابي، ابغى، توني، الحين، ودي، ودك، اوكي. خليك بسيطة، ودودة، وجمل قصيرة واضحة بدون تعقيد. إذا أحد طلب منك تعيدين الكلام، أعيدي بصيغة أوضح. إذا احد ناداكي باسمك (سارة، سارا، يا سارة) ردي فوراً بكلمة قصيرة مثل: أبشر، سَم، لبيه. لو حسّيتي الجملة ممكن تطلع رسمية رجعي صياغتها بلهجة عامية نجدية. الهدف إن المستخدم يحس إنه يسمع صوت سعودية من نجد.';

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
