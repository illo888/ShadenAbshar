import '../../config/constants.dart';

/// Validate Saudi ID (must be 10 digits starting with 1)
bool validateSaudiId(String id) {
  return RegExp(r'^1\d{9}$').hasMatch(id);
}

/// Determine scenario based on last digit of Saudi ID
/// This mimics the old React Native logic
String determineScenario(String id) {
  if (!validateSaudiId(id)) return AppConstants.scenarioGuest;
  
  final lastDigit = int.parse(id[id.length - 1]);

  // Mock logic (same as old app):
  // last digit 0-2 => safe_gate (outside KSA with privileges)
  // 3-6 => in_saudi (active services)
  // 7-8 => elder (simple mode)
  // 9 => guest
  if ([0, 1, 2].contains(lastDigit)) {
    return AppConstants.scenarioSafeGate;
  } else if ([3, 4, 5, 6].contains(lastDigit)) {
    return AppConstants.scenarioInSaudi;
  } else if ([7, 8].contains(lastDigit)) {
    return AppConstants.scenarioElder;
  } else {
    return AppConstants.scenarioGuest;
  }
}

/// Get scenario display name in Arabic
String getScenarioNameAr(String scenario) {
  switch (scenario) {
    case AppConstants.scenarioSafeGate:
      return 'البوابة الآمنة';
    case AppConstants.scenarioInSaudi:
      return 'داخل السعودية';
    case AppConstants.scenarioElder:
      return 'وضع كبار السن';
    case AppConstants.scenarioGuest:
      return 'مساعدة ضيف';
    default:
      return 'غير محدد';
  }
}

/// Get scenario description
String getScenarioDescription(String scenario) {
  switch (scenario) {
    case AppConstants.scenarioSafeGate:
      return 'خارج السعودية مع وصول كامل للخدمات';
    case AppConstants.scenarioInSaudi:
      return 'داخل السعودية مع جميع الخدمات النشطة';
    case AppConstants.scenarioElder:
      return 'واجهة مبسطة لكبار السن';
    case AppConstants.scenarioGuest:
      return 'مساعدة طوارئ للزوار';
    default:
      return '';
  }
}
