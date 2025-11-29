import { ScenarioType } from '../utils/saudiId';
import type { UserData } from '../context/UserContext';

interface ScenarioService {
  name: string;
  status: string;
  detail: string;
}

interface ScenarioProfile {
  label: string;
  description: string;
  services: ScenarioService[];
  reminders?: string[];
  suggestions: string[];
  greeting: (user: UserData) => string;
  voiceGreeting?: (user: UserData) => string;
}

const defaultSuggestions: string[] = [
  'وش الخدمات الحكومية اللي اقدر اسويها الحين؟',
  'ابي اعرف حالة الهوية الوطنية عندي',
  'كيف اقدر احجز موعد في أبشر؟'
];

const scenarioProfiles: Record<ScenarioType, ScenarioProfile> = {
  safe_gate: {
    label: 'بوابة السعودية الآمنة للمغتربين',
    description:
      'المستخدم خارج المملكة ويعتمد على Saudi Safe Security Gate عشان يدير OTP البنكية، VPN السعودي، وخدمات التواصل الطارئ. مهتم يحافظ على خدماته البنكية والحكومية وهو برا البلد.',
    services: [
      {
        name: 'OTP السعودي المشترك بالخدمات البنكية',
        status: 'جاهز للتفعيل عبر البوابة الآمنة',
        detail: 'أول استخدام يحتاج تأكيد عبر نفاذ من داخل السعودية، بعد الربط يوصلك رمز مؤقت خلال 3 ثواني من كل بنك أو خدمة حكومية.'
      },
      {
        name: 'VPN السعودي الاستثنائي',
        status: 'فعال خلال السفر',
        detail: 'يضمن اتصال مشفر لكل التطبيقات البنكية (الراجحي، الأهلي، بنك الرياض) وخدمات مثل أبشر وناجز بدون حظر جغرافي.'
      },
      {
        name: 'خط الاتصال الطارئ داخل السعودية',
        status: 'يشتغل لمدة 10 دقائق لكل مكالمة',
        detail: 'يوجه المكالمة مباشرة للرقم اللي يطلبه المستخدم (الطوارئ، الشرطة، دعم البوابة الآمنة).' 
      }
    ],
    reminders: [
      'المستخدم يستقبل رسائل OTP وهمية للتجربة من بنوك سعودية، لازم تتفاعل معها كأنها حقيقية.',
      'أي خدمة بنكية أو حكومية يحتاجها تكون عبر تطبيقات مثل أبشر، البنك المفضل، وزارة العدل (ناجز).'
    ],
    suggestions: [
      'ابي اربط OTP مع بنك الراجحي',
      'كيف اشغل VPN السعودي وادخل على أبشر؟',
      'ابي اتأكد من المكالمات الطارئة خطوة بخطوة',
      'وش آخر رموز OTP اللي وصلتني؟'
    ],
    greeting: (user) => {
      const firstName = user.name.split(' ')[0] || user.name;
      return `هلا ${firstName}! انا سارة، موجودة أساعدك وانت برا المملكة. وش تبي تسوي؟`;
    },
    voiceGreeting: (user) => {
      const firstName = user.name.split(' ')[0] || user.name;
      return `هلا ${firstName}! انا سارة معك من البوابة الآمنة. وش تحتاج نسويه الحين؟`;
    }
  },
  in_saudi: {
    label: 'مواطن داخل السعودية',
    description:
      'المستخدم موجود داخل المملكة، ينجز خدماته الحكومية عبر أبشر وبقية المنصات، وعنده أكثر من خدمة تحتاج متابعة (رخصة منتهية وتنبيه تجديد).',
    services: [
      {
        name: 'الهوية الوطنية',
        status: 'صحيحة وتنتهي خلال 18 شهر',
        detail: 'تجديدها متاح إلكترونياً قبل تاريخ الانتهاء ب180 يوم عبر أبشر.'
      },
      {
        name: 'رخصة القيادة الخاصة',
        status: 'منتهية من أغسطس 2024',
        detail: 'يحتاج يسدد المخالفات ان وجدت ثم يجدد عبر أبشر (خدمة المرور → تجديد رخصة).' 
      },
      {
        name: 'جواز السفر السعودي',
        status: 'نشط إلى ديسمبر 2027',
        detail: 'يمكن تحديث البيانات أو طلب إصدار جديد إذا تبقى أقل من سنة على الانتهاء.'
      }
    ],
    reminders: [
      'عنده تنبيه سابق عن رخصة القيادة، مهم تذكيره بالخطوات كاملة للتجديد.',
      'يفضل اقتراح خدمات مرتبطة بالمرور، الهوية، المخالفات، حجوزات الأحوال المدنية.'
    ],
    suggestions: [
      'ابي اجدد رخصة القيادة',
      'كيف اطلع موعد في الأحوال لتجديد الهوية؟',
      'ابي اشوف المخالفات اللي علي وكيف اسددها',
      'وش الخدمات النشطة عندي في أبشر؟'
    ],
    greeting: (user) => {
      const firstName = user.name.split(' ')[0] || user.name;
      return `هلا ${firstName}! انا سارة، وش الخدمة اللي ودك ننجزها؟`;
    },
    voiceGreeting: (user) => {
      const firstName = user.name.split(' ')[0] || user.name;
      return `مرحبتين ${firstName}! سارة معك، علمني وش تحتاج نخلصه؟`;
    }
  },
  elder: {
    label: 'وضع كبار السن',
    description:
      'المستخدم كبير سن ويحتاج لغة واضحة وبسيطة، مع تفضيل للخدمات الميسرة مثل المواعيد الطبية، توصيل الأدوية، الدعم الاجتماعي.',
    services: [
      {
        name: 'بطاقة أولوية كبار السن',
        status: 'قيد الإصدار',
        detail: 'الطلب مرفوع لوزارة الصحة، متوقع يتفعل خلال 5 أيام عمل.'
      },
      {
        name: 'حجز موعد عيادة الرعاية الأولية',
        status: 'موعد مؤكد بتاريخ 12 ديسمبر 2025',
        detail: 'العيادة في مستشفى الملك فهد، الرياض. يمكن تعديل الموعد أو طلب تنبيه قبلها بيوم.'
      },
      {
        name: 'توصيل الأدوية للمنزل',
        status: 'جاهز للتفعيل',
        detail: 'الخدمة متوفرة عبر تطبيق صحتي، يحتاج تحديد الصيدلية الأقرب.'
      }
    ],
    reminders: [
      'استخدم أسلوب جداً بسيط وواضح، وكرر الخطوات لو طلب منك.',
      'اقترح خدمات تساعد على الراحة مثل توصيل الأدوية أو المساعدات المنزلية.'
    ],
    suggestions: [
      'ابي اغير موعد العيادة الجاية',
      'كيف اطلب توصيل الادوية للبيت؟',
      'وش الخدمات الخاصة بكبار السن؟',
      'ابي رقم للتواصل السريع مع وزارة الصحة'
    ],
    greeting: (user) => {
      const firstName = user.name.split(' ')[0] || user.name;
      return `هلا وغلا ${firstName}! انا سارة، بساعدك بكل خطوة. وش تحتاج اليوم؟`;
    },
    voiceGreeting: (user) => {
      const firstName = user.name.split(' ')[0] || user.name;
      return `هلا وغلا ${firstName}! سارة معك، قول وش نخدمك فيه؟`;
    }
  },
  guest: {
    label: 'مساعدة ضيف داخل المملكة',
    description:
      'المستخدم زائر أو مقيم مؤقت، يحتاج إرشادات عن التأشيرات، الضيافة، التواصل مع السفارات والخدمات السريعة.',
    services: [
      {
        name: 'تأشيرة الزيارة',
        status: 'تنتهي بعد 25 يوم',
        detail: 'يمكن تمديدها مرة واحدة عبر أبشر أو منصة مقيم إذا تبقى أكثر من 7 أيام على الانتهاء.'
      },
      {
        name: 'خدمة ضيف الوزارة',
        status: 'مفعلة',
        detail: 'تتيح التواصل مع مركز اتصال وزارة الخارجية خلال 24 ساعة.'
      },
      {
        name: 'الدعم القنصلي',
        status: 'متوفر عبر سفارة بلده',
        detail: 'السفارة الأقرب بالرياض، يمكن حجز موعد أو طلب مساعدة عاجلة عبر الهاتف.'
      }
    ],
    reminders: [
      'ركز على التعليمات الرسمية للزوار (أبشر، وزارة الخارجية، الجوازات).',
      'قدّم روابط أو أسماء منصات واضحة بالإنجليزي مع ذكر المتطلبات الأساسية.'
    ],
    suggestions: [
      'ابي امدد تأشيرة الزيارة',
      'كيف اتواصل مع اقرب سفارة؟',
      'ابي اعرف شروط السفر داخل السعودية',
      'وش الخدمات المتاحة للضيوف والزوار؟'
    ],
    greeting: (user) => {
      const firstName = user.name.split(' ')[0] || user.name;
      return `هلا ${firstName}! انا سارة، مستعدة أساعدك كضيف في السعودية. وش الخدمة اللي تحتاجها؟`;
    },
    voiceGreeting: (user) => {
      const firstName = user.name.split(' ')[0] || user.name;
      return `هلا ${firstName}! انا سارة من مركز الضيوف، كيف اخدمك اليوم؟`;
    }
  }
};

const baseRules = `قواعد المحادثة لسارة:
- استخدمي اللهجة النجدية الواضحة، وجمل قصيرة مباشرة.
- راجعي بيانات المستخدم قبل أي إجابة، وذكّريه بالحالات أو المواعيد المهمة المرتبطة بخدماته.
- إذا طلب خدمة محددة، اذكري الخطوات الرسمية على منصة أبشر أو الجهة المختصة، وحددي الروابط أو الأقسام إن أمكن.
- لو الخدمة تعتمد على حالة معينة (منتهية، جاهزة للتفعيل)، بيّني المطلوب منك بدقة وخلي النصائح واقعية.
- قدمي خيارات إضافية أو نصائح استباقية لو لاحظتي خدمة منتهية أو موعد قريب.
- لو ما توفر حل إلكتروني، وجّهيه للاتصال أو الزيارة مع ذكر الرقم أو الجهة المناسبة.
- استخدمي تنسيقات Markdown البسيطة (قوائم مرقمة، نقاط، إبراز) لما تبغين توضّحين خطوات أو رموز.`;

const defaultGreeting = 'هلا! انا سارة، وش تحب ننجزه اليوم؟';
const defaultVoiceGreeting = 'هلا! انا سارة، علمني وش تحتاج؟';

export interface AssistantProfile {
  context: string;
  suggestions: string[];
  greeting: string;
  voiceGreeting: string;
}

export function buildAssistantContext(userData: UserData | null): AssistantProfile {
  if (!userData) {
    return {
      context: `${baseRules}\n\nما عندي بيانات مستخدم حالياً، فتعاملي يكون عام لكل المواطنين.`,
      suggestions: defaultSuggestions,
      greeting: defaultGreeting,
      voiceGreeting: defaultVoiceGreeting
    };
  }

  const profile = scenarioProfiles[userData.scenario];

  const servicesList = profile.services
    .map((service, index) => `${index + 1}. ${service.name} — الحالة: ${service.status}. ${service.detail}`)
    .join('\n');

  const remindersText = profile.reminders && profile.reminders.length > 0
    ? `\nملاحظات هامة:\n- ${profile.reminders.join('\n- ')}`
    : '';

  const context = `بيانات المستخدم المؤكدة:\n- الاسم: ${userData.name}\n- رقم الهوية: ${userData.saudiId}\n- السيناريو: ${profile.label}\n- الموقع الحالي: ${userData.city}\n- رقم التواصل: ${userData.phone}\n\nملخص الحالة:\n${profile.description}\n\nالخدمات الحالية ووضعها:\n${servicesList}${remindersText}\n\n${baseRules}`;

  return {
    context,
    suggestions: profile.suggestions.length ? profile.suggestions : defaultSuggestions,
    greeting: profile.greeting(userData) || defaultGreeting,
    voiceGreeting: (profile.voiceGreeting && profile.voiceGreeting(userData)) || profile.greeting(userData) || defaultVoiceGreeting
  };
}
