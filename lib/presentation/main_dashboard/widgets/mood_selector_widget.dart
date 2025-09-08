import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class MoodSelectorWidget extends StatefulWidget {
  final Function(String) onMoodSelected;

  const MoodSelectorWidget({
    Key? key,
    required this.onMoodSelected,
  }) : super(key: key);

  @override
  State<MoodSelectorWidget> createState() => _MoodSelectorWidgetState();
}

class _MoodSelectorWidgetState extends State<MoodSelectorWidget> {
  String? selectedMood;

  final List<Map<String, dynamic>> moods = [
    {'emoji': '😊', 'label': 'Great', 'value': 'great'},
    {'emoji': '🙂', 'label': 'Good', 'value': 'good'},
    {'emoji': '😐', 'label': 'Okay', 'value': 'okay'},
    {'emoji': '😔', 'label': 'Low', 'value': 'low'},
    {'emoji': '😰', 'label': 'Anxious', 'value': 'anxious'},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'How are you feeling today?',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.textHighEmphasisLight,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: moods.map((mood) {
              final isSelected = selectedMood == mood['value'];
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedMood = mood['value'];
                  });
                  widget.onMoodSelected(mood['value']);
                },
                child: Container(
                  width: 15.w,
                  height: 8.h,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppTheme.primaryLight.withValues(alpha: 0.1)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    border: isSelected
                        ? Border.all(
                            color: AppTheme.primaryLight,
                            width: 2,
                          )
                        : null,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        mood['emoji'],
                        style: TextStyle(fontSize: 18.sp),
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        mood['label'],
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: isSelected
                              ? AppTheme.primaryLight
                              : AppTheme.textMediumEmphasisLight,
                          fontWeight:
                              isSelected ? FontWeight.w500 : FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
