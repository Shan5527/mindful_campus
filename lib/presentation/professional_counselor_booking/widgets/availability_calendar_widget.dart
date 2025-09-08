import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../core/app_export.dart';

class AvailabilityCalendarWidget extends StatefulWidget {
  final Map<String, dynamic> counselor;
  final Function(DateTime, String) onSlotSelected;
  final DateTime? selectedDate;
  final String? selectedTime;

  const AvailabilityCalendarWidget({
    Key? key,
    required this.counselor,
    required this.onSlotSelected,
    this.selectedDate,
    this.selectedTime,
  }) : super(key: key);

  @override
  State<AvailabilityCalendarWidget> createState() =>
      _AvailabilityCalendarWidgetState();
}

class _AvailabilityCalendarWidgetState
    extends State<AvailabilityCalendarWidget> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = widget.selectedDate;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
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
          _buildCalendarHeader(),
          SizedBox(height: 2.h),
          _buildCalendar(),
          if (_selectedDay != null) ...[
            SizedBox(height: 2.h),
            _buildTimeSlots(),
          ],
        ],
      ),
    );
  }

  Widget _buildCalendarHeader() {
    return Row(
      children: [
        CustomIconWidget(
          iconName: 'calendar_today',
          color: AppTheme.primaryLight,
          size: 20,
        ),
        SizedBox(width: 2.w),
        Text(
          'Select Date & Time',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            color: AppTheme.textHighEmphasisLight,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildCalendar() {
    return TableCalendar<String>(
      firstDay: DateTime.now(),
      lastDay: DateTime.now().add(const Duration(days: 30)),
      focusedDay: _focusedDay,
      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
      calendarFormat: CalendarFormat.month,
      startingDayOfWeek: StartingDayOfWeek.monday,
      availableGestures: AvailableGestures.all,
      onDaySelected: (selectedDay, focusedDay) {
        if (!isSameDay(_selectedDay, selectedDay)) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });
        }
      },
      onPageChanged: (focusedDay) {
        _focusedDay = focusedDay;
      },
      calendarStyle: CalendarStyle(
        outsideDaysVisible: false,
        weekendTextStyle: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
          color: AppTheme.textMediumEmphasisLight,
        ) ?? const TextStyle(),
        holidayTextStyle: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
          color: AppTheme.errorLight,
        ) ?? const TextStyle(),
        selectedDecoration: BoxDecoration(
          color: AppTheme.primaryLight,
          shape: BoxShape.circle,
        ),
        selectedTextStyle: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ) ?? const TextStyle(),
        todayDecoration: BoxDecoration(
          color: AppTheme.primaryLight.withValues(alpha: 0.3),
          shape: BoxShape.circle,
        ),
        todayTextStyle: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
          color: AppTheme.primaryLight,
          fontWeight: FontWeight.w600,
        ) ?? const TextStyle(),
        defaultTextStyle: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
          color: AppTheme.textHighEmphasisLight,
        ) ?? const TextStyle(),
        weekendDecoration: const BoxDecoration(),
        markerDecoration: BoxDecoration(
          color: AppTheme.successLight,
          shape: BoxShape.circle,
        ),
      ),
      headerStyle: HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
        leftChevronIcon: CustomIconWidget(
          iconName: 'chevron_left',
          color: AppTheme.primaryLight,
          size: 20,
        ),
        rightChevronIcon: CustomIconWidget(
          iconName: 'chevron_right',
          color: AppTheme.primaryLight,
          size: 20,
        ),
        titleTextStyle: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
          color: AppTheme.textHighEmphasisLight,
          fontWeight: FontWeight.w600,
        ) ?? const TextStyle(),
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekdayStyle: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
          color: AppTheme.textMediumEmphasisLight,
          fontWeight: FontWeight.w500,
        ) ?? const TextStyle(),
        weekendStyle: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
          color: AppTheme.textMediumEmphasisLight,
          fontWeight: FontWeight.w500,
        ) ?? const TextStyle(),
      ),
      eventLoader: (day) {
        // Return available slots for the day
        return _getAvailableSlotsForDay(day);
      },
    );
  }

  Widget _buildTimeSlots() {
    final availableSlots = _getAvailableSlotsForDay(_selectedDay!);

    if (availableSlots.isEmpty) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: AppTheme.backgroundLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppTheme.dividerLight,
            width: 1,
          ),
        ),
        child: Column(
          children: [
            CustomIconWidget(
              iconName: 'schedule',
              color: AppTheme.textMediumEmphasisLight,
              size: 24,
            ),
            SizedBox(height: 1.h),
            Text(
              'No available slots for this date',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.textMediumEmphasisLight,
              ),
            ),
          ],
        ),
      );
    }

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
          'Available Time Slots',
          style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
            color: AppTheme.textHighEmphasisLight,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.5.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: availableSlots.map((slot) {
            final isSelected = widget.selectedTime == slot;
            return GestureDetector(
              onTap: () => widget.onSlotSelected(_selectedDay!, slot),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppTheme.primaryLight
                      : AppTheme.backgroundLight,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? AppTheme.primaryLight
                        : AppTheme.dividerLight,
                    width: 1,
                  ),
                ),
                child: Text(
                  slot,
                  style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                    color: isSelected
                        ? Colors.white
                        : AppTheme.textHighEmphasisLight,
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

  List<String> _getAvailableSlotsForDay(DateTime day) {
    final availability =
        widget.counselor['availability'] as Map<String, dynamic>;
    final dayName = _getDayName(day);

    if (availability.containsKey(dayName)) {
      return (availability[dayName] as List).cast<String>();
    }

    return [];
  }

  String _getDayName(DateTime date) {
    const days = [
      'monday',
      'tuesday',
      'wednesday',
      'thursday',
      'friday',
      'saturday',
      'sunday'
    ];
    return days[date.weekday - 1];
  }
}