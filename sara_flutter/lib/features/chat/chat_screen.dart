import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/theme/colors.dart';
import '../../core/models/message_model.dart';
import '../../core/providers/chat_provider.dart';
import '../../core/providers/user_provider.dart';
import '../../core/services/sara_voice_service.dart';
import '../../widgets/ai_wave.dart';
import '../../widgets/chat_bubble.dart';
import '../../widgets/voice_recorder.dart';
import '../voice_call/voice_call_screen.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final SaraVoiceService _voiceService = SaraVoiceService();
  bool _isTtsEnabled = true;
  WaveState _waveState = WaveState.idle;

  @override
  void initState() {
    super.initState();
    _initializeVoiceService();
    
    // Send welcome message on first load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final messages = ref.read(chatProvider);
      if (messages.isEmpty) {
        _sendWelcomeMessage();
      }
    });
  }
  
  void _initializeVoiceService() {
    _voiceService.onRecordingChange = (isRecording) {
      if (mounted) {
        setState(() {
          _waveState = isRecording ? WaveState.listening : WaveState.idle;
        });
      }
    };
    
    _voiceService.onSaraRespondingChange = (isResponding) {
      if (mounted) {
        setState(() {
          _waveState = isResponding ? WaveState.answering : WaveState.idle;
        });
      }
    };
    
    _voiceService.onUserSpoke = (text) {
      if (mounted) {
        _addMessageToChat(text, isUser: true);
      }
    };
    
    _voiceService.onSaraResponded = (text) {
      if (mounted) {
        _addMessageToChat(text, isUser: false);
      }
    };
    
    _voiceService.onError = (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error),
            backgroundColor: Colors.red,
          ),
        );
      }
    };
    
    // Connect to Sara voice service - don't connect automatically
    // Only connect when user initiates voice call
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    _voiceService.dispose();
    super.dispose();
  }

  void _sendWelcomeMessage() {
    final user = ref.read(userProvider);
    final userName = user?.name ?? 'يا هلا';
    
    final welcomeText = '''
السلام عليكم $userName! 👋

أنا **سارة**، مساعدتك الذكية للخدمات الحكومية. أقدر أساعدك في:

• تجديد الجواز والهوية الوطنية
• استخراج تصاريح السفر
• دفع المخالفات المرورية
• حجز المواعيد
• وأكثر من ذلك بكثير...

**وش تحتاج اليوم؟** 🌟
''';
    
    ref.read(chatProvider.notifier).addWelcomeMessage(welcomeText);
    setState(() => _waveState = WaveState.welcoming);
    
    // Return to idle after welcome animation
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _waveState = WaveState.idle);
    });
  }

  Future<void> _sendTextMessage() async {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    _textController.clear();
    setState(() => _waveState = WaveState.thinking);

    await ref.read(chatProvider.notifier).sendMessage(text);
    
    setState(() => _waveState = WaveState.answering);
    _scrollToBottom();
    
    // Return to idle after response
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _waveState = WaveState.idle);
    });
  }

  void _addMessageToChat(String text, {required bool isUser}) {
    final message = MessageModel(
      id: DateTime.now().millisecondsSinceEpoch,
      role: isUser ? 'user' : 'assistant',
      text: text,
      ctas: null,
    );
    
    ref.read(chatProvider.notifier).addMessageDirect(message);
    _scrollToBottom();
  }

  void _onVoiceTranscription(String transcription) {
    _textController.text = transcription;
    _sendTextMessage();
  }

  void _onCtaTap(String ctaId) async {
    // Find the CTA in recent messages
    final messages = ref.read(chatProvider);
    for (final message in messages.reversed) {
      if (message.ctas != null) {
        final cta = message.ctas!.firstWhere(
          (c) => c.id == ctaId,
          orElse: () => message.ctas!.first,
        );
        
        setState(() => _waveState = WaveState.thinking);
        await ref.read(chatProvider.notifier).executeCTA(cta);
        setState(() => _waveState = WaveState.answering);
        _scrollToBottom();
        
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) setState(() => _waveState = WaveState.idle);
        });
        break;
      }
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(chatProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.smart_toy_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'سارة',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'متصلة',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.success,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          // Voice Call Button
          IconButton(
            icon: const Icon(
              Icons.call,
              color: AppColors.primary,
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const VoiceCallScreen(),
                ),
              );
            },
          ),
          // TTS Toggle
          IconButton(
            icon: Icon(
              _isTtsEnabled ? Icons.volume_up_rounded : Icons.volume_off_rounded,
              color: _isTtsEnabled ? AppColors.primary : AppColors.textSecondary,
            ),
            onPressed: () {
              setState(() => _isTtsEnabled = !_isTtsEnabled);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    _isTtsEnabled ? 'القراءة الصوتية مفعلة' : 'القراءة الصوتية معطلة',
                  ),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
          ),
          // Clear Chat
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded),
            onPressed: () {
              ref.read(chatProvider.notifier).clearChat();
              _sendWelcomeMessage();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // AI Wave Indicator
          if (_waveState != WaveState.idle)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: AIWave(
                state: _waveState,
                size: 80,
              ),
            ),
          
          // Messages List
          Expanded(
            child: messages.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AIWave(
                          state: _waveState,
                          size: 120,
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'مرحباً! كيف أقدر أساعدك؟',
                          style: TextStyle(
                            fontSize: 18,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      return ChatBubble(
                        message: message,
                        onCtaTap: () => _onCtaTap(
                          message.ctas?.first.id ?? '',
                        ),
                      );
                    },
                  ),
          ),
          
          // Input Area
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Column(
                children: [
                  // Voice Recorder
                  VoiceRecorder(
                    onTranscription: _onVoiceTranscription,
                    saraService: _voiceService,
                  ),
                  const SizedBox(height: 12),
                  
                  // Text Input Row
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _textController,
                          textDirection: TextDirection.rtl,
                          decoration: InputDecoration(
                            hintText: 'اكتب رسالتك هنا...',
                            hintTextDirection: TextDirection.rtl,
                            filled: true,
                            fillColor: AppColors.background,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                          ),
                          maxLines: null,
                          textInputAction: TextInputAction.send,
                          onSubmitted: (_) => _sendTextMessage(),
                        ),
                      ),
                      const SizedBox(width: 12),
                      
                      // Send Button
                      Container(
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.4),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.send_rounded,
                            color: Colors.white,
                          ),
                          onPressed: _sendTextMessage,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
