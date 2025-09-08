import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CommunityGuidelinesWidget extends StatelessWidget {
  final VoidCallback onClose;

  const CommunityGuidelinesWidget({
    Key? key,
    required this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(5.w)),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'shield',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 6.w,
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Text(
                    'Community Guidelines',
                    style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: onClose,
                  icon: CustomIconWidget(
                    iconName: 'close',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 5.w,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildGuidelineSection(
                    'Safe Space Principles',
                    [
                      'This is an anonymous, judgment-free zone for peer support',
                      'Respect everyone\'s privacy and anonymity',
                      'Be kind, empathetic, and supportive in all interactions',
                      'Listen actively and offer encouragement when appropriate',
                    ],
                    'favorite',
                  ),
                  SizedBox(height: 3.h),
                  _buildGuidelineSection(
                    'What\'s Encouraged',
                    [
                      'Share your experiences and feelings openly',
                      'Offer support and encouragement to others',
                      'Ask for help when you need it',
                      'Use appropriate reactions to show support',
                      'Report concerning messages to moderators',
                    ],
                    'thumb_up',
                  ),
                  SizedBox(height: 3.h),
                  _buildGuidelineSection(
                    'What\'s Not Allowed',
                    [
                      'Sharing personal identifying information',
                      'Bullying, harassment, or discriminatory language',
                      'Giving medical or professional advice',
                      'Promoting self-harm or dangerous behaviors',
                      'Spam, advertising, or off-topic content',
                    ],
                    'block',
                  ),
                  SizedBox(height: 3.h),
                  _buildGuidelineSection(
                    'Crisis Support',
                    [
                      'If you\'re in immediate danger, contact emergency services',
                      'Use the crisis support button for urgent help',
                      'Moderators monitor for crisis situations 24/7',
                      'Professional counselors are available through the app',
                    ],
                    'emergency',
                  ),
                  SizedBox(height: 3.h),
                  Container(
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.primaryContainer
                          .withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(3.w),
                    ),
                    child: Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'info',
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 5.w,
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: Text(
                            'Remember: This chat is for peer support only. For professional help, use the counselor booking feature.',
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(4.w),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onClose,
                child: Text('I Understand'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuidelineSection(
      String title, List<String> guidelines, String iconName) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CustomIconWidget(
              iconName: iconName,
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 5.w,
            ),
            SizedBox(width: 2.w),
            Text(
              title,
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(height: 1.5.h),
        ...guidelines
            .map((guideline) => Padding(
                  padding: EdgeInsets.only(bottom: 1.h, left: 7.w),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 1.h),
                        width: 1.w,
                        height: 1.w,
                        decoration: BoxDecoration(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: Text(
                          guideline,
                          style: AppTheme.lightTheme.textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                ))
            .toList(),
      ],
    );
  }
}
