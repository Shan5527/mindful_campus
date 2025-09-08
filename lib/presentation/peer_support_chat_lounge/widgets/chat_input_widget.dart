import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ChatInputWidget extends StatefulWidget {
  final Function(String) onSendMessage;
  final VoidCallback? onTyping;

  const ChatInputWidget({
    Key? key,
    required this.onSendMessage,
    this.onTyping,
  }) : super(key: key);

  @override
  State<ChatInputWidget> createState() => _ChatInputWidgetState();
}

class _ChatInputWidgetState extends State<ChatInputWidget> {
  final TextEditingController _messageController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _showEmojiPicker = false;
  bool _isTyping = false;
  static const int _maxCharacters = 500;

  @override
  void initState() {
    super.initState();
    _messageController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _messageController.removeListener(_onTextChanged);
    _messageController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    final isCurrentlyTyping = _messageController.text.isNotEmpty;
    if (isCurrentlyTyping != _isTyping) {
      setState(() {
        _isTyping = isCurrentlyTyping;
      });
      if (isCurrentlyTyping && widget.onTyping != null) {
        widget.onTyping!();
      }
    }
  }

  void _sendMessage() {
    final message = _messageController.text.trim();
    if (message.isNotEmpty && message.length <= _maxCharacters) {
      widget.onSendMessage(message);
      _messageController.clear();
      setState(() {
        _isTyping = false;
        _showEmojiPicker = false;
      });
      _focusNode.requestFocus();
    }
  }

  void _toggleEmojiPicker() {
    setState(() {
      _showEmojiPicker = !_showEmojiPicker;
    });
    if (_showEmojiPicker) {
      _focusNode.unfocus();
    } else {
      _focusNode.requestFocus();
    }
  }

  void _onEmojiSelected(Emoji emoji) {
    final currentText = _messageController.text;
    final selection = _messageController.selection;
    final newText = currentText.replaceRange(
      selection.start,
      selection.end,
      emoji.emoji,
    );

    if (newText.length <= _maxCharacters) {
      _messageController.text = newText;
      _messageController.selection = TextSelection.collapsed(
        offset: selection.start + emoji.emoji.length,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            border: Border(
              top: BorderSide(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.2),
                width: 1,
              ),
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                if (_messageController.text.length > _maxCharacters * 0.8)
                  Padding(
                    padding: EdgeInsets.only(bottom: 1.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '${_messageController.text.length}/$_maxCharacters',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color:
                                _messageController.text.length > _maxCharacters
                                    ? AppTheme.lightTheme.colorScheme.error
                                    : AppTheme.lightTheme.colorScheme
                                        .onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(6.w),
                          border: Border.all(
                            color: AppTheme.lightTheme.colorScheme.outline
                                .withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: _toggleEmojiPicker,
                              icon: CustomIconWidget(
                                iconName: _showEmojiPicker
                                    ? 'keyboard'
                                    : 'emoji_emotions',
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                                size: 5.w,
                              ),
                            ),
                            Expanded(
                              child: TextField(
                                controller: _messageController,
                                focusNode: _focusNode,
                                maxLines: null,
                                maxLength: _maxCharacters,
                                decoration: InputDecoration(
                                  hintText:
                                      'Share your thoughts anonymously...',
                                  hintStyle: AppTheme
                                      .lightTheme.textTheme.bodyMedium
                                      ?.copyWith(
                                    color: AppTheme
                                        .lightTheme.colorScheme.onSurfaceVariant
                                        .withValues(alpha: 0.6),
                                  ),
                                  border: InputBorder.none,
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 2.h),
                                  counterText: '',
                                ),
                                style: AppTheme.lightTheme.textTheme.bodyMedium,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                onSubmitted: (_) => _sendMessage(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Container(
                      decoration: BoxDecoration(
                        color: _isTyping &&
                                _messageController.text.trim().isNotEmpty &&
                                _messageController.text.length <= _maxCharacters
                            ? AppTheme.lightTheme.colorScheme.primary
                            : AppTheme.lightTheme.colorScheme.onSurfaceVariant
                                .withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(6.w),
                      ),
                      child: IconButton(
                        onPressed: _isTyping &&
                                _messageController.text.trim().isNotEmpty &&
                                _messageController.text.length <= _maxCharacters
                            ? _sendMessage
                            : null,
                        icon: CustomIconWidget(
                          iconName: 'send',
                          color: _isTyping &&
                                  _messageController.text.trim().isNotEmpty &&
                                  _messageController.text.length <=
                                      _maxCharacters
                              ? Colors.white
                              : AppTheme.lightTheme.colorScheme.onSurfaceVariant
                                  .withValues(alpha: 0.5),
                          size: 5.w,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        if (_showEmojiPicker)
          SizedBox(
            height: 35.h,
            child: EmojiPicker(
              onEmojiSelected: (category, emoji) => _onEmojiSelected(emoji),
              config: Config(
                height: 35.h,
                checkPlatformCompatibility: true,
                emojiViewConfig: EmojiViewConfig(
                  backgroundColor: AppTheme.lightTheme.colorScheme.surface,
                  columns: 7,
                  emojiSizeMax: 28,
                ),
                skinToneConfig: const SkinToneConfig(),
                categoryViewConfig: CategoryViewConfig(
                  backgroundColor: AppTheme.lightTheme.colorScheme.surface,
                  iconColor: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  iconColorSelected: AppTheme.lightTheme.colorScheme.primary,
                ),
                bottomActionBarConfig: BottomActionBarConfig(
                  backgroundColor: AppTheme.lightTheme.colorScheme.surface,
                  buttonColor: AppTheme.lightTheme.colorScheme.surface,
                  buttonIconColor:
                      AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
                searchViewConfig: SearchViewConfig(
                  backgroundColor: AppTheme.lightTheme.colorScheme.surface,
                  buttonIconColor:
                      AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
