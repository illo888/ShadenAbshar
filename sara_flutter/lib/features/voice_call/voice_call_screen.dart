import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/theme/colors.dart';
import '../../core/services/sara_voice_service.dart';
import '../../widgets/ai_wave.dart';

enum CallState {
  connecting,
  listening,
  processing,
  speaking,
  ended,
}

class VoiceCallScreen extends ConsumerStatefulWidget {
  const VoiceCallScreen({super.key});

  @override
  ConsumerState<VoiceCallScreen> createState() => _VoiceCallScreenState();
}

class _VoiceCallScreenState extends ConsumerState<VoiceCallScreen>
    with SingleTickerProviderStateMixin {
  final SaraVoiceService _voiceService = SaraVoiceService();
  CallState _callState = CallState.connecting;
  final List<String> _transcript = [];
  int _callDuration = 0;
  bool _isMuted = false;
  bool _isSpeakerOn = true;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _initializePulseAnimation();
    _initializeVoiceService();
    _startCall();
  }

  void _initializePulseAnimation() {
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  void _initializeVoiceService() {
    _voiceService.onRecordingChange = (isRecording) {
      if (mounted) {
        setState(() {
          _callState = isRecording ? CallState.listening : CallState.processing;
        });
      }
    };

    _voiceService.onSaraRespondingChange = (isResponding) {
      if (mounted) {
        setState(() {
          _callState = isResponding ? CallState.speaking : CallState.listening;
        });
      }
    };

    _voiceService.onUserSpoke = (text) {
      if (mounted) {
        setState(() {
          _transcript.add('أنت: $text');
        });
      }
    };

    _voiceService.onSaraResponded = (text) {
      if (mounted) {
        setState(() {
          _transcript.add('سارة: $text');
        });
      }
    };

    _voiceService.onError = (error) {
      if (mounted) {
        setState(() {
          _transcript.add('خطأ: $error');
        });
      }
    };
  }

  Future<void> _startCall() async {
    try {
      setState(() => _callState = CallState.connecting);

      // Connect to service
      await _voiceService.connect();

      // Simulate connection delay
      await Future.delayed(const Duration(milliseconds: 800));

      // Add welcome message
      setState(() {
        _transcript.add('سارة: حياك! انا سارة. كيف اقدر اساعدك؟');
        _callState = CallState.listening;
      });

      // Start listening automatically
      await _startListening();
    } catch (e) {
      debugPrint('❌ Start call error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('عذراً، حدث خطأ أثناء بدء المكالمة'),
            backgroundColor: Colors.red,
          ),
        );
        _endCall();
      }
    }
  }

  Future<void> _startListening() async {
    if (_isMuted || _callState == CallState.ended) return;

    setState(() => _callState = CallState.listening);
    await _voiceService.startTalking();

    // Auto-stop after 10 seconds
    Future.delayed(const Duration(seconds: 10), () {
      if (_voiceService.isRecording) {
        _stopListening();
      }
    });
  }

  Future<void> _stopListening() async {
    if (!_voiceService.isRecording) return;

    setState(() => _callState = CallState.processing);
    await _voiceService.stopTalking();

    // Continue listening after response
    if (_callState != CallState.ended) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted && _callState != CallState.ended) {
          _startListening();
        }
      });
    }
  }

  void _toggleMute() {
    setState(() {
      _isMuted = !_isMuted;
      if (_isMuted && _voiceService.isRecording) {
        _stopListening();
      }
    });
  }

  void _toggleSpeaker() {
    setState(() => _isSpeakerOn = !_isSpeakerOn);
  }

  void _endCall() {
    setState(() => _callState = CallState.ended);
    _voiceService.dispose();
    Navigator.of(context).pop();
  }

  String _getCallStateText() {
    switch (_callState) {
      case CallState.connecting:
        return 'جاري الاتصال...';
      case CallState.listening:
        return 'استمع...';
      case CallState.processing:
        return 'جاري المعالجة...';
      case CallState.speaking:
        return 'سارة تتحدث...';
      case CallState.ended:
        return 'انتهت المكالمة';
    }
  }

  Color _getStateColor() {
    switch (_callState) {
      case CallState.listening:
        return AppColors.warning;
      case CallState.speaking:
        return AppColors.primary;
      case CallState.processing:
        return AppColors.secondary;
      default:
        return AppColors.textSecondary;
    }
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _voiceService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: _endCall,
                  ),
                  Text(
                    _formatDuration(_callDuration),
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),

            // Sara Avatar with Wave Animation
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Pulsing Avatar
                    AnimatedBuilder(
                      animation: _pulseAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: (_callState == CallState.listening ||
                                  _callState == CallState.speaking)
                              ? _pulseAnimation.value
                              : 1.0,
                          child: Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [
                                  _getStateColor(),
                                  _getStateColor().withOpacity(0.7),
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: _getStateColor().withOpacity(0.3),
                                  blurRadius: 30,
                                  spreadRadius: 10,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.smart_toy_rounded,
                              size: 80,
                              color: Colors.white,
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 30),

                    // Wave Animation
                    if (_callState == CallState.listening ||
                        _callState == CallState.speaking)
                      AIWave(
                        state: _callState == CallState.listening
                            ? WaveState.listening
                            : WaveState.answering,
                        size: 80,
                      ),

                    const SizedBox(height: 20),

                    // State Text
                    Text(
                      _getCallStateText(),
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: _getStateColor(),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Subtitle
                    Text(
                      _callState == CallState.listening
                          ? 'تكلم الآن...'
                          : 'المكالمة نشطة',
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Transcript
            Container(
              height: 150,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'النص:',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: ListView.builder(
                      reverse: true,
                      itemCount: _transcript.length,
                      itemBuilder: (context, index) {
                        final reversedIndex = _transcript.length - 1 - index;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text(
                            _transcript[reversedIndex],
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Control Buttons
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Mute Button
                  _buildControlButton(
                    icon: _isMuted ? Icons.mic_off : Icons.mic,
                    label: _isMuted ? 'كتم' : 'ميكروفون',
                    onPressed: _toggleMute,
                    color: _isMuted ? AppColors.error : AppColors.surface,
                  ),

                  // End Call Button
                  _buildControlButton(
                    icon: Icons.call_end,
                    label: 'إنهاء',
                    onPressed: _endCall,
                    color: AppColors.error,
                    isLarge: true,
                  ),

                  // Speaker Button
                  _buildControlButton(
                    icon: _isSpeakerOn
                        ? Icons.volume_up
                        : Icons.volume_off,
                    label: _isSpeakerOn ? 'سماعة' : 'صامت',
                    onPressed: _toggleSpeaker,
                    color: _isSpeakerOn ? AppColors.surface : AppColors.textSecondary,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required Color color,
    bool isLarge = false,
  }) {
    final size = isLarge ? 70.0 : 60.0;

    return Column(
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: IconButton(
            icon: Icon(icon, size: isLarge ? 35 : 28),
            color: color == AppColors.error ? Colors.white : AppColors.textPrimary,
            onPressed: onPressed,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
