import 'package:flutter/material.dart';
import 'dart:async';
import '../../config/theme/colors.dart';
import '../../core/services/sara_voice_service.dart';

enum RecordingState {
  idle,
  recording,
  processing,
}

class VoiceRecorder extends StatefulWidget {
  final Function(String) onTranscription;
  final VoidCallback? onError;
  final SaraVoiceService? saraService;

  const VoiceRecorder({
    super.key,
    required this.onTranscription,
    this.onError,
    this.saraService,
  });

  @override
  State<VoiceRecorder> createState() => _VoiceRecorderState();
}

class _VoiceRecorderState extends State<VoiceRecorder>
    with SingleTickerProviderStateMixin {
  RecordingState _state = RecordingState.idle;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  Timer? _recordingTimer;
  int _recordingSeconds = 0;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _recordingTimer?.cancel();
    super.dispose();
  }

  Future<void> _toggleRecording() async {
    if (_state == RecordingState.idle) {
      await _startRecording();
    } else if (_state == RecordingState.recording) {
      await _stopRecording();
    }
  }

  Future<void> _startRecording() async {
    setState(() {
      _state = RecordingState.recording;
      _recordingSeconds = 0;
    });

    // Start timer
    _recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _recordingSeconds++;
      });
      if (_recordingSeconds >= 60) {
        // Auto-stop after 60 seconds
        _stopRecording();
      }
    });

    // Use Sara voice service if provided
    if (widget.saraService != null) {
      widget.saraService!.startTalking();
    }
    
    debugPrint('🎤 بدأ التسجيل...');
  }

  Future<void> _stopRecording() async {
    _recordingTimer?.cancel();
    
    setState(() {
      _state = RecordingState.processing;
    });

    // Use Sara voice service if provided
    if (widget.saraService != null) {
      await widget.saraService!.stopTalking();
      
      // Return to idle state (Sara service will handle callbacks)
      setState(() {
        _state = RecordingState.idle;
        _recordingSeconds = 0;
      });
    } else {
      // Fallback to mock behavior
      await Future.delayed(const Duration(milliseconds: 500));
      final mockTranscription = 'جدد جواز سفري';
      widget.onTranscription(mockTranscription);
      
      setState(() {
        _state = RecordingState.idle;
        _recordingSeconds = 0;
      });
    }

    debugPrint('✅ انتهى التسجيل');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Record button
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _state == RecordingState.recording
                    ? _pulseAnimation.value
                    : 1.0,
                child: GestureDetector(
                  onTap: _state == RecordingState.processing
                      ? null
                      : _toggleRecording,
                  child: Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: _state == RecordingState.idle
                          ? AppColors.primaryGradient
                          : LinearGradient(
                              colors: [
                                AppColors.error,
                                AppColors.error.withValues(alpha: 0.8),
                              ],
                            ),
                      boxShadow: [
                        BoxShadow(
                          color: (_state == RecordingState.idle
                                  ? AppColors.primary
                                  : AppColors.error)
                              .withValues(alpha: 0.4),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      _state == RecordingState.processing
                          ? Icons.hourglass_empty_rounded
                          : _state == RecordingState.recording
                              ? Icons.stop_rounded
                              : Icons.mic_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(width: 16),
          
          // Status text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getStatusText(),
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _getSubtitleText(),
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          
          // Recording indicator
          if (_state == RecordingState.recording) ...[
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: AppColors.error,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _formatDuration(_recordingSeconds),
                    style: TextStyle(
                      color: AppColors.error,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      fontFeatures: const [
                        FontFeature.tabularFigures(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _getStatusText() {
    switch (_state) {
      case RecordingState.idle:
        return 'اضغط للتحدث';
      case RecordingState.recording:
        return 'جاري التسجيل...';
      case RecordingState.processing:
        return 'جاري المعالجة...';
    }
  }

  String _getSubtitleText() {
    switch (_state) {
      case RecordingState.idle:
        return 'اضغط على الميكروفون وابدأ الكلام';
      case RecordingState.recording:
        return 'اضغط مرة ثانية للإيقاف';
      case RecordingState.processing:
        return 'يتم تحويل الصوت إلى نص...';
    }
  }

  String _formatDuration(int seconds) {
    final mins = seconds ~/ 60;
    final secs = seconds % 60;
    return '${mins.toString().padLeft(1, '0')}:${secs.toString().padLeft(2, '0')}';
  }
}
