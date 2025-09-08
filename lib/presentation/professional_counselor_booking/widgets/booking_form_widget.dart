import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BookingFormWidget extends StatefulWidget {
  final Map<String, dynamic> counselor;
  final DateTime? selectedDate;
  final String? selectedTime;
  final VoidCallback onBookingConfirmed;

  const BookingFormWidget({
    Key? key,
    required this.counselor,
    this.selectedDate,
    this.selectedTime,
    required this.onBookingConfirmed,
  }) : super(key: key);

  @override
  State<BookingFormWidget> createState() => _BookingFormWidgetState();
}

class _BookingFormWidgetState extends State<BookingFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _contactController = TextEditingController();
  final _concernController = TextEditingController();

  String _selectedContactMethod = 'email';
  String _selectedSessionType = 'video';
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _contactController.dispose();
    _concernController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowLight,
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildDragHandle(),
          _buildHeader(),
          _buildForm(),
          _buildBookingButton(),
          SizedBox(height: MediaQuery.of(context).viewInsets.bottom + 2.h),
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
      child: Column(
        children: [
          Text(
            'Book Appointment',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              color: AppTheme.textHighEmphasisLight,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          if (widget.selectedDate != null && widget.selectedTime != null) ...[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
              decoration: BoxDecoration(
                color: AppTheme.accentLight,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.primaryLight.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomIconWidget(
                    iconName: 'schedule',
                    color: AppTheme.primaryLight,
                    size: 16,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    '${_formatDate(widget.selectedDate!)} at ${widget.selectedTime}',
                    style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                      color: AppTheme.primaryLight,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildForm() {
    return Flexible(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPreferredNameField(),
              SizedBox(height: 2.h),
              _buildContactMethodSection(),
              SizedBox(height: 2.h),
              _buildContactField(),
              SizedBox(height: 2.h),
              _buildSessionTypeSection(),
              SizedBox(height: 2.h),
              _buildConcernField(),
              SizedBox(height: 2.h),
              _buildPrivacyNote(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPreferredNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Preferred Name *',
          style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
            color: AppTheme.textHighEmphasisLight,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 1.h),
        TextFormField(
          controller: _nameController,
          decoration: InputDecoration(
            hintText: 'How would you like to be addressed?',
            prefixIcon: Padding(
              padding: EdgeInsets.all(3.w),
              child: CustomIconWidget(
                iconName: 'person',
                color: AppTheme.textMediumEmphasisLight,
                size: 20,
              ),
            ),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter your preferred name';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildContactMethodSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Contact Method *',
          style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
            color: AppTheme.textHighEmphasisLight,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 1.h),
        Row(
          children: [
            Expanded(
              child: _buildContactMethodOption('email', 'Email', 'email'),
            ),
            SizedBox(width: 2.w),
            Expanded(
              child: _buildContactMethodOption('phone', 'Phone', 'phone'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildContactMethodOption(
      String value, String label, String iconName) {
    final isSelected = _selectedContactMethod == value;
    return GestureDetector(
      onTap: () => setState(() => _selectedContactMethod = value),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.accentLight : AppTheme.backgroundLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppTheme.primaryLight : AppTheme.dividerLight,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: iconName,
              color: isSelected
                  ? AppTheme.primaryLight
                  : AppTheme.textMediumEmphasisLight,
              size: 16,
            ),
            SizedBox(width: 2.w),
            Text(
              label,
              style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
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
  }

  Widget _buildContactField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${_selectedContactMethod == 'email' ? 'Email Address' : 'Phone Number'} *',
          style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
            color: AppTheme.textHighEmphasisLight,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 1.h),
        TextFormField(
          controller: _contactController,
          keyboardType: _selectedContactMethod == 'email'
              ? TextInputType.emailAddress
              : TextInputType.phone,
          decoration: InputDecoration(
            hintText: _selectedContactMethod == 'email'
                ? 'your.email@example.com'
                : '+91 98765 43210',
            prefixIcon: Padding(
              padding: EdgeInsets.all(3.w),
              child: CustomIconWidget(
                iconName: _selectedContactMethod == 'email' ? 'email' : 'phone',
                color: AppTheme.textMediumEmphasisLight,
                size: 20,
              ),
            ),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter your ${_selectedContactMethod == 'email' ? 'email address' : 'phone number'}';
            }
            if (_selectedContactMethod == 'email' && !value.contains('@')) {
              return 'Please enter a valid email address';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildSessionTypeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Session Type *',
          style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
            color: AppTheme.textHighEmphasisLight,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 1.h),
        Row(
          children: [
            Expanded(
              child: _buildSessionTypeOption('video', 'Video Call', 'videocam'),
            ),
            SizedBox(width: 2.w),
            Expanded(
              child: _buildSessionTypeOption(
                  'in-person', 'In-Person', 'location_on'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSessionTypeOption(String value, String label, String iconName) {
    final isSelected = _selectedSessionType == value;
    return GestureDetector(
      onTap: () => setState(() => _selectedSessionType = value),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.accentLight : AppTheme.backgroundLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppTheme.primaryLight : AppTheme.dividerLight,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: iconName,
              color: isSelected
                  ? AppTheme.primaryLight
                  : AppTheme.textMediumEmphasisLight,
              size: 16,
            ),
            SizedBox(width: 2.w),
            Text(
              label,
              style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
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
  }

  Widget _buildConcernField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Brief Concern Description (Optional)',
          style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
            color: AppTheme.textHighEmphasisLight,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 1.h),
        TextFormField(
          controller: _concernController,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: 'Share what you\'d like to discuss (optional)',
            alignLabelWithHint: true,
          ),
        ),
      ],
    );
  }

  Widget _buildPrivacyNote() {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.successLight.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.successLight.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomIconWidget(
            iconName: 'security',
            color: AppTheme.successLight,
            size: 16,
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: Text(
              'Your information is completely confidential and will only be shared with your selected counselor.',
              style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                color: AppTheme.successLight,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingButton() {
    final canBook = widget.selectedDate != null && widget.selectedTime != null;

    return Container(
      padding: EdgeInsets.all(4.w),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: canBook && !_isLoading ? _handleBooking : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: canBook
                ? AppTheme.primaryLight
                : AppTheme.neutralLight.withValues(alpha: 0.3),
            padding: EdgeInsets.symmetric(vertical: 2.h),
          ),
          child: _isLoading
              ? SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Text(
                  canBook ? 'Book Appointment' : 'Select Date & Time First',
                  style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
        ),
      ),
    );
  }

  Future<void> _handleBooking() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // Simulate booking API call
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        setState(() => _isLoading = false);
        widget.onBookingConfirmed();
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Booking failed. Please try again.'),
            backgroundColor: AppTheme.errorLight,
          ),
        );
      }
    }
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}
