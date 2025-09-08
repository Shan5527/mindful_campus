import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ChatMessageWidget extends StatelessWidget {
  final String message;
  final bool isUser;
  final DateTime timestamp;
  final bool isTyping;
  final VoidCallback? onLongPress;

  const ChatMessageWidget({
    Key? key,
    required this.message,
    required this.isUser,
    required this.timestamp,
    this.isTyping = false,
    this.onLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: onLongPress,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 0.5.h, horizontal: 4.w),
        child: Row(
          mainAxisAlignment:
              isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (!isUser) ...[
              CircleAvatar(
                radius: 2.5.w,
                backgroundColor: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.1),
                child: CustomIconWidget(
                  iconName: 'psychology',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 3.w,
                ),
              ),
              SizedBox(width: 2.w),
            ],
            Flexible(
              child: Column(
                crossAxisAlignment:
                    isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Container(
                    constraints: BoxConstraints(maxWidth: 75.w),
                    padding:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                    decoration: BoxDecoration(
                      color: isUser
                          ? AppTheme.lightTheme.colorScheme.primary
                          : AppTheme.lightTheme.colorScheme.surface,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(4.w),
                        topRight: Radius.circular(4.w),
                        bottomLeft: isUser
                            ? Radius.circular(4.w)
                            : Radius.circular(1.w),
                        bottomRight: isUser
                            ? Radius.circular(1.w)
                            : Radius.circular(4.w),
                      ),
                      border: !isUser
                          ? Border.all(
                              color: AppTheme.lightTheme.colorScheme.outline
                                  .withValues(alpha: 0.2),
                              width: 1,
                            )
                          : null,
                    ),
                    child: isTyping
                        ? _buildTypingIndicator()
                        : _buildMessageContent(),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    _formatTimestamp(timestamp),
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      fontSize: 10.sp,
                    ),
                  ),
                ],
              ),
            ),
            if (isUser) ...[
              SizedBox(width: 2.w),
              CircleAvatar(
                radius: 2.5.w,
                backgroundColor: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.1),
                child: CustomIconWidget(
                  iconName: 'person',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 3.w,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMessageContent() {
    return Text(
      message,
      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
        color:
            isUser ? Colors.white : AppTheme.lightTheme.colorScheme.onSurface,
        fontSize: 14.sp,
        height: 1.4,
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'AI is typing',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            fontSize: 12.sp,
            fontStyle: FontStyle.italic,
          ),
        ),
        SizedBox(width: 2.w),
        SizedBox(
          width: 4.w,
          height: 4.w,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(
              AppTheme.lightTheme.colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }
}
