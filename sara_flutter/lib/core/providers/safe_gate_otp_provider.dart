import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/otp_message.dart';

class SafeGateOtpState {
  final bool enabled;
  final List<OtpMessage> messages;

  SafeGateOtpState({
    required this.enabled,
    required this.messages,
  });

  SafeGateOtpState copyWith({
    bool? enabled,
    List<OtpMessage>? messages,
  }) {
    return SafeGateOtpState(
      enabled: enabled ?? this.enabled,
      messages: messages ?? this.messages,
    );
  }
}

class SafeGateOtpNotifier extends StateNotifier<SafeGateOtpState> {
  SafeGateOtpNotifier() : super(SafeGateOtpState(enabled: false, messages: []));

  void registerOtp() {
    state = state.copyWith(enabled: true);
  }

  void addOtpMessage(OtpMessage message) {
    final updatedMessages = [message, ...state.messages];
    // Keep only last 10 messages
    if (updatedMessages.length > 10) {
      updatedMessages.removeLast();
    }
    state = state.copyWith(messages: updatedMessages);
  }

  void clearMessages() {
    state = state.copyWith(messages: []);
  }
}

final safeGateOtpProvider = StateNotifierProvider<SafeGateOtpNotifier, SafeGateOtpState>((ref) {
  return SafeGateOtpNotifier();
});
