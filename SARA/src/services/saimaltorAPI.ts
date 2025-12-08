export type CTAIntentVariant = 'primary' | 'secondary';

export interface CTAIntent {
  label: string;
  action: string;
  variant?: CTAIntentVariant;
}

export interface SaimaltorActionResult {
  message: string;
  ctas?: CTAIntent[];
  reference: string;
  status: 'success' | 'pending' | 'error';
}

interface BasicUser {
  name?: string;
  nationalId?: string;
  saudiId?: string;
}

interface ExecuteOptions {
  user?: BasicUser | null;
}

interface Descriptor {
  raw: string;
  name: string;
  params: Record<string, string>;
}

interface HandlerContext extends ExecuteOptions {
  descriptor: Descriptor;
}

type ServiceHandler = (ctx: HandlerContext) => SaimaltorActionResult | Promise<SaimaltorActionResult>;

const SERVICE_MAP: Record<string, ServiceHandler> = {
  'renew-passport': ({ user }) =>
    buildSuccess(
      `خلصت تجديد جواز ${resolveBeneficiary(user)} لمدة ١٠ سنوات`,
      [
        'أرسلت النسخة الرقمية لحساب أبشر وفعّلت جواز السفر فوراً',
        'وصلتك رسالة نصية على جوالك بتأكيد الدفع'
      ],
      [
        { label: 'تحميل الجواز الرقمي', action: 'saimaltor:download-passport?target=self', variant: 'primary' },
        { label: 'اطبع إيصال الدفع', action: 'saimaltor:share-tracking?channel=email', variant: 'secondary' }
      ]
    ),
  'renew-id-card': ({ user }) =>
    buildSuccess(
      `جددت الهوية الوطنية لـ ${resolveBeneficiary(user)}`,
      [
        'الهوية digitReady متاحة في المحفظة الوطنية',
        'أقرب موعد للاستلام من مكتب الأحوال في الملز بكرة الساعة ١١:٣٠ ص'
      ],
      [
        { label: 'ارسل الدعوة للاستلام', action: 'saimaltor:schedule-appointment?office=ahwal-malz', variant: 'primary' },
        { label: 'تتبع الشحن', action: 'saimaltor:share-tracking?channel=sms', variant: 'secondary' }
      ]
    ),
  'issue-travel-permit': ({ descriptor, user }) =>
    buildSuccess(
      `طلعت تصريح سفر ${(descriptor.params.dependent || 'التابع')} (${resolveBeneficiary(user)})`,
      [
        descriptor.params.duration ? `المدة تمتد لـ ${descriptor.params.duration} يوم` : 'التصريح صالح لمدة ٣٠ يوم',
        'أرسلت نسخة للتابع على تطبيق توكلنا'
      ],
      [
        { label: 'إلغاء التصريح', action: 'saimaltor:cancel-travel-permit', variant: 'secondary' },
        { label: 'اصدار تصريح ثاني', action: 'saimaltor:issue-travel-permit?dependent=آخر', variant: 'primary' }
      ]
    ),
  'update-address': ({ descriptor, user }) =>
    buildSuccess(
      `حدّثت عنوان ${resolveBeneficiary(user)} في كل الجهات الحكومية`,
      [
        `الحي: ${descriptor.params.district || 'الندى'}, الشارع: ${descriptor.params.street || 'طريق الملك سعود'}`,
        'السيستم حدّث توصيل الوثائق والمرور والبريد الوطني'
      ],
      [
        { label: 'أرسل إثبات العنوان', action: 'saimaltor:share-tracking?channel=download', variant: 'primary' },
        { label: 'حجز موعد تسليم', action: 'saimaltor:schedule-appointment?service=address-proof', variant: 'secondary' }
      ]
    ),
  'pay-traffic-ticket': ({ descriptor }) =>
    buildSuccess(
      `سددت مخالفة رقم ${descriptor.params.ticket || '748201'}`,
      [
        descriptor.params.amount ? `الرسوم ${descriptor.params.amount} ريال تم خصمها من بطاقة مدى` : 'المبلغ ٣٠٠ ريال تم خصمه من بطاقة مدى',
        'وصل إشعار للمرور والسجل اتمسح من سجلك'
      ],
      [
        { label: 'حمّل إيصال السداد', action: 'saimaltor:share-tracking?channel=download', variant: 'primary' },
        { label: 'اعترض على مخالفة ثانية', action: 'saimaltor:file-traffic-dispute', variant: 'secondary' }
      ]
    ),
  'vehicle-registration': ({ descriptor }) =>
    buildSuccess(
      `جددت استمارة مركبة اللوحة ${descriptor.params.plate || 'ح ك د 3219'}`,
      [
        'الفحص الدوري اتحقق إلكترونياً وكل شي تمام',
        'الإستمارة الرقمية مفعلة في تطبيق المركبات'
      ],
      [
        { label: 'أرسل الاستمارة', action: 'saimaltor:share-registration?channel=email', variant: 'primary' },
        { label: 'حجز فحص جديد', action: 'saimaltor:schedule-appointment?service=vehicle', variant: 'secondary' }
      ]
    ),
  'schedule-appointment': ({ descriptor }) =>
    buildSuccess(
      'حجزت موعد عن طريق أبشر',
      [
        `الموقع: ${descriptor.params.office || 'الأحوال - الياسمين'}`,
        `التاريخ: ${descriptor.params.date || 'الإثنين الجاي'} الساعة ${descriptor.params.time || '٩:١٥ صباحاً'}`
      ],
      [
        { label: 'أضف للرزنامة', action: 'saimaltor:add-calendar-event', variant: 'primary' },
        { label: 'غيّر الموعد', action: 'saimaltor:schedule-appointment?modify=true', variant: 'secondary' }
      ]
    ),
  'family-visit-visa': ({ descriptor, user }) =>
    buildSuccess(
      `رفعت طلب تأشيرة زيارة عائلية لـ ${descriptor.params.guest || 'الزائر'}`,
      [
        `المستفيد الرئيسي: ${resolveBeneficiary(user)}`,
        'الطلب قيد التحقق مع وزارة الخارجية (ياخذ عادة ٢٤ ساعة)'
      ],
      [
        { label: 'حمّل ملف الطلب', action: 'saimaltor:share-tracking?channel=download', variant: 'primary' },
        { label: 'اضف زائر ثاني', action: 'saimaltor:family-visit-visa?guest=آخر', variant: 'secondary' }
      ],
      'pending'
    ),
  'extend-visit-visa': ({ descriptor, user }) =>
    buildSuccess(
      `مددت تأشيرة الزيارة لـ ${descriptor.params.guest || resolveBeneficiary(user)}`,
      [
        descriptor.params.extraDays ? `التمديد ${descriptor.params.extraDays} يوم` : 'التمديد ٩٠ يوم حسب الأنظمة',
        'بقي فقط دفع رسوم المتأخرات لو فيه'
      ],
      [
        { label: 'سدد الرسوم الآن', action: 'saimaltor:pay-visa-extension', variant: 'primary' },
        { label: 'أرسل التأكيد للضيف', action: 'saimaltor:share-tracking?channel=whatsapp', variant: 'secondary' }
      ]
    ),
  'report-lost-id': ({ user }) =>
    buildSuccess(
      `رفعت بلاغ فقدان هوية لـ ${resolveBeneficiary(user)}`,
      [
        'تعطلت الهوية الحالية فوراً لمنع استخدامها',
        'فتحت طلب إصدار بديل وشحنته لعنونك الوطني'
      ],
      [
        { label: 'حجز موعد تصوير', action: 'saimaltor:schedule-appointment?service=id-photo', variant: 'primary' },
        { label: 'تتبع الشحنة', action: 'saimaltor:share-tracking?channel=sms', variant: 'secondary' }
      ]
    ),
  'download-passport': () =>
    buildSuccess(
      'جهزت نسخة الـ PDF المشفّرة للجواز',
      ['حميتها بباسورد آخر أربعة أرقام من هويتك'],
      [
        { label: 'افتح التنزيل', action: 'saimaltor:share-tracking?channel=download', variant: 'primary' },
        { label: 'ارسل على البريد', action: 'saimaltor:email-passport', variant: 'secondary' }
      ]
    ),
  'email-passport': () =>
    buildSuccess(
      'أرسلت الجواز الرقمي على ايميلك المسجل',
      ['تلقى رسالة من noreply@saimaltor.sa خلال ثواني'],
      [
        { label: 'ارسل نسخة ثانية', action: 'saimaltor:email-passport?alt=true', variant: 'secondary' },
        { label: 'اطلب خدمة ثانية', action: 'saimaltor:open-dashboard', variant: 'primary' }
      ]
    ),
  'share-tracking': ({ descriptor }) =>
    buildSuccess(
      'شاركت رقم التتبع مع القناة المطلوبة',
      [`القناة: ${descriptor.params.channel || 'SMS'}`],
      [
        { label: 'انسخ الرابط', action: 'saimaltor:open-dashboard', variant: 'primary' },
        { label: 'أعد الإرسال', action: 'saimaltor:share-tracking?channel=email', variant: 'secondary' }
      ]
    ),
  'open-dashboard': () =>
    buildSuccess(
      'فتحت لك لوحة خدمات أبشر في Saimaltor',
      ['تقدر تختار أي خدمة وتطلبها فوراً'],
      [
        { label: 'اطلب خدمة ثانية', action: 'saimaltor:open-dashboard', variant: 'primary' }
      ]
    )
};

export async function executeSaimaltorAction(action: string, options: ExecuteOptions = {}): Promise<SaimaltorActionResult> {
  if (!action || !action.startsWith('saimaltor:')) {
    throw new Error('Action يجب أن يبدأ بـ saimaltor:');
  }

  const descriptor = parseDescriptor(action);
  const handler = SERVICE_MAP[descriptor.name] || handleGeneric;
  const result = await Promise.resolve(handler({ ...options, descriptor }));
  return result;
}

function handleGeneric({ descriptor, user }: HandlerContext): SaimaltorActionResult {
  const friendlyName = SERVICE_ALIASES[descriptor.name] || descriptor.name.replace(/-/g, ' ');
  return buildSuccess(
    `انتهيت من خدمة ${friendlyName} عبر بوابة Saimaltor`,
    [
      `تمت معالجة الطلب لصالح ${resolveBeneficiary(user)}`,
      descriptor.params.note ? `ملاحظتك: ${descriptor.params.note}` : 'أرسلت لك تفاصيل الخدمة في الإشعارات'
    ],
    [
      { label: 'اطلب شي ثاني', action: 'saimaltor:open-dashboard', variant: 'primary' }
    ]
  );
}

function parseDescriptor(action: string): Descriptor {
  const trimmed = action.replace('saimaltor:', '').trim();
  const [namePart, query = ''] = trimmed.split('?');
  return {
    raw: trimmed,
    name: namePart?.trim() || 'unknown',
    params: parseQuery(query)
  };
}

function parseQuery(query: string): Record<string, string> {
  if (!query) return {};
  return query.split('&').reduce<Record<string, string>>((acc, pair) => {
    const [key, value] = pair.split('=');
    if (!key) return acc;
    acc[key] = decodeURIComponent(value || '');
    return acc;
  }, {});
}

function resolveBeneficiary(user?: BasicUser | null): string {
  if (!user) return 'صاحب الحساب';
  return user.name || user.nationalId || user.saudiId || 'المستخدم';
}

function buildSuccess(title: string, bullets: string[], ctas?: CTAIntent[], status: 'success' | 'pending' | 'error' = 'success'): SaimaltorActionResult {
  const reference = generateReference(status === 'pending' ? 'PEN' : 'ABS');
  const details = bullets.map((line) => `• ${line}`).join('\n');
  const message = `✅ ${title}\n${details}\nرقم الطلب: \`${reference}\``;
  return {
    message,
    ctas,
    reference,
    status
  };
}

function generateReference(prefix: string): string {
  return `${prefix}-${Math.floor(100000 + Math.random() * 900000)}`;
}

const SERVICE_ALIASES: Record<string, string> = {
  'family-visit-visa': 'تأشيرة زيارة عائلية',
  'extend-visit-visa': 'تمديد الزيارة',
  'issue-travel-permit': 'تصريح سفر',
  'pay-traffic-ticket': 'سداد مخالفة',
  'renew-passport': 'تجديد جواز',
  'renew-id-card': 'تجديد هوية',
  'vehicle-registration': 'تجديد استمارة'
};
