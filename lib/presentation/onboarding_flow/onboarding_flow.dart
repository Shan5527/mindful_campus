import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/language_selector_widget.dart';
import './widgets/navigation_controls_widget.dart';
import './widgets/onboarding_page_widget.dart';
import './widgets/page_indicator_widget.dart';

class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow({Key? key}) : super(key: key);

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  int _currentPage = 0;
  String _currentLanguage = 'en';

  final List<Map<String, dynamic>> _onboardingData = [
    {
      "title_en": "Your Anonymous AI Companion",
      "title_hi": "आपका गुमनाम AI साथी",
      "title_ur": "آپ کا گمنام AI ساتھی",
      "description_en":
          "Meet your confidential mental health companion. Chat anonymously with our AI-powered support system designed specifically for college students. No judgments, just understanding.",
      "description_hi":
          "अपने गोपनीय मानसिक स्वास्थ्य साथी से मिलें। कॉलेज छात्रों के लिए विशेष रूप से डिज़ाइन किए गए हमारे AI-संचालित सहायता प्रणाली के साथ गुमनाम रूप से चैट करें।",
      "description_ur":
          "اپنے خفیہ ذہنی صحت کے ساتھی سے ملیں۔ کالج کے طلباء کے لیے خاص طور پر ڈیزائن کیے گئے ہمارے AI سے چلنے والے سپورٹ سسٹم کے ساتھ گمنام طریقے سے بات کریں۔",
      "image":
          "https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?fm=jpg&q=80&w=800&h=600"
    },
    {
      "title_en": "Safe Peer Support Community",
      "title_hi": "सुरक्षित साथी सहायता समुदाय",
      "title_ur": "محفوظ ہم عمر سپورٹ کمیونٹی",
      "description_en":
          "Connect with fellow students in our moderated peer support lounge. Share experiences, find understanding, and build meaningful connections while maintaining complete anonymity.",
      "description_hi":
          "हमारे नियंत्रित साथी सहायता लाउंज में साथी छात्रों से जुड़ें। अनुभव साझा करें, समझ पाएं, और पूर्ण गुमनामी बनाए रखते हुए सार्थक संबंध बनाएं।",
      "description_ur":
          "ہمارے منظم ہم عمر سپورٹ لاؤنج میں ساتھی طلباء سے جڑیں۔ تجربات شیئر کریں، سمجھ حاصل کریں، اور مکمل گمنامی برقرار رکھتے ہوئے بامعنی تعلقات بنائیں۔",
      "image":
          "https://images.unsplash.com/photo-1529156069898-49953e39b3ac?fm=jpg&q=80&w=800&h=600"
    },
    {
      "title_en": "Professional Counselor Booking",
      "title_hi": "पेशेवर परामर्शदाता बुकिंग",
      "title_ur": "پیشہ ور کونسلر بکنگ",
      "description_en":
          "Book confidential sessions with licensed mental health professionals. Our secure booking system ensures your privacy while connecting you with qualified counselors who understand student life.",
      "description_hi":
          "लाइसेंस प्राप्त मानसिक स्वास्थ्य पेशेवरों के साथ गोपनीय सत्र बुक करें। हमारी सुरक्षित बुकिंग प्रणाली आपकी गोपनीयता सुनिश्चित करती है।",
      "description_ur":
          "لائسنس یافتہ ذہنی صحت کے پیشہ ور افراد کے ساتھ خفیہ سیشن بک کریں۔ ہمارا محفوظ بکنگ سسٹم آپ کی رازداری کو یقینی بناتا ہے۔",
      "image":
          "https://images.unsplash.com/photo-1559757148-5c350d0d3c56?fm=jpg&q=80&w=800&h=600"
    },
    {
      "title_en": "Crisis Support & Resources",
      "title_hi": "संकट सहायता और संसाधन",
      "title_ur": "بحرانی سپورٹ اور وسائل",
      "description_en":
          "Access immediate crisis support and comprehensive wellness resources. From guided meditation to emergency contacts, we're here to support you through every challenge.",
      "description_hi":
          "तत्काल संकट सहायता और व्यापक कल्याण संसाधनों तक पहुंच प्राप्त करें। निर्देशित ध्यान से लेकर आपातकालीन संपर्कों तक, हम हर चुनौती में आपका साथ देने के लिए यहां हैं।",
      "description_ur":
          "فوری بحرانی سپورٹ اور جامع فلاحی وسائل تک رسائی حاصل کریں۔ رہنمائی شدہ مراقبے سے لے کر ہنگامی رابطوں تک، ہم ہر چیلنج میں آپ کا ساتھ دینے کے لیے یہاں ہیں۔",
      "image":
          "https://images.unsplash.com/photo-1544027993-37dbfe43562a?fm=jpg&q=80&w=800&h=600"
    },
    {
      "title_en": "Your Journey Starts Here",
      "title_hi": "आपकी यात्रा यहाँ से शुरू होती है",
      "title_ur": "آپ کا سفر یہاں سے شروع ہوتا ہے",
      "description_en":
          "Take the first step towards better mental health. Join thousands of students who have found support, understanding, and healing through Mindful Campus. Your wellbeing matters.",
      "description_hi":
          "बेहतर मानसिक स्वास्थ्य की दिशा में पहला कदम उठाएं। हजारों छात्रों में शामिल हों जिन्होंने माइंडफुल कैंपस के माध्यम से सहायता, समझ और उपचार पाया है।",
      "description_ur":
          "بہتر ذہنی صحت کی طرف پہلا قدم اٹھائیں۔ ہزاروں طلباء میں شامل ہوں جنہوں نے مائنڈفل کیمپس کے ذریعے سپورٹ، سمجھ اور شفا پائی ہے۔",
      "image":
          "https://images.unsplash.com/photo-1522202176988-66273c2fd55f?fm=jpg&q=80&w=800&h=600"
    },
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _onboardingData.length - 1) {
      HapticFeedback.lightImpact();
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _skipToEnd() {
    HapticFeedback.mediumImpact();
    Navigator.pushReplacementNamed(context, '/main-dashboard');
  }

  void _getStarted() {
    HapticFeedback.mediumImpact();
    Navigator.pushReplacementNamed(context, '/main-dashboard');
  }

  void _onLanguageChanged(String languageCode) {
    setState(() {
      _currentLanguage = languageCode;
    });
    HapticFeedback.selectionClick();
  }

  String _getLocalizedText(Map<String, dynamic> data, String key) {
    final localizedKey = '${key}_$_currentLanguage';
    return data[localizedKey] ?? data['${key}_en'] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Stack(
          children: [
            // Main content
            Column(
              children: [
                // Language selector
                SafeArea(
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: 2.h,
                      right: 4.w,
                      left: 4.w,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Back button (only show after first page)
                        _currentPage > 0
                            ? GestureDetector(
                                onTap: () {
                                  HapticFeedback.lightImpact();
                                  _pageController.previousPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                },
                                child: Container(
                                  padding: EdgeInsets.all(2.w),
                                  decoration: BoxDecoration(
                                    color: AppTheme
                                        .lightTheme.colorScheme.surface
                                        .withValues(alpha: 0.9),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: AppTheme
                                          .lightTheme.colorScheme.primary
                                          .withValues(alpha: 0.3),
                                      width: 1,
                                    ),
                                  ),
                                  child: CustomIconWidget(
                                    iconName: 'arrow_back',
                                    color:
                                        AppTheme.lightTheme.colorScheme.primary,
                                    size: 20,
                                  ),
                                ),
                              )
                            : const SizedBox(width: 40),
                        LanguageSelectorWidget(
                          onLanguageChanged: _onLanguageChanged,
                          currentLanguage: _currentLanguage,
                        ),
                      ],
                    ),
                  ),
                ),

                // Page content
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                      HapticFeedback.selectionClick();
                    },
                    itemCount: _onboardingData.length,
                    itemBuilder: (context, index) {
                      final data = _onboardingData[index];
                      return OnboardingPageWidget(
                        title: _getLocalizedText(data, 'title'),
                        description: _getLocalizedText(data, 'description'),
                        imageUrl: data['image'],
                        isLastPage: index == _onboardingData.length - 1,
                        onGetStarted: _getStarted,
                      );
                    },
                  ),
                ),

                // Page indicator
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  child: PageIndicatorWidget(
                    currentPage: _currentPage,
                    totalPages: _onboardingData.length,
                  ),
                ),

                // Navigation controls
                NavigationControlsWidget(
                  onNext: _nextPage,
                  onSkip: _skipToEnd,
                  isLastPage: _currentPage == _onboardingData.length - 1,
                  currentLanguage: _currentLanguage,
                ),

                SizedBox(height: 2.h),
              ],
            ),

            // Skip to app button (always visible)
            Positioned(
              bottom: 4.h,
              left: 0,
              right: 0,
              child: Center(
                child: TextButton(
                  onPressed: _skipToEnd,
                  style: TextButton.styleFrom(
                    foregroundColor: AppTheme.lightTheme.colorScheme.onSurface
                        .withValues(alpha: 0.5),
                    padding:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                  ),
                  child: Text(
                    _currentLanguage == 'hi'
                        ? 'ऐप पर जाएं'
                        : _currentLanguage == 'ur'
                            ? 'ایپ پر جائیں'
                            : 'Skip to App',
                    style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurface
                          .withValues(alpha: 0.5),
                      fontWeight: FontWeight.w400,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
