import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ChatInputWidget extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final VoidCallback onVoiceInput;
  final bool isLoading;

  const ChatInputWidget({
    Key? key,
    required this.controller,
    required this.onSend,
    required this.onVoiceInput,
    this.isLoading = false,
  }) : super(key: key);

  @override
  State<ChatInputWidget> createState() => _ChatInputWidgetState();
}

class _ChatInputWidgetState extends State<ChatInputWidget> {
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    final hasText = widget.controller.text.trim().isNotEmpty;
    if (hasText != _hasText) {
      setState(() {
        _hasText = hasText;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        border: Border(
          top: BorderSide(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                constraints: BoxConstraints(
                  minHeight: 6.h,
                  maxHeight: 20.h,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(6.w),
                  border: Border.all(
                    color: AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: widget.controller,
                        maxLines: null,
                        textInputAction: TextInputAction.newline,
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          fontSize: 14.sp,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Share what\'s on your mind...',
                          hintStyle: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                            fontSize: 14.sp,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 4.w,
                            vertical: 2.h,
                          ),
                        ),
                        enabled: !widget.isLoading,
                      ),
                    ),
                    GestureDetector(
                      onTap: widget.onVoiceInput,
                      child: Container(
                        padding: EdgeInsets.all(2.w),
                        child: CustomIconWidget(
                          iconName: 'mic',
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                          size: 5.w,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 3.w),
            GestureDetector(
              onTap: _hasText && !widget.isLoading ? widget.onSend : null,
              child: Container(
                width: 12.w,
                height: 12.w,
                decoration: BoxDecoration(
                  color: _hasText && !widget.isLoading
                      ? AppTheme.lightTheme.colorScheme.primary
                      : AppTheme.lightTheme.colorScheme.onSurfaceVariant
                          .withValues(alpha: 0.3),
                  shape: BoxShape.circle,
                ),
                child: widget.isLoading
                    ? Center(
                        child: SizedBox(
                          width: 4.w,
                          height: 4.w,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                      )
                    : Center(
                        child: CustomIconWidget(
                          iconName: 'send',
                          color: Colors.white,
                          size: 5.w,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
