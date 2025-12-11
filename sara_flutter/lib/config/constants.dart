class AppConstants {
  // API Configuration
  static const String groqApiKey = String.fromEnvironment(
    'GROQ_API_KEY',
    defaultValue: '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',
  );
  static const String groqBaseUrl = 'https://api.groq.com/openai/v1';
  static const String groqChatModel = 'llama-3.3-70b-versatile';
  static const String groqWhisperModel = 'whisper-large-v3';
  
  // App Info
  static const String appName = 'سارا';
  static const String appNameEnglish = 'SARA';
  static const String appSubtitle = 'مساعدتك الذكية';
  
  // Scenarios
  static const String scenarioSafeGate = 'safe_gate';
  static const String scenarioInSaudi = 'in_saudi';
  static const String scenarioElder = 'elder';
  static const String scenarioGuest = 'guest';
  
  // Animation Durations
  static const Duration shortDuration = Duration(milliseconds: 300);
  static const Duration mediumDuration = Duration(milliseconds: 600);
  static const Duration longDuration = Duration(milliseconds: 1000);
  
  // Delays
  static const Duration splashDelay = Duration(seconds: 3);
  static const Duration typingDelay = Duration(milliseconds: 1500);
  
  // Limits
  static const int maxMessageLength = 500;
  static const int maxHistoryLength = 10;
  static const int maxOtpMessages = 5;
  
  // Disable constructor
  const AppConstants._();
}
