import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TypingIndicatorWidget extends StatefulWidget {
  final List<String> typingUsers;

  const TypingIndicatorWidget({
    Key? key,
    required this.typingUsers,
  }) : super(key: key);

  @override
  State<TypingIndicatorWidget> createState() => _TypingIndicatorWidgetState();
}

class _TypingIndicatorWidgetState extends State<TypingIndicatorWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.typingUsers.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: EdgeInsets.symmetric(vertical: 1.h, horizontal: 4.w),
      child: Row(
        children: [
          CircleAvatar(
            radius: 2.h,
            backgroundColor: AppTheme.lightTheme.colorScheme.primaryContainer,
            child: CustomIconWidget(
              iconName: 'person',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 2.5.h,
            ),
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(4.w),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Text(
                    _getTypingText(),
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  SizedBox(width: 2.w),
                  AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      return Row(
                        children: List.generate(3, (index) {
                          final delay = index * 0.2;
                          final animationValue =
                              (_animation.value - delay).clamp(0.0, 1.0);
                          final opacity = (animationValue * 2).clamp(0.0, 1.0);

                          return Container(
                            margin: EdgeInsets.only(right: 1.w),
                            child: Opacity(
                              opacity: opacity > 1 ? 2 - opacity : opacity,
                              child: Container(
                                width: 1.5.w,
                                height: 1.5.w,
                                decoration: BoxDecoration(
                                  color:
                                      AppTheme.lightTheme.colorScheme.primary,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          );
                        }),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getTypingText() {
    if (widget.typingUsers.length == 1) {
      return '${widget.typingUsers.first} is typing';
    } else if (widget.typingUsers.length == 2) {
      return '${widget.typingUsers.first} and ${widget.typingUsers.last} are typing';
    } else {
      return '${widget.typingUsers.length} people are typing';
    }
  }
}
