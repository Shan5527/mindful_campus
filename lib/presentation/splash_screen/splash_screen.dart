import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _breathingController;
  late AnimationController _fadeController;
  late Animation<double> _breathingAnimation;
  late Animation<double> _fadeAnimation;

  bool _isInitialized = false;
  String _statusText = 'Preparing your safe space...';

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeApp();
  }

  void _initializeAnimations() {
    // Breathing animation for logo
    _breathingController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _breathingAnimation = Tween<double>(
      begin: 0.95,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _breathingController,
      curve: Curves.easeInOut,
    ));

    // Fade animation for content
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    ));

    // Start animations
    _fadeController.forward();
    _breathingController.repeat(reverse: true);
  }

  Future<void> _initializeApp() async {
    try {
      // Simulate app initialization tasks
      await Future.wait([
        _checkAuthenticationStatus(),
        _loadContentPreferences(),
        _initializeAIChatbot(),
        _loadCachedResources(),
      ]);

      setState(() {
        _isInitialized = true;
        _statusText = 'Welcome to your safe space';
      });

      // Wait a moment to show success message
      await Future.delayed(const Duration(milliseconds: 500));

      _navigateToNextScreen();
    } catch (e) {
      // Handle initialization errors gracefully
      setState(() {
        _statusText = 'Continue Offline';
      });

      // Show offline option after 5 seconds
      await Future.delayed(const Duration(seconds: 5));
      _navigateToNextScreen();
    }
  }

  Future<void> _checkAuthenticationStatus() async {
    // Simulate checking anonymous authentication
    await Future.delayed(const Duration(milliseconds: 800));
  }

  Future<void> _loadContentPreferences() async {
    // Simulate loading multilingual content preferences
    await Future.delayed(const Duration(milliseconds: 600));
  }

  Future<void> _initializeAIChatbot() async {
    // Simulate AI chatbot initialization
    await Future.delayed(const Duration(milliseconds: 700));
  }

  Future<void> _loadCachedResources() async {
    // Simulate loading cached wellness resources
    await Future.delayed(const Duration(milliseconds: 500));
  }

  void _navigateToNextScreen() {
    // Check if user is first-time or returning
    bool isFirstTime = true; // This would come from actual storage check

    if (isFirstTime) {
      Navigator.pushReplacementNamed(context, '/onboarding-flow');
    } else {
      Navigator.pushReplacementNamed(context, '/main-dashboard');
    }
  }

  @override
  void dispose() {
    _breathingController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
              AppTheme.lightTheme.colorScheme.surface,
              AppTheme.lightTheme.colorScheme.tertiary.withValues(alpha: 0.05),
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Spacer to push content to center
                const Spacer(flex: 2),

                // Animated Logo Section
                AnimatedBuilder(
                  animation: _breathingAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _breathingAnimation.value,
                      child: Container(
                        width: 25.w,
                        height: 25.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppTheme.lightTheme.colorScheme.primary,
                              AppTheme.lightTheme.colorScheme.secondary,
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.lightTheme.colorScheme.primary
                                  .withValues(alpha: 0.3),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: Center(
                          child: CustomIconWidget(
                            iconName: 'psychology',
                            color: Colors.white,
                            size: 12.w,
                          ),
                        ),
                      ),
                    );
                  },
                ),

                SizedBox(height: 4.h),

                // App Name
                Text(
                  'Mindful Campus',
                  style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 1.h),

                // Tagline
                Text(
                  'Your confidential mental wellness companion',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurface
                        .withValues(alpha: 0.7),
                  ),
                  textAlign: TextAlign.center,
                ),

                const Spacer(flex: 1),

                // Loading Section
                Column(
                  children: [
                    // Loading Indicator
                    SizedBox(
                      width: 8.w,
                      height: 8.w,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppTheme.lightTheme.colorScheme.primary,
                        ),
                        backgroundColor: AppTheme.lightTheme.colorScheme.primary
                            .withValues(alpha: 0.2),
                      ),
                    ),

                    SizedBox(height: 3.h),

                    // Status Text
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: Text(
                        _statusText,
                        key: ValueKey(_statusText),
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color: _isInitialized
                              ? AppTheme.lightTheme.colorScheme.tertiary
                              : AppTheme.lightTheme.colorScheme.onSurface
                                  .withValues(alpha: 0.6),
                          fontWeight: _isInitialized
                              ? FontWeight.w500
                              : FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),

                const Spacer(flex: 2),

                // Bottom Section - Confidentiality Notice
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomIconWidget(
                            iconName: 'security',
                            color: AppTheme.lightTheme.colorScheme.tertiary,
                            size: 4.w,
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            'Confidential & Secure',
                            style: AppTheme.lightTheme.textTheme.labelMedium
                                ?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.tertiary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        'Your privacy and mental health are our priority',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.onSurface
                              .withValues(alpha: 0.5),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 4.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
