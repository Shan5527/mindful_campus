import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/chat_input_widget.dart';
import './widgets/chat_message_widget.dart';
import './widgets/community_guidelines_widget.dart';
import './widgets/topic_channel_widget.dart';
import './widgets/typing_indicator_widget.dart';

class PeerSupportChatLounge extends StatefulWidget {
  const PeerSupportChatLounge({Key? key}) : super(key: key);

  @override
  State<PeerSupportChatLounge> createState() => _PeerSupportChatLoungeState();
}

class _PeerSupportChatLoungeState extends State<PeerSupportChatLounge> {
  final ScrollController _scrollController = ScrollController();
  String _selectedChannel = 'general';
  bool _showGuidelines = false;
  List<String> _typingUsers = [];
  bool _isConnected = true;

  // Mock data for chat messages
  final List<Map<String, dynamic>> _messages = [
    {
      "id": "1",
      "content":
          "Hey everyone, I've been feeling really overwhelmed with my upcoming exams. Anyone else dealing with exam anxiety?",
      "senderName": "Student47",
      "timestamp": DateTime.now().subtract(const Duration(minutes: 15)),
      "isCurrentUser": false,
      "reactions": [
        {"emoji": "❤️", "count": 3},
        {"emoji": "🤗", "count": 2}
      ]
    },
    {
      "id": "2",
      "content":
          "I totally understand! I've been using breathing exercises and they really help. You're not alone in this.",
      "senderName": "Student23",
      "timestamp": DateTime.now().subtract(const Duration(minutes: 12)),
      "isCurrentUser": false,
      "reactions": [
        {"emoji": "🙏", "count": 4}
      ]
    },
    {
      "id": "3",
      "content":
          "Thanks for sharing that. It's comforting to know others are going through similar struggles. I'll try the breathing exercises.",
      "senderName": "You",
      "timestamp": DateTime.now().subtract(const Duration(minutes: 8)),
      "isCurrentUser": true,
      "reactions": []
    },
    {
      "id": "4",
      "content":
          "Has anyone tried the meditation resources in the app? I found them really helpful for managing stress.",
      "senderName": "Student91",
      "timestamp": DateTime.now().subtract(const Duration(minutes: 5)),
      "isCurrentUser": false,
      "reactions": [
        {"emoji": "❤️", "count": 1}
      ]
    },
    {
      "id": "5",
      "content":
          "Yes! The guided meditation for sleep has been a game changer for me. My anxiety was keeping me up at night.",
      "senderName": "Student15",
      "timestamp": DateTime.now().subtract(const Duration(minutes: 2)),
      "isCurrentUser": false,
      "reactions": []
    }
  ];

  // Mock data for topic channels
  final List<Map<String, dynamic>> _channels = [
    {
      "id": "general",
      "name": "General Support",
      "icon": "chat",
      "activeCount": 12
    },
    {
      "id": "exam_stress",
      "name": "Exam Stress",
      "icon": "school",
      "activeCount": 8
    },
    {
      "id": "loneliness",
      "name": "Loneliness",
      "icon": "favorite",
      "activeCount": 5
    },
    {
      "id": "academic_pressure",
      "name": "Academic Pressure",
      "icon": "trending_up",
      "activeCount": 15
    },
    {
      "id": "social_anxiety",
      "name": "Social Anxiety",
      "icon": "groups",
      "activeCount": 7
    }
  ];

  @override
  void initState() {
    super.initState();
    _simulateTypingUsers();
    _scrollToBottom();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _simulateTypingUsers() {
    // Simulate typing indicators
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _typingUsers = ['Student32'];
        });

        Future.delayed(const Duration(seconds: 4), () {
          if (mounted) {
            setState(() {
              _typingUsers = [];
            });
          }
        });
      }
    });
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

  void _sendMessage(String message) {
    final newMessage = {
      "id": DateTime.now().millisecondsSinceEpoch.toString(),
      "content": message,
      "senderName": "You",
      "timestamp": DateTime.now(),
      "isCurrentUser": true,
      "reactions": []
    };

    setState(() {
      _messages.add(newMessage);
    });

    _scrollToBottom();

    // Simulate response after a delay
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        final responses = [
          "Thank you for sharing that. You're very brave.",
          "I can relate to what you're going through. Sending support!",
          "That's a great perspective. Thanks for the insight.",
          "You're not alone in feeling this way. We're here for you.",
          "I appreciate you opening up about this. It helps others too."
        ];

        final response = {
          "id": DateTime.now().millisecondsSinceEpoch.toString(),
          "content": responses[DateTime.now().millisecond % responses.length],
          "senderName": "Student${DateTime.now().millisecond % 99 + 1}",
          "timestamp": DateTime.now(),
          "isCurrentUser": false,
          "reactions": []
        };

        setState(() {
          _messages.add(response);
        });
        _scrollToBottom();
      }
    });
  }

  void _onChannelSelected(String channelId) {
    setState(() {
      _selectedChannel = channelId;
    });

    // Simulate loading messages for different channels
    if (channelId != 'general') {
      setState(() {
        _messages.clear();
        _messages.addAll([
          {
            "id": "channel_1",
            "content":
                "Welcome to the ${_channels.firstWhere((c) => c['id'] == channelId)['name']} channel! Feel free to share your experiences.",
            "senderName": "Moderator",
            "timestamp": DateTime.now().subtract(const Duration(hours: 1)),
            "isCurrentUser": false,
            "reactions": []
          }
        ]);
      });
    }
  }

  void _showReportDialog(Map<String, dynamic> message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Report Message',
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Why are you reporting this message?',
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
            SizedBox(height: 2.h),
            ...['Inappropriate content', 'Spam', 'Harassment', 'Other'].map(
              (reason) => ListTile(
                title: Text(reason),
                onTap: () {
                  Navigator.pop(context);
                  _showReportConfirmation();
                },
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showReportConfirmation() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Message reported. Our moderators will review it.'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _sendPrivateEncouragement(Map<String, dynamic> message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Send Private Encouragement',
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Send an anonymous encouraging message to ${message['senderName']}',
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
            SizedBox(height: 2.h),
            ...[
              'You\'re doing great!',
              'Stay strong!',
              'You\'re not alone',
              'Sending positive vibes'
            ].map(
              (encouragement) => ListTile(
                title: Text(encouragement),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Encouragement sent anonymously!'),
                      backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showMessageOptions(Map<String, dynamic> message) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: CustomIconWidget(
                iconName: 'favorite',
                color: AppTheme.lightTheme.colorScheme.tertiary,
                size: 5.w,
              ),
              title: const Text('Send Private Encouragement'),
              onTap: () {
                Navigator.pop(context);
                _sendPrivateEncouragement(message);
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'report',
                color: AppTheme.lightTheme.colorScheme.error,
                size: 5.w,
              ),
              title: const Text('Report Message'),
              onTap: () {
                Navigator.pop(context);
                _showReportDialog(message);
              },
            ),
            SizedBox(height: 2.h),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _refreshMessages() async {
    // Simulate network refresh
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() {
        // Add a new message to simulate refresh
        _messages.insert(0, {
          "id": "refresh_${DateTime.now().millisecondsSinceEpoch}",
          "content":
              "Hope everyone is having a good day! Remember to take care of yourselves.",
          "senderName": "Student${DateTime.now().millisecond % 99 + 1}",
          "timestamp": DateTime.now().subtract(const Duration(minutes: 30)),
          "isCurrentUser": false,
          "reactions": []
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Peer Support Chat',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '${_getTotalActiveUsers()} students online',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => setState(() => _showGuidelines = true),
            icon: CustomIconWidget(
              iconName: 'info',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 5.w,
            ),
          ),
          PopupMenuButton<String>(
            icon: CustomIconWidget(
              iconName: 'more_vert',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 5.w,
            ),
            onSelected: (value) {
              switch (value) {
                case 'crisis':
                  Navigator.pushNamed(
                      context, '/professional-counselor-booking');
                  break;
                case 'guidelines':
                  setState(() => _showGuidelines = true);
                  break;
                case 'report':
                  _showReportDialog({});
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'crisis',
                child: ListTile(
                  leading: Icon(Icons.emergency, color: Colors.red),
                  title: Text('Crisis Support'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              const PopupMenuItem(
                value: 'guidelines',
                child: ListTile(
                  leading: Icon(Icons.shield),
                  title: Text('Community Guidelines'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              const PopupMenuItem(
                value: 'report',
                child: ListTile(
                  leading: Icon(Icons.report),
                  title: Text('Report Issue'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // Connection status
              if (!_isConnected)
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 1.h),
                  color: AppTheme.lightTheme.colorScheme.error
                      .withValues(alpha: 0.1),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconWidget(
                        iconName: 'wifi_off',
                        color: AppTheme.lightTheme.colorScheme.error,
                        size: 4.w,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'Reconnecting...',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.error,
                        ),
                      ),
                    ],
                  ),
                ),

              // Topic channels
              TopicChannelWidget(
                channels: _channels,
                selectedChannel: _selectedChannel,
                onChannelSelected: _onChannelSelected,
              ),

              // Chat messages
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _refreshMessages,
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: EdgeInsets.symmetric(vertical: 1.h),
                    itemCount:
                        _messages.length + (_typingUsers.isNotEmpty ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == _messages.length) {
                        return TypingIndicatorWidget(typingUsers: _typingUsers);
                      }

                      final message = _messages[index];
                      return ChatMessageWidget(
                        message: message,
                        isCurrentUser: message['isCurrentUser'] ?? false,
                        onLongPress: () => _showMessageOptions(message),
                        onReact: () {
                          // Simulate adding reaction
                          setState(() {
                            final reactions =
                                message['reactions'] as List? ?? [];
                            final existingReaction = reactions.firstWhere(
                              (r) => r['emoji'] == '❤️',
                              orElse: () => null,
                            );

                            if (existingReaction != null) {
                              existingReaction['count'] =
                                  (existingReaction['count'] ?? 0) + 1;
                            } else {
                              reactions.add({'emoji': '❤️', 'count': 1});
                            }
                          });
                        },
                      );
                    },
                  ),
                ),
              ),

              // Chat input
              ChatInputWidget(
                onSendMessage: _sendMessage,
                onTyping: () {
                  // Handle typing indicator for current user
                },
              ),
            ],
          ),

          // Community guidelines overlay
          if (_showGuidelines)
            Container(
              color: Colors.black.withValues(alpha: 0.5),
              child: Center(
                child: CommunityGuidelinesWidget(
                  onClose: () => setState(() => _showGuidelines = false),
                ),
              ),
            ),
        ],
      ),
    );
  }

  int _getTotalActiveUsers() {
    return _channels.fold(
        0, (sum, channel) => sum + (channel['activeCount'] as int? ?? 0));
  }
}
