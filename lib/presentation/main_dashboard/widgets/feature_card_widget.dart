import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class FeatureCardWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final String iconName;
  final Color backgroundColor;
  final Color iconColor;
  final VoidCallback onTap;
  final Widget? trailing;

  const FeatureCardWidget({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.iconName,
    required this.backgroundColor,
    required this.iconColor,
    required this.onTap,
    this.trailing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(4.w),
        margin: EdgeInsets.only(bottom: 2.h),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppTheme.shadowLight,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 12.w,
              height: 6.h,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: iconName,
                  color: iconColor,
                  size: 24,
                ),
              ),
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      color: AppTheme.textHighEmphasisLight,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    subtitle,
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textMediumEmphasisLight,
                    ),
                  ),
                ],
              ),
            ),
            if (trailing != null) ...[
              SizedBox(width: 2.w),
              trailing!,
            ] else
              CustomIconWidget(
                iconName: 'arrow_forward_ios',
                color: AppTheme.neutralLight,
                size: 16,
              ),
          ],
        ),
      ),
    );
  }
}
