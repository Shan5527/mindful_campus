import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MessageContextMenu extends StatelessWidget {
  final String message;
  final VoidCallback onCopy;
  final VoidCallback onBookmark;
  final VoidCallback onReport;
  final VoidCallback onClose;

  const MessageContextMenu({
    Key? key,
    required this.message,
    required this.onCopy,
    required this.onBookmark,
    required this.onReport,
    required this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClose,
      child: Container(
        color: Colors.black.withValues(alpha: 0.5),
        child: Center(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 8.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(4.w),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.primary
                        .withValues(alpha: 0.1),
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(4.w)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Message Options',
                          style: AppTheme.lightTheme.textTheme.titleMedium
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: onClose,
                        child: CustomIconWidget(
                          iconName: 'close',
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                          size: 6.w,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  constraints: BoxConstraints(maxHeight: 15.h),
                  padding: EdgeInsets.all(4.w),
                  child: SingleChildScrollView(
                    child: Text(
                      message,
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        fontSize: 12.sp,
                      ),
                    ),
                  ),
                ),
                Divider(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.2),
                  height: 1,
                ),
                _buildMenuItem(
                  icon: 'content_copy',
                  title: 'Copy Message',
                  subtitle: 'Copy to clipboard',
                  onTap: () {
                    onCopy();
                    onClose();
                  },
                ),
                _buildMenuItem(
                  icon: 'bookmark_add',
                  title: 'Bookmark',
                  subtitle: 'Save for later reference',
                  onTap: () {
                    onBookmark();
                    onClose();
                  },
                ),
                _buildMenuItem(
                  icon: 'report',
                  title: 'Report Content',
                  subtitle: 'Report inappropriate content',
                  onTap: () {
                    onReport();
                    onClose();
                  },
                  isDestructive: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required String icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.h),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: isDestructive
                    ? AppTheme.errorLight.withValues(alpha: 0.1)
                    : AppTheme.lightTheme.colorScheme.primary
                        .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(2.w),
              ),
              child: CustomIconWidget(
                iconName: icon,
                color: isDestructive
                    ? AppTheme.errorLight
                    : AppTheme.lightTheme.colorScheme.primary,
                size: 5.w,
              ),
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                      color: isDestructive
                          ? AppTheme.errorLight
                          : AppTheme.lightTheme.colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    subtitle,
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      fontSize: 11.sp,
                    ),
                  ),
                ],
              ),
            ),
            CustomIconWidget(
              iconName: 'arrow_forward_ios',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 4.w,
            ),
          ],
        ),
      ),
    );
  }
}
