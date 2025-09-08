import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class NavigationControlsWidget extends StatelessWidget {
  final VoidCallback? onNext;
  final VoidCallback? onSkip;
  final bool isLastPage;
  final String currentLanguage;

  const NavigationControlsWidget({
    Key? key,
    this.onNext,
    this.onSkip,
    this.isLastPage = false,
    required this.currentLanguage,
  }) : super(key: key);

  String _getSkipText() {
    switch (currentLanguage) {
      case 'hi':
        return 'छोड़ें';
      case 'ur':
        return 'چھوڑیں';
      default:
        return 'Skip';
    }
  }

  String _getNextText() {
    switch (currentLanguage) {
      case 'hi':
        return 'आगे';
      case 'ur':
        return 'آگے';
      default:
        return 'Next';
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLastPage
        ? const SizedBox.shrink()
        : Padding(
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: onSkip,
                  style: TextButton.styleFrom(
                    foregroundColor: AppTheme.lightTheme.colorScheme.onSurface
                        .withValues(alpha: 0.6),
                    padding:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
                  ),
                  child: Text(
                    _getSkipText(),
                    style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurface
                          .withValues(alpha: 0.6),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: onNext,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.lightTheme.colorScheme.primary,
                    foregroundColor: Colors.white,
                    padding:
                        EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.5.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _getNextText(),
                        style:
                            AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 2.w),
                      CustomIconWidget(
                        iconName: 'arrow_forward',
                        color: Colors.white,
                        size: 18,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
  }
}
