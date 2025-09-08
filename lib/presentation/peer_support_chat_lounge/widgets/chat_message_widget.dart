import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ChatMessageWidget extends StatelessWidget {
  final Map<String, dynamic> message;
  final bool isCurrentUser;
  final VoidCallback? onLongPress;
  final VoidCallback? onReact;

  const ChatMessageWidget({
    Key? key,
    required this.message,
    required this.isCurrentUser,
    this.onLongPress,
    this.onReact,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: onLongPress,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 0.5.h, horizontal: 4.w),
        child: Row(
          mainAxisAlignment:
              isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isCurrentUser) ...[
              CircleAvatar(
                radius: 2.5.h,
                backgroundColor:
                    AppTheme.lightTheme.colorScheme.primaryContainer,
                child: CustomIconWidget(
                  iconName: 'person',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 3.h,
                ),
              ),
              SizedBox(width: 2.w),
            ],
            Flexible(
              child: Column(
                crossAxisAlignment: isCurrentUser
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  if (!isCurrentUser)
                    Padding(
                      padding: EdgeInsets.only(bottom: 0.5.h),
                      child: Text(
                        message['senderName'] ?? 'Anonymous Student',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.h),
                    decoration: BoxDecoration(
                      color: isCurrentUser
                          ? AppTheme.lightTheme.colorScheme.primary
                          : AppTheme.lightTheme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(4.w),
                      border: !isCurrentUser
                          ? Border.all(
                              color: AppTheme.lightTheme.colorScheme.outline
                                  .withValues(alpha: 0.2),
                              width: 1,
                            )
                          : null,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          message['content'] ?? '',
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: isCurrentUser
                                ? Colors.white
                                : AppTheme.lightTheme.colorScheme.onSurface,
                          ),
                        ),
                        SizedBox(height: 1.h),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _formatTimestamp(message['timestamp']),
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: isCurrentUser
                                    ? Colors.white.withValues(alpha: 0.7)
                                    : AppTheme.lightTheme.colorScheme
                                        .onSurfaceVariant,
                                fontSize: 10.sp,
                              ),
                            ),
                            if (message['reactions'] != null &&
                                (message['reactions'] as List).isNotEmpty) ...[
                              SizedBox(width: 2.w),
                              _buildReactionChips(),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  _buildReactionButtons(),
                ],
              ),
            ),
            if (isCurrentUser) ...[
              SizedBox(width: 2.w),
              CircleAvatar(
                radius: 2.5.h,
                backgroundColor: AppTheme.lightTheme.colorScheme.primary,
                child: CustomIconWidget(
                  iconName: 'person',
                  color: Colors.white,
                  size: 3.h,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildReactionChips() {
    final reactions = message['reactions'] as List? ?? [];
    return Wrap(
      spacing: 1.w,
      children: reactions.map<Widget>((reaction) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.primaryContainer
                .withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(2.w),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                reaction['emoji'] ?? '❤️',
                style: TextStyle(fontSize: 10.sp),
              ),
              SizedBox(width: 1.w),
              Text(
                '${reaction['count'] ?? 1}',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  fontSize: 9.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildReactionButtons() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildReactionButton('❤️', 'Heart'),
        SizedBox(width: 2.w),
        _buildReactionButton('🤗', 'Support'),
        SizedBox(width: 2.w),
        _buildReactionButton('🙏', 'Thanks'),
      ],
    );
  }

  Widget _buildReactionButton(String emoji, String label) {
    return GestureDetector(
      onTap: onReact,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.8.h),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(2.w),
          border: Border.all(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              emoji,
              style: TextStyle(fontSize: 10.sp),
            ),
            SizedBox(width: 1.w),
            Text(
              label,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                fontSize: 9.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTimestamp(dynamic timestamp) {
    if (timestamp == null) return '';

    DateTime messageTime;
    if (timestamp is DateTime) {
      messageTime = timestamp;
    } else if (timestamp is String) {
      messageTime = DateTime.tryParse(timestamp) ?? DateTime.now();
    } else {
      return '';
    }

    final now = DateTime.now();
    final difference = now.difference(messageTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}
