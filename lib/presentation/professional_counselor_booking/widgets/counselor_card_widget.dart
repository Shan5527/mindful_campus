import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CounselorCardWidget extends StatelessWidget {
  final Map<String, dynamic> counselor;
  final VoidCallback onTap;
  final bool isExpanded;

  const CounselorCardWidget({
    Key? key,
    required this.counselor,
    required this.onTap,
    this.isExpanded = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCounselorHeader(),
                SizedBox(height: 2.h),
                _buildSpecializations(),
                SizedBox(height: 1.5.h),
                _buildLanguagesAndRating(),
                if (isExpanded) ...[
                  SizedBox(height: 2.h),
                  _buildExpandedContent(),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCounselorHeader() {
    return Row(
      children: [
        Container(
          width: 15.w,
          height: 15.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppTheme.primaryLight.withValues(alpha: 0.2),
              width: 2,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CustomImageWidget(
              imageUrl: counselor['photo'] as String,
              width: 15.w,
              height: 15.w,
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(width: 4.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                counselor['name'] as String,
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textHighEmphasisLight,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 0.5.h),
              Text(
                counselor['title'] as String,
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.textMediumEmphasisLight,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 0.5.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: counselor['isAvailable'] == true
                      ? AppTheme.successLight.withValues(alpha: 0.1)
                      : AppTheme.warningLight.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  counselor['isAvailable'] == true
                      ? 'Available Today'
                      : 'Next Available: ${counselor['nextAvailable']}',
                  style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                    color: counselor['isAvailable'] == true
                        ? AppTheme.successLight
                        : AppTheme.warningLight,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSpecializations() {
    final specializations =
        (counselor['specializations'] as List).cast<String>();
    return Wrap(
      spacing: 2.w,
      runSpacing: 1.h,
      children: specializations.take(3).map((specialization) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.8.h),
          decoration: BoxDecoration(
            color: AppTheme.accentLight,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppTheme.primaryLight.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Text(
            specialization,
            style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
              color: AppTheme.primaryLight,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildLanguagesAndRating() {
    final languages = (counselor['languages'] as List).cast<String>();
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              CustomIconWidget(
                iconName: 'language',
                color: AppTheme.textMediumEmphasisLight,
                size: 16,
              ),
              SizedBox(width: 1.w),
              Expanded(
                child: Text(
                  languages.join(', '),
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.textMediumEmphasisLight,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 2.w),
        Row(
          children: [
            CustomIconWidget(
              iconName: 'star',
              color: AppTheme.warningLight,
              size: 16,
            ),
            SizedBox(width: 1.w),
            Text(
              '${counselor['rating']}',
              style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                color: AppTheme.textHighEmphasisLight,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              ' (${counselor['reviewCount']})',
              style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                color: AppTheme.textMediumEmphasisLight,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildExpandedContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          height: 1,
          color: AppTheme.dividerLight,
        ),
        SizedBox(height: 2.h),
        Text(
          'About',
          style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
            color: AppTheme.textHighEmphasisLight,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          counselor['bio'] as String,
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.textMediumEmphasisLight,
            height: 1.4,
          ),
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 2.h),
        Row(
          children: [
            CustomIconWidget(
              iconName: 'verified',
              color: AppTheme.successLight,
              size: 16,
            ),
            SizedBox(width: 1.w),
            Text(
              'Cultural Competency Certified',
              style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                color: AppTheme.successLight,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
