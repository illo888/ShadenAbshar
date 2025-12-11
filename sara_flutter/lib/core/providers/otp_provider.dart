import 'package:flutter_riverpod/flutter_riverpod.dart';

// Simple OTP state class (no freezed needed for internal state)
class OtpState {
  final String code;
  final DateTime? expiresAt;
  final int attempts;

  const OtpState({
    required this.code,
    this.expiresAt,
    this.attempts = 0,
  });
}

class OtpNotifier extends StateNotifier<OtpState> {
  OtpNotifier()
      : super(const OtpState(
          code: '',
          expiresAt: null,
          attempts: 0,
        ));

  void generateOtp(String phoneNumber) {
    // Generate 6-digit OTP
    final code = (100000 + DateTime.now().millisecondsSinceEpoch % 900000)
        .toString();
    final expiresAt = DateTime.now().add(const Duration(minutes: 5));

    state = OtpState(
      code: code,
      expiresAt: expiresAt,
      attempts: 0,
    );

    // In production, this would call an SMS API
    // ignore: avoid_print
    print('🔐 OTP للرقم $phoneNumber: $code');
  }

  bool verifyOtp(String inputCode) {
    if (state.expiresAt == null) return false;
    if (DateTime.now().isAfter(state.expiresAt!)) {
      // Expired
      state = OtpState(
        code: state.code,
        expiresAt: state.expiresAt,
        attempts: state.attempts + 1,
      );
      return false;
    }

    final isValid = inputCode == state.code;
    
    state = OtpState(
      code: state.code,
      expiresAt: state.expiresAt,
      attempts: state.attempts + 1,
    );

    return isValid;
  }

  void resendOtp(String phoneNumber) {
    generateOtp(phoneNumber);
  }

  void clearOtp() {
    state = const OtpState(
      code: '',
      expiresAt: null,
      attempts: 0,
    );
  }

  bool get isExpired {
    if (state.expiresAt == null) return true;
    return DateTime.now().isAfter(state.expiresAt!);
  }

  Duration? get timeRemaining {
    if (state.expiresAt == null) return null;
    if (isExpired) return null;
    return state.expiresAt!.difference(DateTime.now());
  }
}

final otpProvider = StateNotifierProvider<OtpNotifier, OtpState>((ref) {
  return OtpNotifier();
});
