import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class WellnessResourceCardWidget extends StatefulWidget {
  final Map<String, dynamic> resource;
  final VoidCallback onTap;
  final VoidCallback onBookmark;

  const WellnessResourceCardWidget({
    Key? key,
    required this.resource,
    required this.onTap,
    required this.onBookmark,
  }) : super(key: key);

  @override
  State<WellnessResourceCardWidget> createState() =>
      _WellnessResourceCardWidgetState();
}

class _WellnessResourceCardWidgetState
    extends State<WellnessResourceCardWidget> {
  bool isBookmarked = false;

  @override
  void initState() {
    super.initState();
    isBookmarked = widget.resource['isBookmarked'] ?? false;
  }

  void _handleBookmark() {
    setState(() {
      isBookmarked = !isBookmarked;
    });
    widget.onBookmark();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onLongPress: () {
        _showQuickActions(context);
      },
      child: Container(
        width: 70.w,
        margin: EdgeInsets.only(right: 3.w),
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
            Stack(
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(16)),
                  child: CustomImageWidget(
                    imageUrl: widget.resource['image'],
                    width: double.infinity,
                    height: 12.h,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 2.w,
                  right: 2.w,
                  child: GestureDetector(
                    onTap: _handleBookmark,
                    child: Container(
                      padding: EdgeInsets.all(1.w),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: CustomIconWidget(
                        iconName: isBookmarked ? 'bookmark' : 'bookmark_border',
                        color: isBookmarked
                            ? AppTheme.primaryLight
                            : AppTheme.neutralLight,
                        size: 20,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 2.w,
                  left: 2.w,
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.w),
                    decoration: BoxDecoration(
                      color: _getTypeColor(widget.resource['type'])
                          .withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomIconWidget(
                          iconName: _getTypeIcon(widget.resource['type']),
                          color: Colors.white,
                          size: 14,
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          widget.resource['duration'],
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(3.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.resource['title'],
                    style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                      color: AppTheme.textHighEmphasisLight,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    widget.resource['description'],
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.textMediumEmphasisLight,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 1.h),
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'star',
                        color: AppTheme.warningLight,
                        size: 16,
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        widget.resource['rating'].toString(),
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.textMediumEmphasisLight,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 2.w),
                      CustomIconWidget(
                        iconName: 'people',
                        color: AppTheme.neutralLight,
                        size: 16,
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        '${widget.resource['participants']}+',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.textMediumEmphasisLight,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'meditation':
        return AppTheme.primaryLight;
      case 'video':
        return AppTheme.successLight;
      case 'audio':
        return AppTheme.secondaryLight;
      default:
        return AppTheme.neutralLight;
    }
  }

  String _getTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'meditation':
        return 'self_improvement';
      case 'video':
        return 'play_circle';
      case 'audio':
        return 'headphones';
      default:
        return 'article';
    }
  }

  void _showQuickActions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              margin: EdgeInsets.symmetric(vertical: 2.h),
              decoration: BoxDecoration(
                color: AppTheme.neutralLight.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: isBookmarked ? 'bookmark_remove' : 'bookmark_add',
                color: AppTheme.primaryLight,
                size: 24,
              ),
              title: Text(
                isBookmarked ? 'Remove Bookmark' : 'Add Bookmark',
                style: AppTheme.lightTheme.textTheme.bodyLarge,
              ),
              onTap: () {
                Navigator.pop(context);
                _handleBookmark();
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'share',
                color: AppTheme.primaryLight,
                size: 24,
              ),
              title: Text(
                'Share',
                style: AppTheme.lightTheme.textTheme.bodyLarge,
              ),
              onTap: () {
                Navigator.pop(context);
                // Handle share functionality
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'download',
                color: AppTheme.primaryLight,
                size: 24,
              ),
              title: Text(
                'Download for Offline',
                style: AppTheme.lightTheme.textTheme.bodyLarge,
              ),
              onTap: () {
                Navigator.pop(context);
                // Handle download functionality
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }
}
