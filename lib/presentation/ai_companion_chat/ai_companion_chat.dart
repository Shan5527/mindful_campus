import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../services/gemini_client.dart';
import '../../services/gemini_service.dart';
import './widgets/chat_input_widget.dart';
import './widgets/chat_message_widget.dart';
import './widgets/conversation_history_sheet.dart';
import './widgets/crisis_detection_overlay.dart';
import './widgets/message_context_menu.dart';

class AiCompanionChat extends StatefulWidget {
  const AiCompanionChat({Key? key}) : super(key: key);

  @override
  State<AiCompanionChat> createState() => _AiCompanionChatState();
}

class _AiCompanionChatState extends State<AiCompanionChat>
    with TickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, dynamic>> _messages = [];
  final List<Map<String, dynamic>> _conversationHistory = [];

  // Gemini AI integration
  late GeminiClient _geminiClient;
  final List<Message> _chatHistory = [];

  bool _isLoading = false;
  bool _showCrisisOverlay = false;
  bool _isTyping = false;
  String? _selectedMessageForMenu;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  // Mock conversation history data
  final List<Map<String, dynamic>> mockConversationHistory = [
    {
      "id": 1,
      "title": "Exam Stress Discussion",
      "preview":
          "I've been feeling overwhelmed with my upcoming exams. The pressure is really getting to me and I can't seem to focus...",
      "date": DateTime.now().subtract(const Duration(days: 2)),
      "messageCount": 15,
    },
    {
      "id": 2,
      "title": "Sleep Issues Chat",
      "preview":
          "I've been having trouble sleeping lately. My mind keeps racing with thoughts about assignments and deadlines...",
      "date": DateTime.now().subtract(const Duration(days: 5)),
      "messageCount": 8,
    },
    {
      "id": 3,
      "title": "Social Anxiety Support",
      "preview":
          "I find it really difficult to make friends in college. I get anxious in social situations and often feel left out...",
      "date": DateTime.now().subtract(const Duration(days: 7)),
      "messageCount": 22,
    },
    {
      "id": 4,
      "title": "Family Pressure Discussion",
      "preview":
          "My parents have very high expectations for my grades. Sometimes I feel like I'm not good enough and it's affecting my mental health...",
      "date": DateTime.now().subtract(const Duration(days: 10)),
      "messageCount": 12,
    },
  ];

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_fadeController);
    _fadeController.forward();

    // Initialize Gemini client
    _initializeGemini();
    _initializeChat();
  }

  void _initializeGemini() {
    try {
      final geminiService = GeminiService();
      _geminiClient = GeminiClient(geminiService.dio, geminiService.authApiKey);
    } catch (e) {
      Fluttertoast.showToast(
        msg: "AI service initialization failed. Using offline mode.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _initializeChat() {
    // Add system message to chat history
    _chatHistory.add(Message(
        role: 'model',
        content:
            'You are a compassionate AI mental health companion for college students in India. Provide empathetic, culturally sensitive support in both English and Hindi when appropriate. Focus on emotional wellbeing, stress management, and academic balance. Always prioritize user safety and recommend professional help when needed.'));

    // Add welcome message
    setState(() {
      _messages.add({
        'message':
            'नमस्ते! I\'m your AI companion here to support you through your mental health journey. Feel free to share what\'s on your mind - this is a safe, confidential space. How are you feeling today?',
        'isUser': false,
        'timestamp': DateTime.now(),
        'isTyping': false,
      });
    });
  }

  void _sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isEmpty || _isLoading) return;

    setState(() {
      _messages.add({
        'message': message,
        'isUser': true,
        'timestamp': DateTime.now(),
        'isTyping': false,
      });
      _isLoading = true;
      _isTyping = true;
    });

    _messageController.clear();
    _scrollToBottom();

    // Add user message to chat history
    _chatHistory.add(Message(role: 'user', content: message));

    // Check for crisis keywords
    if (_detectCrisisKeywords(message)) {
      Future.delayed(const Duration(milliseconds: 500), () {
        setState(() {
          _showCrisisOverlay = true;
          _isLoading = false;
          _isTyping = false;
        });
      });
      return;
    }

    // Add typing indicator
    setState(() {
      _messages.add({
        'message': '',
        'isUser': false,
        'timestamp': DateTime.now(),
        'isTyping': true,
      });
    });

    // Get AI response from Gemini
    try {
      final response = await _geminiClient.createChat(
        messages: _chatHistory,
        model: 'gemini-1.5-flash-002',
        maxTokens: 1024,
        temperature: 0.8,
      );

      // Add AI response to chat history
      _chatHistory.add(Message(role: 'model', content: response.text));

      setState(() {
        _messages.removeLast(); // Remove typing indicator
        _messages.add({
          'message': response.text,
          'isUser': false,
          'timestamp': DateTime.now(),
          'isTyping': false,
        });
        _isLoading = false;
        _isTyping = false;
      });
    } catch (e) {
      // Fallback to mock response if API fails
      setState(() {
        _messages.removeLast(); // Remove typing indicator
        _messages.add({
          'message': _getFallbackResponse(message),
          'isUser': false,
          'timestamp': DateTime.now(),
          'isTyping': false,
        });
        _isLoading = false;
        _isTyping = false;
      });

      Fluttertoast.showToast(
        msg: "AI service temporarily unavailable. Using fallback response.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }

    _scrollToBottom();
  }

  String _getFallbackResponse(String userMessage) {
    final fallbackResponses = [
      "I understand you're going through a challenging time. It's completely normal to feel overwhelmed sometimes. Remember, हर मुश्किल का हल होता है (every problem has a solution). What specific aspect is troubling you the most?",
      "Thank you for sharing that with me. Your feelings are valid, and it takes courage to open up. In our culture, we often say 'यह भी गुजर जाएगा' (this too shall pass). Let's work through this together. Can you tell me more about what triggered these feelings?",
      "I hear you, and I want you to know that seeking support shows strength, not weakness. Many students face similar challenges. Have you considered talking to a counselor or trusted friend? Sometimes sharing our burden makes it lighter - जैसा कि कहते हैं, 'बांटने से दुख कम हो जाता है'।",
      "It sounds like you're dealing with a lot of pressure. Remember, your worth isn't defined by your grades or achievements. You are valuable just as you are. What are some small steps we can take today to help you feel better?",
      "I appreciate you trusting me with your thoughts. Mental health is just as important as physical health. In times like these, practicing self-compassion is crucial. What activities usually help you feel calm or relaxed?",
    ];

    return fallbackResponses[
        DateTime.now().millisecond % fallbackResponses.length];
  }

  bool _detectCrisisKeywords(String message) {
    final crisisKeywords = [
      'suicide',
      'kill myself',
      'end it all',
      'hurt myself',
      'self harm',
      'want to die',
      'no point living',
      'better off dead',
      'harm myself',
      'suicide', // Hindi variations
      'मरना चाहता हूं',
      'जिंदगी से परेशान',
      'खुद को नुकसान',
    ];
    final lowerMessage = message.toLowerCase();
    return crisisKeywords.any((keyword) => lowerMessage.contains(keyword));
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _handleVoiceInput() {
    HapticFeedback.lightImpact();
    Fluttertoast.showToast(
      msg: "Voice input feature coming soon!",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _showConversationHistory() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ConversationHistorySheet(
        conversations: mockConversationHistory,
        onSearchChanged: (query) {
          // Handle search functionality
        },
        onConversationSelected: (conversation) {
          Navigator.pop(context);
          Fluttertoast.showToast(
            msg: "Loading conversation: ${conversation['title']}",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
          );
        },
      ),
    );
  }

  void _showMessageContextMenu(String message) {
    setState(() {
      _selectedMessageForMenu = message;
    });
  }

  void _hideMessageContextMenu() {
    setState(() {
      _selectedMessageForMenu = null;
    });
  }

  void _copyMessage(String message) {
    Clipboard.setData(ClipboardData(text: message));
    Fluttertoast.showToast(
      msg: "Message copied to clipboard",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _bookmarkMessage(String message) {
    Fluttertoast.showToast(
      msg: "Message bookmarked successfully",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _reportMessage(String message) {
    Fluttertoast.showToast(
      msg: "Message reported. Thank you for your feedback.",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _exportConversation() {
    final conversationText = _messages
        .where((msg) => !msg['isTyping'])
        .map((msg) =>
            "${msg['isUser'] ? 'You' : 'AI Companion'}: ${msg['message']}")
        .join('\n\n');

    Clipboard.setData(ClipboardData(text: conversationText));
    Fluttertoast.showToast(
      msg: "Conversation exported to clipboard",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _contactCounselor() {
    setState(() {
      _showCrisisOverlay = false;
    });
    Navigator.pushNamed(context, '/professional-counselor-booking');
  }

  void _callEmergencyHelpline() {
    setState(() {
      _showCrisisOverlay = false;
    });
    Fluttertoast.showToast(
      msg: "Redirecting to emergency helpline...",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Stack(
            children: [
              Column(
                children: [
                  _buildHeader(),
                  _buildDisclaimerBanner(),
                  Expanded(
                    child: _buildChatArea(),
                  ),
                  ChatInputWidget(
                    controller: _messageController,
                    onSend: _sendMessage,
                    onVoiceInput: _handleVoiceInput,
                    isLoading: _isLoading,
                  ),
                ],
              ),
              if (_showCrisisOverlay)
                CrisisDetectionOverlay(
                  onClose: () => setState(() => _showCrisisOverlay = false),
                  onContactCounselor: _contactCounselor,
                  onEmergencyContact: _callEmergencyHelpline,
                ),
              if (_selectedMessageForMenu != null)
                MessageContextMenu(
                  message: _selectedMessageForMenu!,
                  onCopy: () => _copyMessage(_selectedMessageForMenu!),
                  onBookmark: () => _bookmarkMessage(_selectedMessageForMenu!),
                  onReport: () => _reportMessage(_selectedMessageForMenu!),
                  onClose: _hideMessageContextMenu,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: EdgeInsets.all(2.w),
              child: CustomIconWidget(
                iconName: 'arrow_back',
                color: AppTheme.lightTheme.colorScheme.onSurface,
                size: 6.w,
              ),
            ),
          ),
          SizedBox(width: 3.w),
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primary
                  .withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: CustomIconWidget(
              iconName: 'psychology',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 6.w,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'AI Companion',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 2.w, vertical: 0.5.h),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(1.w),
                      ),
                      child: Text(
                        'Gemini',
                        style:
                            AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.primary,
                          fontSize: 9.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  _isTyping ? 'Typing...' : 'Online • Confidential',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: _isTyping
                        ? AppTheme.lightTheme.colorScheme.primary
                        : AppTheme.successLight,
                    fontSize: 11.sp,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: _showConversationHistory,
            child: Container(
              padding: EdgeInsets.all(2.w),
              child: CustomIconWidget(
                iconName: 'history',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 6.w,
              ),
            ),
          ),
          SizedBox(width: 2.w),
          PopupMenuButton<String>(
            icon: CustomIconWidget(
              iconName: 'more_vert',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 6.w,
            ),
            onSelected: (value) {
              switch (value) {
                case 'export':
                  _exportConversation();
                  break;
                case 'clear':
                  setState(() {
                    _messages.clear();
                    _chatHistory.clear();
                    _initializeChat();
                  });
                  break;
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'export',
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'download',
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                      size: 5.w,
                    ),
                    SizedBox(width: 3.w),
                    Text('Export Chat'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'clear',
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'clear_all',
                      color: AppTheme.errorLight,
                      size: 5.w,
                    ),
                    SizedBox(width: 3.w),
                    Text('Clear Chat',
                        style: TextStyle(color: AppTheme.errorLight)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDisclaimerBanner() {
    return Container(
      margin: EdgeInsets.all(4.w),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.warningLight.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(2.w),
        border: Border.all(
          color: AppTheme.warningLight.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: 'info',
            color: AppTheme.warningLight,
            size: 4.w,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Text(
              'This AI provides support but isn\'t a replacement for professional help. In crisis situations, please contact a counselor.',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface,
                fontSize: 11.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatArea() {
    return Container(
      child: _messages.isEmpty
          ? _buildEmptyState()
          : RefreshIndicator(
              onRefresh: () async {
                // Simulate loading previous messages
                await Future.delayed(const Duration(seconds: 1));
                Fluttertoast.showToast(
                  msg: "Previous messages loaded",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                );
              },
              child: ListView.builder(
                controller: _scrollController,
                padding: EdgeInsets.symmetric(vertical: 2.h),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  return ChatMessageWidget(
                    message: message['message'],
                    isUser: message['isUser'],
                    timestamp: message['timestamp'],
                    isTyping: message['isTyping'] ?? false,
                    onLongPress: message['isTyping'] == true
                        ? null
                        : () {
                            _showMessageContextMenu(message['message']);
                          },
                  );
                },
              ),
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primary
                  .withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: CustomIconWidget(
              iconName: 'psychology',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 15.w,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'Welcome to AI Companion',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(2.w),
            ),
            child: Text(
              'Powered by Gemini AI',
              style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.primary,
                fontSize: 10.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(height: 2.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: Text(
              'I\'m here to provide mental health support and guidance. Share your thoughts, feelings, or concerns - this is a safe space.',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
