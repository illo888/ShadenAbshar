import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../../config/theme/colors.dart';
import '../../core/models/message_model.dart';

class ChatBubble extends StatelessWidget {
  final MessageModel message;
  final VoidCallback? onCtaTap;

  const ChatBubble({
    super.key,
    required this.message,
    this.onCtaTap,
  });

  @override
  Widget build(BuildContext context) {
    final isUser = message.role == 'user';
    
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        child: Column(
          crossAxisAlignment:
              isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: isUser
                    ? AppColors.primaryGradient
                    : null,
                color: isUser ? null : AppColors.surface,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft: Radius.circular(isUser ? 20 : 4),
                  bottomRight: Radius.circular(isUser ? 4 : 20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: MarkdownBody(
                data: message.text,
                styleSheet: MarkdownStyleSheet(
                  p: TextStyle(
                    color: isUser ? Colors.white : AppColors.textPrimary,
                    fontSize: 16,
                    height: 1.5,
                  ),
                  code: TextStyle(
                    backgroundColor: isUser
                        ? Colors.white.withValues(alpha: 0.2)
                        : AppColors.primary.withValues(alpha: 0.1),
                    color: isUser ? Colors.white : AppColors.primary,
                    fontFamily: 'monospace',
                  ),
                  codeblockDecoration: BoxDecoration(
                    color: isUser
                        ? Colors.white.withValues(alpha: 0.1)
                        : AppColors.surface,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  strong: TextStyle(
                    color: isUser ? Colors.white : AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                  em: TextStyle(
                    color: isUser ? Colors.white : AppColors.textPrimary,
                    fontStyle: FontStyle.italic,
                  ),
                  listBullet: TextStyle(
                    color: isUser ? Colors.white : AppColors.primary,
                  ),
                ),
              ),
            ),
            if (message.ctas != null && message.ctas!.isNotEmpty) ...[
              const SizedBox(height: 12),
              ..._buildCTAButtons(context),
            ],
          ],
        ),
      ),
    );
  }

  List<Widget> _buildCTAButtons(BuildContext context) {
    return message.ctas!.map((cta) {
      final isPrimary = cta.variant == 'primary';
      return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onCtaTap,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 12,
              ),
              decoration: BoxDecoration(
                gradient: isPrimary ? AppColors.primaryGradient : null,
                color: isPrimary ? null : Colors.transparent,
                border: isPrimary
                    ? null
                    : Border.all(
                        color: AppColors.primary,
                        width: 2,
                      ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: isPrimary
                    ? [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(
                      cta.label,
                      style: TextStyle(
                        color: isPrimary ? Colors.white : AppColors.primary,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.arrow_forward_rounded,
                    color: isPrimary ? Colors.white : AppColors.primary,
                    size: 18,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }).toList();
  }
}
