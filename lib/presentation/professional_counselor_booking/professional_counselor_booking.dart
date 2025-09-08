import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/availability_calendar_widget.dart';
import './widgets/booking_form_widget.dart';
import './widgets/counselor_card_widget.dart';
import './widgets/filter_bottom_sheet_widget.dart';

class ProfessionalCounselorBooking extends StatefulWidget {
  const ProfessionalCounselorBooking({Key? key}) : super(key: key);

  @override
  State<ProfessionalCounselorBooking> createState() =>
      _ProfessionalCounselorBookingState();
}

class _ProfessionalCounselorBookingState
    extends State<ProfessionalCounselorBooking> {
  final ScrollController _scrollController = ScrollController();

  String? _expandedCounselorId;
  DateTime? _selectedDate;
  String? _selectedTime;
  Map<String, dynamic> _selectedCounselor = {};
  bool _showBookingForm = false;
  bool _isLoading = false;

  Map<String, dynamic> _filters = {
    'specializations': <String>[],
    'languages': <String>[],
    'availability': null,
    'minRating': 0.0,
  };

  final List<Map<String, dynamic>> _counselors = [
    {
      "id": "1",
      "name": "Dr. Priya Sharma",
      "title": "Clinical Psychologist",
      "photo":
          "https://images.pexels.com/photos/5327580/pexels-photo-5327580.jpeg?auto=compress&cs=tinysrgb&w=400",
      "specializations": [
        "Anxiety & Stress",
        "Depression",
        "Academic Pressure"
      ],
      "languages": ["English", "Hindi"],
      "rating": 4.8,
      "reviewCount": 127,
      "isAvailable": true,
      "nextAvailable": "Today",
      "bio":
          "Specialized in cognitive behavioral therapy with 8+ years of experience helping college students navigate academic stress and mental health challenges.",
      "availability": {
        "monday": ["09:00 AM", "11:00 AM", "02:00 PM", "04:00 PM"],
        "tuesday": ["10:00 AM", "01:00 PM", "03:00 PM", "05:00 PM"],
        "wednesday": ["09:00 AM", "11:00 AM", "02:00 PM"],
        "thursday": ["10:00 AM", "01:00 PM", "04:00 PM"],
        "friday": ["09:00 AM", "11:00 AM", "03:00 PM"],
        "saturday": ["10:00 AM", "02:00 PM"],
        "sunday": []
      }
    },
    {
      "id": "2",
      "name": "Dr. Arjun Patel",
      "title": "Counseling Psychologist",
      "photo":
          "https://images.pexels.com/photos/5327921/pexels-photo-5327921.jpeg?auto=compress&cs=tinysrgb&w=400",
      "specializations": [
        "Relationship Issues",
        "Self-Esteem",
        "Career Counseling"
      ],
      "languages": ["English", "Hindi", "Urdu"],
      "rating": 4.6,
      "reviewCount": 89,
      "isAvailable": false,
      "nextAvailable": "Tomorrow",
      "bio":
          "Focuses on solution-focused therapy and mindfulness-based interventions. Experienced in multicultural counseling approaches.",
      "availability": {
        "monday": ["11:00 AM", "02:00 PM", "04:00 PM"],
        "tuesday": ["09:00 AM", "01:00 PM", "03:00 PM"],
        "wednesday": ["10:00 AM", "12:00 PM", "05:00 PM"],
        "thursday": ["09:00 AM", "02:00 PM", "04:00 PM"],
        "friday": ["11:00 AM", "01:00 PM", "03:00 PM"],
        "saturday": [],
        "sunday": ["10:00 AM", "02:00 PM"]
      }
    },
    {
      "id": "3",
      "name": "Dr. Fatima Khan",
      "title": "Trauma Specialist",
      "photo":
          "https://images.pexels.com/photos/5327656/pexels-photo-5327656.jpeg?auto=compress&cs=tinysrgb&w=400",
      "specializations": [
        "Trauma & PTSD",
        "Anxiety & Stress",
        "Sleep Disorders"
      ],
      "languages": ["English", "Urdu"],
      "rating": 4.9,
      "reviewCount": 156,
      "isAvailable": true,
      "nextAvailable": "Today",
      "bio":
          "EMDR certified therapist specializing in trauma recovery and post-traumatic stress. Culturally sensitive approach to mental health.",
      "availability": {
        "monday": ["09:00 AM", "11:00 AM", "03:00 PM"],
        "tuesday": ["10:00 AM", "02:00 PM", "04:00 PM"],
        "wednesday": ["09:00 AM", "01:00 PM", "05:00 PM"],
        "thursday": ["11:00 AM", "02:00 PM", "04:00 PM"],
        "friday": ["09:00 AM", "12:00 PM", "03:00 PM"],
        "saturday": ["10:00 AM", "01:00 PM"],
        "sunday": []
      }
    },
    {
      "id": "4",
      "name": "Dr. Rajesh Kumar",
      "title": "Addiction Counselor",
      "photo":
          "https://images.pexels.com/photos/5327647/pexels-photo-5327647.jpeg?auto=compress&cs=tinysrgb&w=400",
      "specializations": ["Addiction", "Depression", "Self-Esteem"],
      "languages": ["English", "Hindi"],
      "rating": 4.7,
      "reviewCount": 94,
      "isAvailable": false,
      "nextAvailable": "Next Week",
      "bio":
          "Certified addiction counselor with expertise in substance abuse recovery and dual diagnosis treatment for young adults.",
      "availability": {
        "monday": ["10:00 AM", "02:00 PM"],
        "tuesday": ["09:00 AM", "01:00 PM", "04:00 PM"],
        "wednesday": ["11:00 AM", "03:00 PM"],
        "thursday": ["09:00 AM", "12:00 PM", "05:00 PM"],
        "friday": ["10:00 AM", "02:00 PM", "04:00 PM"],
        "saturday": ["09:00 AM", "01:00 PM"],
        "sunday": []
      }
    },
    {
      "id": "5",
      "name": "Dr. Meera Singh",
      "title": "Eating Disorder Specialist",
      "photo":
          "https://images.pexels.com/photos/5327585/pexels-photo-5327585.jpeg?auto=compress&cs=tinysrgb&w=400",
      "specializations": [
        "Eating Disorders",
        "Self-Esteem",
        "Academic Pressure"
      ],
      "languages": ["English", "Hindi"],
      "rating": 4.5,
      "reviewCount": 73,
      "isAvailable": true,
      "nextAvailable": "Today",
      "bio":
          "Specialized in eating disorder recovery with a holistic approach combining nutrition counseling and psychological therapy.",
      "availability": {
        "monday": ["09:00 AM", "01:00 PM", "04:00 PM"],
        "tuesday": ["10:00 AM", "12:00 PM", "03:00 PM"],
        "wednesday": ["09:00 AM", "02:00 PM", "05:00 PM"],
        "thursday": ["11:00 AM", "01:00 PM", "04:00 PM"],
        "friday": ["09:00 AM", "11:00 AM", "02:00 PM"],
        "saturday": ["10:00 AM", "03:00 PM"],
        "sunday": ["11:00 AM", "02:00 PM"]
      }
    }
  ];

  List<Map<String, dynamic>> get _filteredCounselors {
    return _counselors.where((counselor) {
      // Filter by specializations
      final selectedSpecializations =
          (_filters['specializations'] as List).cast<String>();
      if (selectedSpecializations.isNotEmpty) {
        final counselorSpecializations =
            (counselor['specializations'] as List).cast<String>();
        if (!selectedSpecializations
            .any((spec) => counselorSpecializations.contains(spec))) {
          return false;
        }
      }

      // Filter by languages
      final selectedLanguages = (_filters['languages'] as List).cast<String>();
      if (selectedLanguages.isNotEmpty) {
        final counselorLanguages =
            (counselor['languages'] as List).cast<String>();
        if (!selectedLanguages
            .any((lang) => counselorLanguages.contains(lang))) {
          return false;
        }
      }

      // Filter by availability
      final selectedAvailability = _filters['availability'] as String?;
      if (selectedAvailability != null) {
        switch (selectedAvailability) {
          case 'Available Today':
            if (counselor['isAvailable'] != true) return false;
            break;
          case 'Available This Week':
            if (counselor['nextAvailable'] == 'Next Week') return false;
            break;
          case 'Available Next Week':
            // Show all counselors for next week filter
            break;
        }
      }

      // Filter by minimum rating
      final minRating = _filters['minRating'] as double;
      if ((counselor['rating'] as double) < minRating) {
        return false;
      }

      return true;
    }).toList();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: _buildAppBar(),
      body: _buildBody(),
      bottomSheet: _showBookingForm ? _buildBookingBottomSheet() : null,
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(
        'Book Counselor',
        style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
          color: AppTheme.textHighEmphasisLight,
          fontWeight: FontWeight.w600,
        ),
      ),
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: CustomIconWidget(
          iconName: 'arrow_back',
          color: AppTheme.textHighEmphasisLight,
          size: 24,
        ),
      ),
      actions: [
        IconButton(
          onPressed: _showFilterBottomSheet,
          icon: CustomIconWidget(
            iconName: 'filter_list',
            color: AppTheme.primaryLight,
            size: 24,
          ),
        ),
        SizedBox(width: 2.w),
      ],
      elevation: 0,
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
    );
  }

  Widget _buildBody() {
    return RefreshIndicator(
      onRefresh: _refreshCounselors,
      color: AppTheme.primaryLight,
      child: _isLoading
          ? _buildLoadingState()
          : _filteredCounselors.isEmpty
              ? _buildEmptyState()
              : _buildCounselorsList(),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: AppTheme.primaryLight,
          ),
          SizedBox(height: 2.h),
          Text(
            'Loading counselors...',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.textMediumEmphasisLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'search_off',
              color: AppTheme.textMediumEmphasisLight,
              size: 64,
            ),
            SizedBox(height: 3.h),
            Text(
              'No counselors found',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                color: AppTheme.textHighEmphasisLight,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'Try adjusting your filters to see more results',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.textMediumEmphasisLight,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 3.h),
            ElevatedButton(
              onPressed: _clearFilters,
              child: Text('Clear Filters'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCounselorsList() {
    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.only(
        top: 2.h,
        bottom: _showBookingForm ? 50.h : 2.h,
      ),
      itemCount: _filteredCounselors.length,
      itemBuilder: (context, index) {
        final counselor = _filteredCounselors[index];
        final isExpanded = _expandedCounselorId == counselor['id'];

        return Column(
          children: [
            CounselorCardWidget(
              counselor: counselor,
              isExpanded: isExpanded,
              onTap: () => _toggleCounselorExpansion(counselor['id'] as String),
            ),
            if (isExpanded) ...[
              SizedBox(height: 2.h),
              AvailabilityCalendarWidget(
                counselor: counselor,
                selectedDate: _selectedDate,
                selectedTime: _selectedTime,
                onSlotSelected: (date, time) =>
                    _selectTimeSlot(counselor, date, time),
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _buildBookingBottomSheet() {
    return BookingFormWidget(
      counselor: _selectedCounselor,
      selectedDate: _selectedDate,
      selectedTime: _selectedTime,
      onBookingConfirmed: _handleBookingConfirmed,
    );
  }

  void _toggleCounselorExpansion(String counselorId) {
    setState(() {
      if (_expandedCounselorId == counselorId) {
        _expandedCounselorId = null;
        _selectedDate = null;
        _selectedTime = null;
        _selectedCounselor = {};
        _showBookingForm = false;
      } else {
        _expandedCounselorId = counselorId;
        _selectedDate = null;
        _selectedTime = null;
        _selectedCounselor = {};
        _showBookingForm = false;
      }
    });
  }

  void _selectTimeSlot(
      Map<String, dynamic> counselor, DateTime date, String time) {
    setState(() {
      _selectedDate = date;
      _selectedTime = time;
      _selectedCounselor = counselor;
      _showBookingForm = true;
    });
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterBottomSheetWidget(
        currentFilters: _filters,
        onFiltersApplied: (filters) {
          setState(() {
            _filters = filters;
          });
        },
      ),
    );
  }

  void _clearFilters() {
    setState(() {
      _filters = {
        'specializations': <String>[],
        'languages': <String>[],
        'availability': null,
        'minRating': 0.0,
      };
    });
  }

  Future<void> _refreshCounselors() async {
    setState(() => _isLoading = true);

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  void _handleBookingConfirmed() {
    setState(() {
      _showBookingForm = false;
      _expandedCounselorId = null;
      _selectedDate = null;
      _selectedTime = null;
      _selectedCounselor = {};
    });

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            CustomIconWidget(
              iconName: 'check_circle',
              color: Colors.white,
              size: 20,
            ),
            SizedBox(width: 2.w),
            Expanded(
              child: Text(
                'Appointment booked successfully! You will receive a confirmation shortly.',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: AppTheme.successLight,
        duration: const Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(4.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );

    // Navigate back to dashboard after a delay
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/main-dashboard');
      }
    });
  }
}
