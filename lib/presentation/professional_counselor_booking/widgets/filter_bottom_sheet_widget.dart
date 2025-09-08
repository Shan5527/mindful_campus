import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class FilterBottomSheetWidget extends StatefulWidget {
  final Map<String, dynamic> currentFilters;
  final Function(Map<String, dynamic>) onFiltersApplied;

  const FilterBottomSheetWidget({
    Key? key,
    required this.currentFilters,
    required this.onFiltersApplied,
  }) : super(key: key);

  @override
  State<FilterBottomSheetWidget> createState() =>
      _FilterBottomSheetWidgetState();
}

class _FilterBottomSheetWidgetState extends State<FilterBottomSheetWidget> {
  late Map<String, dynamic> _filters;

  final List<String> _specializations = [
    'Anxiety & Stress',
    'Depression',
    'Academic Pressure',
    'Relationship Issues',
    'Self-Esteem',
    'Sleep Disorders',
    'Eating Disorders',
    'Trauma & PTSD',
    'Addiction',
    'Career Counseling',
  ];

  final List<String> _languages = [
    'English',
    'Hindi',
    'Urdu',
  ];

  final List<String> _availabilityOptions = [
    'Available Today',
    'Available This Week',
    'Available Next Week',
  ];

  @override
  void initState() {
    super.initState();
    _filters = Map<String, dynamic>.from(widget.currentFilters);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildDragHandle(),
          _buildHeader(),
          Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSpecializationSection(),
                  SizedBox(height: 3.h),
                  _buildLanguageSection(),
                  SizedBox(height: 3.h),
                  _buildAvailabilitySection(),
                  SizedBox(height: 3.h),
                  _buildRatingSection(),
                  SizedBox(height: 4.h),
                ],
              ),
            ),
          ),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildDragHandle() {
    return Container(
      margin: EdgeInsets.only(top: 1.h),
      width: 12.w,
      height: 0.5.h,
      decoration: BoxDecoration(
        color: AppTheme.dividerLight,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(4.w),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: 'filter_list',
            color: AppTheme.primaryLight,
            size: 24,
          ),
          SizedBox(width: 2.w),
          Text(
            'Filter Counselors',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              color: AppTheme.textHighEmphasisLight,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          TextButton(
            onPressed: _clearAllFilters,
            child: Text(
              'Clear All',
              style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                color: AppTheme.primaryLight,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecializationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Specializations',
          style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
            color: AppTheme.textHighEmphasisLight,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.5.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: _specializations.map((specialization) {
            final isSelected = (_filters['specializations'] as List? ?? [])
                .contains(specialization);
            return GestureDetector(
              onTap: () => _toggleSpecialization(specialization),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppTheme.primaryLight
                      : AppTheme.backgroundLight,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? AppTheme.primaryLight
                        : AppTheme.dividerLight,
                    width: 1,
                  ),
                ),
                child: Text(
                  specialization,
                  style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                    color: isSelected
                        ? Colors.white
                        : AppTheme.textMediumEmphasisLight,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildLanguageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Languages',
          style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
            color: AppTheme.textHighEmphasisLight,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.5.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: _languages.map((language) {
            final isSelected =
                (_filters['languages'] as List? ?? []).contains(language);
            return GestureDetector(
              onTap: () => _toggleLanguage(language),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppTheme.accentLight
                      : AppTheme.backgroundLight,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? AppTheme.primaryLight
                        : AppTheme.dividerLight,
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomIconWidget(
                      iconName: 'language',
                      color: isSelected
                          ? AppTheme.primaryLight
                          : AppTheme.textMediumEmphasisLight,
                      size: 16,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      language,
                      style:
                          AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                        color: isSelected
                            ? AppTheme.primaryLight
                            : AppTheme.textMediumEmphasisLight,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildAvailabilitySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Availability',
          style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
            color: AppTheme.textHighEmphasisLight,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.5.h),
        Column(
          children: _availabilityOptions.map((option) {
            final isSelected = _filters['availability'] == option;
            return GestureDetector(
              onTap: () => _selectAvailability(option),
              child: Container(
                margin: EdgeInsets.only(bottom: 1.h),
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppTheme.accentLight
                      : AppTheme.backgroundLight,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? AppTheme.primaryLight
                        : AppTheme.dividerLight,
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: isSelected
                          ? 'radio_button_checked'
                          : 'radio_button_unchecked',
                      color: isSelected
                          ? AppTheme.primaryLight
                          : AppTheme.textMediumEmphasisLight,
                      size: 20,
                    ),
                    SizedBox(width: 3.w),
                    Text(
                      option,
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: isSelected
                            ? AppTheme.primaryLight
                            : AppTheme.textHighEmphasisLight,
                        fontWeight:
                            isSelected ? FontWeight.w500 : FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildRatingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Minimum Rating',
          style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
            color: AppTheme.textHighEmphasisLight,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.5.h),
        Row(
          children: [
            Expanded(
              child: Slider(
                value: (_filters['minRating'] as double? ?? 0.0),
                min: 0.0,
                max: 5.0,
                divisions: 10,
                label:
                    '${(_filters['minRating'] as double? ?? 0.0).toStringAsFixed(1)}+',
                onChanged: (value) {
                  setState(() {
                    _filters['minRating'] = value;
                  });
                },
              ),
            ),
            SizedBox(width: 2.w),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: AppTheme.accentLight,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomIconWidget(
                    iconName: 'star',
                    color: AppTheme.warningLight,
                    size: 16,
                  ),
                  SizedBox(width: 1.w),
                  Text(
                    '${(_filters['minRating'] as double? ?? 0.0).toStringAsFixed(1)}+',
                    style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                      color: AppTheme.primaryLight,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: EdgeInsets.all(4.w),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: ElevatedButton(
              onPressed: _applyFilters,
              child: Text('Apply Filters'),
            ),
          ),
        ],
      ),
    );
  }

  void _toggleSpecialization(String specialization) {
    setState(() {
      final specializations =
          (_filters['specializations'] as List? ?? []).cast<String>();
      if (specializations.contains(specialization)) {
        specializations.remove(specialization);
      } else {
        specializations.add(specialization);
      }
      _filters['specializations'] = specializations;
    });
  }

  void _toggleLanguage(String language) {
    setState(() {
      final languages = (_filters['languages'] as List? ?? []).cast<String>();
      if (languages.contains(language)) {
        languages.remove(language);
      } else {
        languages.add(language);
      }
      _filters['languages'] = languages;
    });
  }

  void _selectAvailability(String availability) {
    setState(() {
      _filters['availability'] =
          _filters['availability'] == availability ? null : availability;
    });
  }

  void _clearAllFilters() {
    setState(() {
      _filters = {
        'specializations': <String>[],
        'languages': <String>[],
        'availability': null,
        'minRating': 0.0,
      };
    });
  }

  void _applyFilters() {
    widget.onFiltersApplied(_filters);
    Navigator.pop(context);
  }
}
