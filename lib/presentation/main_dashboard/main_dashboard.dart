import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/feature_card_widget.dart';
import './widgets/greeting_header_widget.dart';
import './widgets/mood_selector_widget.dart';
import './widgets/wellness_resource_card_widget.dart';

class MainDashboard extends StatefulWidget {
  const MainDashboard({Key? key}) : super(key: key);

  @override
  State<MainDashboard> createState() => _MainDashboardState();
}

class _MainDashboardState extends State<MainDashboard>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  String selectedMood = '';
  bool isRefreshing = false;

  // Mock data for wellness resources
  final List<Map<String, dynamic>> wellnessResources = [
    {
      "id": 1,
      "title": "Morning Meditation",
      "description": "Start your day with peaceful mindfulness practice",
      "type": "meditation",
      "duration": "10 min",
      "image":
          "https://images.pexels.com/photos/3822622/pexels-photo-3822622.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "rating": 4.8,
      "participants": 1200,
      "isBookmarked": false,
    },
    {
      "id": 2,
      "title": "Stress Relief Breathing",
      "description": "Quick breathing exercises to reduce anxiety",
      "type": "audio",
      "duration": "5 min",
      "image":
          "https://images.pexels.com/photos/4056723/pexels-photo-4056723.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "rating": 4.6,
      "participants": 850,
      "isBookmarked": true,
    },
    {
      "id": 3,
      "title": "Study Focus Tips",
      "description": "Effective techniques to improve concentration",
      "type": "video",
      "duration": "15 min",
      "image":
          "https://images.pexels.com/photos/4050315/pexels-photo-4050315.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "rating": 4.7,
      "participants": 2100,
      "isBookmarked": false,
    },
    {
      "id": 4,
      "title": "Sleep Stories",
      "description": "Calming bedtime stories for better sleep",
      "type": "audio",
      "duration": "20 min",
      "image":
          "https://images.pexels.com/photos/3771069/pexels-photo-3771069.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "rating": 4.9,
      "participants": 950,
      "isBookmarked": true,
    },
  ];

  // Mock data for peer support stats
  final Map<String, dynamic> peerSupportData = {
    "activeDiscussions": 24,
    "onlineUsers": 156,
    "todayMessages": 342,
  };

  // Mock data for counselor availability
  final List<Map<String, dynamic>> availableSlots = [
    {
      "counselor": "Dr. Sarah Johnson",
      "specialty": "Anxiety & Stress",
      "nextSlot": "Today 3:00 PM",
      "rating": 4.9,
    },
    {
      "counselor": "Dr. Raj Patel",
      "specialty": "Academic Pressure",
      "nextSlot": "Tomorrow 10:00 AM",
      "rating": 4.8,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _handleRefresh,
          color: AppTheme.primaryLight,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Greeting Header
                    GreetingHeaderWidget(
                      userName: "Anonymous User",
                      wellnessStreak: 7,
                    ),

                    // Main Content
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Mood Selector
                          MoodSelectorWidget(
                            onMoodSelected: (mood) {
                              setState(() {
                                selectedMood = mood;
                              });
                              _handleMoodSelection(mood);
                            },
                          ),

                          SizedBox(height: 3.h),

                          // AI Companion Card
                          FeatureCardWidget(
                            title: "Chat with AI Companion",
                            subtitle: selectedMood.isNotEmpty
                                ? "Let's talk about how you're feeling ${_getMoodEmoji(selectedMood)}"
                                : "Your confidential mental health companion",
                            iconName: "chat_bubble_outline",
                            backgroundColor: AppTheme.lightTheme.cardColor,
                            iconColor: AppTheme.primaryLight,
                            onTap: () => _navigateToAIChat(),
                            trailing: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 2.w, vertical: 0.5.h),
                              decoration: BoxDecoration(
                                color: AppTheme.successLight
                                    .withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                "24/7",
                                style: AppTheme.lightTheme.textTheme.bodySmall
                                    ?.copyWith(
                                  color: AppTheme.successLight,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),

                          // Book Counselor Card
                          FeatureCardWidget(
                            title: "Book Professional Counselor",
                            subtitle:
                                "Next available: ${availableSlots.first['nextSlot']}",
                            iconName: "psychology",
                            backgroundColor: AppTheme.lightTheme.cardColor,
                            iconColor: AppTheme.secondaryLight,
                            onTap: () => _navigateToCounselorBooking(),
                            trailing: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 2.w, vertical: 0.5.h),
                              decoration: BoxDecoration(
                                color: AppTheme.warningLight
                                    .withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomIconWidget(
                                    iconName: 'star',
                                    color: AppTheme.warningLight,
                                    size: 12,
                                  ),
                                  SizedBox(width: 1.w),
                                  Text(
                                    "${availableSlots.first['rating']}",
                                    style: AppTheme
                                        .lightTheme.textTheme.bodySmall
                                        ?.copyWith(
                                      color: AppTheme.warningLight,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Peer Support Card
                          FeatureCardWidget(
                            title: "Join Peer Support Lounge",
                            subtitle:
                                "${peerSupportData['onlineUsers']} students online • ${peerSupportData['activeDiscussions']} active discussions",
                            iconName: "groups",
                            backgroundColor: AppTheme.lightTheme.cardColor,
                            iconColor: AppTheme.successLight,
                            onTap: () => _navigateToPeerSupport(),
                            trailing: Container(
                              width: 3.w,
                              height: 3.w,
                              decoration: BoxDecoration(
                                color: AppTheme.successLight,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),

                          SizedBox(height: 3.h),

                          // Wellness Resources Section
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Wellness Resources',
                                style: AppTheme.lightTheme.textTheme.titleLarge
                                    ?.copyWith(
                                  color: AppTheme.textHighEmphasisLight,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              TextButton(
                                onPressed: () => _navigateToResources(),
                                child: Text(
                                  'View All',
                                  style: AppTheme
                                      .lightTheme.textTheme.bodyMedium
                                      ?.copyWith(
                                    color: AppTheme.primaryLight,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 1.h),

                          // Horizontal Scrolling Resources
                          SizedBox(
                            height: 32.h,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              padding: EdgeInsets.only(left: 1.w),
                              itemCount: wellnessResources.length,
                              itemBuilder: (context, index) {
                                final resource = wellnessResources[index];
                                return WellnessResourceCardWidget(
                                  resource: resource,
                                  onTap: () => _openResource(resource),
                                  onBookmark: () => _toggleBookmark(resource),
                                );
                              },
                            ),
                          ),

                          SizedBox(height: 3.h),

                          // Quick Access Section
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(4.w),
                            decoration: BoxDecoration(
                              color: AppTheme.accentLight,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Quick Access',
                                  style: AppTheme
                                      .lightTheme.textTheme.titleMedium
                                      ?.copyWith(
                                    color: AppTheme.textHighEmphasisLight,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 2.h),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    _buildQuickAccessItem(
                                      'Breathing Exercise',
                                      'self_improvement',
                                      AppTheme.primaryLight,
                                      () => _startBreathingExercise(),
                                    ),
                                    _buildQuickAccessItem(
                                      'Crisis Support',
                                      'emergency',
                                      AppTheme.errorLight,
                                      () => _showCrisisSupport(),
                                    ),
                                    _buildQuickAccessItem(
                                      'Progress Tracker',
                                      'trending_up',
                                      AppTheme.successLight,
                                      () => _openProgressTracker(),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 10.h), // Bottom padding for tab bar
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildQuickAccessItem(
      String label, String iconName, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 15.w,
            height: 7.h,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: color.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Center(
              child: CustomIconWidget(
                iconName: iconName,
                color: color,
                size: 24,
              ),
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            label,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.textMediumEmphasisLight,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.cardColor,
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          _handleBottomNavigation(index);
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedItemColor: AppTheme.primaryLight,
        unselectedItemColor: AppTheme.neutralLight,
        selectedLabelStyle: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: AppTheme.lightTheme.textTheme.bodySmall,
        items: [
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: _currentIndex == 0 ? 'home' : 'home_outlined',
              color: _currentIndex == 0
                  ? AppTheme.primaryLight
                  : AppTheme.neutralLight,
              size: 24,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Stack(
              children: [
                CustomIconWidget(
                  iconName: _currentIndex == 1 ? 'chat' : 'chat_bubble_outline',
                  color: _currentIndex == 1
                      ? AppTheme.primaryLight
                      : AppTheme.neutralLight,
                  size: 24,
                ),
                if (selectedMood.isNotEmpty)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 2.w,
                      height: 2.w,
                      decoration: BoxDecoration(
                        color: AppTheme.successLight,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
              ],
            ),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: _currentIndex == 2
                  ? 'library_books'
                  : 'library_books_outlined',
              color: _currentIndex == 2
                  ? AppTheme.primaryLight
                  : AppTheme.neutralLight,
              size: 24,
            ),
            label: 'Resources',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: _currentIndex == 3 ? 'person' : 'person_outline',
              color: _currentIndex == 3
                  ? AppTheme.primaryLight
                  : AppTheme.neutralLight,
              size: 24,
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: _showCrisisSupport,
      backgroundColor: AppTheme.errorLight,
      child: CustomIconWidget(
        iconName: 'emergency',
        color: Colors.white,
        size: 28,
      ),
    );
  }

  // Navigation methods
  void _navigateToAIChat() {
    Navigator.pushNamed(context, '/ai-companion-chat');
  }

  void _navigateToCounselorBooking() {
    Navigator.pushNamed(context, '/professional-counselor-booking');
  }

  void _navigateToPeerSupport() {
    Navigator.pushNamed(context, '/peer-support-chat-lounge');
  }

  void _navigateToResources() {
    // Navigate to resources screen
  }

  void _handleBottomNavigation(int index) {
    switch (index) {
      case 0:
        // Already on home
        break;
      case 1:
        _navigateToAIChat();
        break;
      case 2:
        _navigateToResources();
        break;
      case 3:
        // Navigate to profile
        break;
    }
  }

  // Utility methods
  String _getMoodEmoji(String mood) {
    switch (mood) {
      case 'great':
        return '😊';
      case 'good':
        return '🙂';
      case 'okay':
        return '😐';
      case 'low':
        return '😔';
      case 'anxious':
        return '😰';
      default:
        return '';
    }
  }

  void _handleMoodSelection(String mood) {
    // Handle mood selection logic
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Mood recorded: ${mood.toUpperCase()}'),
        backgroundColor: AppTheme.primaryLight,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _handleRefresh() async {
    setState(() {
      isRefreshing = true;
    });

    // Simulate refresh delay
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      isRefreshing = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Content refreshed'),
        backgroundColor: AppTheme.successLight,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _openResource(Map<String, dynamic> resource) {
    // Handle resource opening based on type
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(resource['title']),
        content:
            Text('Opening ${resource['type']}: ${resource['description']}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _toggleBookmark(Map<String, dynamic> resource) {
    setState(() {
      resource['isBookmarked'] = !(resource['isBookmarked'] ?? false);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(resource['isBookmarked']
            ? 'Added to bookmarks'
            : 'Removed from bookmarks'),
        backgroundColor: AppTheme.primaryLight,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _startBreathingExercise() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Breathing Exercise'),
        content: const Text('Starting guided breathing exercise...'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Start'),
          ),
        ],
      ),
    );
  }

  void _showCrisisSupport() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'emergency',
              color: AppTheme.errorLight,
              size: 24,
            ),
            SizedBox(width: 2.w),
            const Text('Crisis Support'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('If you\'re in immediate danger, please contact:'),
            SizedBox(height: 2.h),
            Text(
              '• Emergency Services: 112',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '• Mental Health Helpline: 1800-599-0019',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '• Campus Counseling: Available 24/7',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Handle emergency contact
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorLight,
            ),
            child: const Text('Call Now'),
          ),
        ],
      ),
    );
  }

  void _openProgressTracker() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Progress Tracker'),
        content: const Text('Opening your wellness progress tracker...'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('View Progress'),
          ),
        ],
      ),
    );
  }
}
