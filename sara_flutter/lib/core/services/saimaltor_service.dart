import '../models/message_model.dart';
import '../models/user_model.dart';

class SaimaltorActionResult {
  final String message;
  final List<CTAAction>? ctas;
  final String reference;
  final String status; // 'success', 'pending', 'error'

  const SaimaltorActionResult({
    required this.message,
    this.ctas,
    required this.reference,
    required this.status,
  });
}

class SaimaltorService {
  static final _serviceHandlers = <String, Function>{
    'renew-passport': _renewPassport,
    'renew-id-card': _renewIdCard,
    'issue-travel-permit': _issueTravelPermit,
    'update-address': _updateAddress,
    'pay-traffic-ticket': _payTrafficTicket,
    'vehicle-registration': _vehicleRegistration,
    'schedule-appointment': _scheduleAppointment,
    'family-visit-visa': _familyVisitVisa,
    'extend-visit-visa': _extendVisitVisa,
    'report-lost-id': _reportLostId,
    'download-passport': _downloadPassport,
    'email-passport': _emailPassport,
    'share-tracking': _shareTracking,
    'open-dashboard': _openDashboard,
  };

  Future<SaimaltorActionResult> executeAction({
    required String action,
    UserModel? user,
  }) async {
    if (!action.startsWith('saimaltor:')) {
      throw Exception('Action يجب أن يبدأ بـ saimaltor:');
    }

    final descriptor = _parseDescriptor(action);
    final handler = _serviceHandlers[descriptor.name];

    if (handler == null) {
      return _handleGeneric(descriptor, user);
    }

    return await handler(descriptor, user);
  }

  static ActionDescriptor _parseDescriptor(String action) {
    final trimmed = action.replaceFirst('saimaltor:', '').trim();
    final parts = trimmed.split('?');
    final name = parts[0].trim();
    final params = parts.length > 1 ? _parseQuery(parts[1]) : <String, String>{};

    return ActionDescriptor(raw: trimmed, name: name, params: params);
  }

  static Map<String, String> _parseQuery(String query) {
    if (query.isEmpty) return {};
    return Map.fromEntries(
      query.split('&').map((pair) {
        final kv = pair.split('=');
        return MapEntry(
          kv[0],
          kv.length > 1 ? Uri.decodeComponent(kv[1]) : '',
        );
      }),
    );
  }

  static String _resolveBeneficiary(UserModel? user) {
    if (user == null) return 'صاحب الحساب';
    return user.name;
  }

  static SaimaltorActionResult _buildSuccess(
    String title,
    List<String> bullets,
    List<CTAAction>? ctas,
    String status,
  ) {
    final reference = _generateReference(status == 'pending' ? 'PEN' : 'ABS');
    final details = bullets.map((line) => '• $line').join('\n');
    final message = '✅ $title\n$details\nرقم الطلب: `$reference`';

    return SaimaltorActionResult(
      message: message,
      ctas: ctas,
      reference: reference,
      status: status,
    );
  }

  static String _generateReference(String prefix) {
    final random = DateTime.now().millisecondsSinceEpoch % 900000 + 100000;
    return '$prefix-$random';
  }

  // Service Handlers
  static Future<SaimaltorActionResult> _renewPassport(
    ActionDescriptor desc,
    UserModel? user,
  ) async {
    return _buildSuccess(
      'خلصت تجديد جواز ${_resolveBeneficiary(user)} لمدة ١٠ سنوات',
      [
        'أرسلت النسخة الرقمية لحساب أبشر وفعّلت جواز السفر فوراً',
        'وصلتك رسالة نصية على جوالك بتأكيد الدفع'
      ],
      [
        const CTAAction(
          id: 'download-1',
          label: 'تحميل الجواز الرقمي',
          action: 'saimaltor:download-passport?target=self',
          variant: 'primary',
        ),
        const CTAAction(
          id: 'print-1',
          label: 'اطبع إيصال الدفع',
          action: 'saimaltor:share-tracking?channel=email',
          variant: 'secondary',
        ),
      ],
      'success',
    );
  }

  static Future<SaimaltorActionResult> _renewIdCard(
    ActionDescriptor desc,
    UserModel? user,
  ) async {
    return _buildSuccess(
      'جددت الهوية الوطنية لـ ${_resolveBeneficiary(user)}',
      [
        'الهوية متاحة في المحفظة الوطنية',
        'أقرب موعد للاستلام من مكتب الأحوال في الملز بكرة الساعة ١١:٣٠ ص'
      ],
      [
        const CTAAction(
          id: 'schedule-1',
          label: 'ارسل الدعوة للاستلام',
          action: 'saimaltor:schedule-appointment?office=ahwal-malz',
          variant: 'primary',
        ),
        const CTAAction(
          id: 'track-1',
          label: 'تتبع الشحن',
          action: 'saimaltor:share-tracking?channel=sms',
          variant: 'secondary',
        ),
      ],
      'success',
    );
  }

  static Future<SaimaltorActionResult> _issueTravelPermit(
    ActionDescriptor desc,
    UserModel? user,
  ) async {
    final dependent = desc.params['dependent'] ?? 'التابع';
    final duration = desc.params['duration'] ?? '٣٠';
    return _buildSuccess(
      'طلعت تصريح سفر $dependent (${_resolveBeneficiary(user)})',
      [
        'المدة تمتد لـ $duration يوم',
        'أرسلت نسخة للتابع على تطبيق توكلنا'
      ],
      [
        const CTAAction(
          id: 'cancel-1',
          label: 'إلغاء التصريح',
          action: 'saimaltor:cancel-travel-permit',
          variant: 'secondary',
        ),
        const CTAAction(
          id: 'issue-2',
          label: 'اصدار تصريح ثاني',
          action: 'saimaltor:issue-travel-permit?dependent=آخر',
          variant: 'primary',
        ),
      ],
      'success',
    );
  }

  static Future<SaimaltorActionResult> _updateAddress(
    ActionDescriptor desc,
    UserModel? user,
  ) async {
    final district = desc.params['district'] ?? 'الندى';
    final street = desc.params['street'] ?? 'طريق الملك سعود';
    return _buildSuccess(
      'حدّثت عنوان ${_resolveBeneficiary(user)} في كل الجهات الحكومية',
      [
        'الحي: $district, الشارع: $street',
        'السيستم حدّث توصيل الوثائق والمرور والبريد الوطني'
      ],
      [
        const CTAAction(
          id: 'share-1',
          label: 'أرسل إثبات العنوان',
          action: 'saimaltor:share-tracking?channel=download',
          variant: 'primary',
        ),
        const CTAAction(
          id: 'schedule-2',
          label: 'حجز موعد تسليم',
          action: 'saimaltor:schedule-appointment?service=address-proof',
          variant: 'secondary',
        ),
      ],
      'success',
    );
  }

  static Future<SaimaltorActionResult> _payTrafficTicket(
    ActionDescriptor desc,
    UserModel? user,
  ) async {
    final ticket = desc.params['ticket'] ?? '748201';
    final amount = desc.params['amount'] ?? '٣٠٠';
    return _buildSuccess(
      'سددت مخالفة رقم $ticket',
      [
        'الرسوم $amount ريال تم خصمها من بطاقة مدى',
        'وصل إشعار للمرور والسجل اتمسح من سجلك'
      ],
      [
        const CTAAction(
          id: 'download-2',
          label: 'حمّل إيصال السداد',
          action: 'saimaltor:share-tracking?channel=download',
          variant: 'primary',
        ),
        const CTAAction(
          id: 'dispute-1',
          label: 'اعترض على مخالفة ثانية',
          action: 'saimaltor:file-traffic-dispute',
          variant: 'secondary',
        ),
      ],
      'success',
    );
  }

  static Future<SaimaltorActionResult> _vehicleRegistration(
    ActionDescriptor desc,
    UserModel? user,
  ) async {
    final plate = desc.params['plate'] ?? 'ح ك د 3219';
    return _buildSuccess(
      'جددت استمارة مركبة اللوحة $plate',
      [
        'الفحص الدوري اتحقق إلكترونياً وكل شي تمام',
        'الإستمارة الرقمية مفعلة في تطبيق المركبات'
      ],
      [
        const CTAAction(
          id: 'share-2',
          label: 'أرسل الاستمارة',
          action: 'saimaltor:share-registration?channel=email',
          variant: 'primary',
        ),
        const CTAAction(
          id: 'schedule-3',
          label: 'حجز فحص جديد',
          action: 'saimaltor:schedule-appointment?service=vehicle',
          variant: 'secondary',
        ),
      ],
      'success',
    );
  }

  static Future<SaimaltorActionResult> _scheduleAppointment(
    ActionDescriptor desc,
    UserModel? user,
  ) async {
    final office = desc.params['office'] ?? 'الأحوال - الياسمين';
    final date = desc.params['date'] ?? 'الإثنين الجاي';
    final time = desc.params['time'] ?? '٩:١٥ صباحاً';
    return _buildSuccess(
      'حجزت موعد عن طريق أبشر',
      [
        'الموقع: $office',
        'التاريخ: $date الساعة $time'
      ],
      [
        const CTAAction(
          id: 'calendar-1',
          label: 'أضف للرزنامة',
          action: 'saimaltor:add-calendar-event',
          variant: 'primary',
        ),
        const CTAAction(
          id: 'modify-1',
          label: 'غيّر الموعد',
          action: 'saimaltor:schedule-appointment?modify=true',
          variant: 'secondary',
        ),
      ],
      'success',
    );
  }

  static Future<SaimaltorActionResult> _familyVisitVisa(
    ActionDescriptor desc,
    UserModel? user,
  ) async {
    final guest = desc.params['guest'] ?? 'الزائر';
    return _buildSuccess(
      'رفعت طلب تأشيرة زيارة عائلية لـ $guest',
      [
        'المستفيد الرئيسي: ${_resolveBeneficiary(user)}',
        'الطلب قيد التحقق مع وزارة الخارجية (ياخذ عادة ٢٤ ساعة)'
      ],
      [
        const CTAAction(
          id: 'download-3',
          label: 'حمّل ملف الطلب',
          action: 'saimaltor:share-tracking?channel=download',
          variant: 'primary',
        ),
        const CTAAction(
          id: 'add-guest-1',
          label: 'اضف زائر ثاني',
          action: 'saimaltor:family-visit-visa?guest=آخر',
          variant: 'secondary',
        ),
      ],
      'pending',
    );
  }

  static Future<SaimaltorActionResult> _extendVisitVisa(
    ActionDescriptor desc,
    UserModel? user,
  ) async {
    final guest = desc.params['guest'] ?? _resolveBeneficiary(user);
    final extraDays = desc.params['extraDays'] ?? '٩٠';
    return _buildSuccess(
      'مددت تأشيرة الزيارة لـ $guest',
      [
        'التمديد $extraDays يوم حسب الأنظمة',
        'بقي فقط دفع رسوم المتأخرات لو فيه'
      ],
      [
        const CTAAction(
          id: 'pay-1',
          label: 'سدد الرسوم الآن',
          action: 'saimaltor:pay-visa-extension',
          variant: 'primary',
        ),
        const CTAAction(
          id: 'share-3',
          label: 'أرسل التأكيد للضيف',
          action: 'saimaltor:share-tracking?channel=whatsapp',
          variant: 'secondary',
        ),
      ],
      'success',
    );
  }

  static Future<SaimaltorActionResult> _reportLostId(
    ActionDescriptor desc,
    UserModel? user,
  ) async {
    return _buildSuccess(
      'رفعت بلاغ فقدان هوية لـ ${_resolveBeneficiary(user)}',
      [
        'تعطلت الهوية الحالية فوراً لمنع استخدامها',
        'فتحت طلب إصدار بديل وشحنته لعنونك الوطني'
      ],
      [
        const CTAAction(
          id: 'schedule-4',
          label: 'حجز موعد تصوير',
          action: 'saimaltor:schedule-appointment?service=id-photo',
          variant: 'primary',
        ),
        const CTAAction(
          id: 'track-2',
          label: 'تتبع الشحنة',
          action: 'saimaltor:share-tracking?channel=sms',
          variant: 'secondary',
        ),
      ],
      'success',
    );
  }

  static Future<SaimaltorActionResult> _downloadPassport(
    ActionDescriptor desc,
    UserModel? user,
  ) async {
    return _buildSuccess(
      'جهزت نسخة الـ PDF المشفّرة للجواز',
      ['حميتها بباسورد آخر أربعة أرقام من هويتك'],
      [
        const CTAAction(
          id: 'open-1',
          label: 'افتح التنزيل',
          action: 'saimaltor:share-tracking?channel=download',
          variant: 'primary',
        ),
        const CTAAction(
          id: 'email-1',
          label: 'ارسل على البريد',
          action: 'saimaltor:email-passport',
          variant: 'secondary',
        ),
      ],
      'success',
    );
  }

  static Future<SaimaltorActionResult> _emailPassport(
    ActionDescriptor desc,
    UserModel? user,
  ) async {
    return _buildSuccess(
      'أرسلت الجواز الرقمي على ايميلك المسجل',
      ['تلقى رسالة من noreply@saimaltor.sa خلال ثواني'],
      [
        const CTAAction(
          id: 'resend-1',
          label: 'ارسل نسخة ثانية',
          action: 'saimaltor:email-passport?alt=true',
          variant: 'secondary',
        ),
        const CTAAction(
          id: 'dashboard-1',
          label: 'اطلب خدمة ثانية',
          action: 'saimaltor:open-dashboard',
          variant: 'primary',
        ),
      ],
      'success',
    );
  }

  static Future<SaimaltorActionResult> _shareTracking(
    ActionDescriptor desc,
    UserModel? user,
  ) async {
    final channel = desc.params['channel'] ?? 'SMS';
    return _buildSuccess(
      'شاركت رقم التتبع مع القناة المطلوبة',
      ['القناة: $channel'],
      [
        const CTAAction(
          id: 'copy-1',
          label: 'انسخ الرابط',
          action: 'saimaltor:open-dashboard',
          variant: 'primary',
        ),
        const CTAAction(
          id: 'resend-2',
          label: 'أعد الإرسال',
          action: 'saimaltor:share-tracking?channel=email',
          variant: 'secondary',
        ),
      ],
      'success',
    );
  }

  static Future<SaimaltorActionResult> _openDashboard(
    ActionDescriptor desc,
    UserModel? user,
  ) async {
    return _buildSuccess(
      'فتحت لك لوحة خدمات أبشر في Saimaltor',
      ['تقدر تختار أي خدمة وتطلبها فوراً'],
      [
        const CTAAction(
          id: 'dashboard-2',
          label: 'اطلب خدمة ثانية',
          action: 'saimaltor:open-dashboard',
          variant: 'primary',
        ),
      ],
      'success',
    );
  }

  static Future<SaimaltorActionResult> _handleGeneric(
    ActionDescriptor desc,
    UserModel? user,
  ) async {
    final friendlyName = desc.name.replaceAll('-', ' ');
    return _buildSuccess(
      'انتهيت من خدمة $friendlyName عبر بوابة Saimaltor',
      [
        'تمت معالجة الطلب لصالح ${_resolveBeneficiary(user)}',
        'أرسلت لك تفاصيل الخدمة في الإشعارات'
      ],
      [
        const CTAAction(
          id: 'dashboard-3',
          label: 'اطلب شي ثاني',
          action: 'saimaltor:open-dashboard',
          variant: 'primary',
        ),
      ],
      'success',
    );
  }
}

class ActionDescriptor {
  final String raw;
  final String name;
  final Map<String, String> params;

  const ActionDescriptor({
    required this.raw,
    required this.name,
    required this.params,
  });
}
