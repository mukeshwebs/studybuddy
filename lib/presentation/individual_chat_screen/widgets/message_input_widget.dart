import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MessageInputWidget extends StatefulWidget {
  final Function(String) onSendMessage;
  final Function(XFile) onSendImage;
  final VoidCallback onTypingStart;
  final VoidCallback onTypingStop;

  const MessageInputWidget({
    super.key,
    required this.onSendMessage,
    required this.onSendImage,
    required this.onTypingStart,
    required this.onTypingStop,
  });

  @override
  State<MessageInputWidget> createState() => _MessageInputWidgetState();
}

class _MessageInputWidgetState extends State<MessageInputWidget> {
  final TextEditingController _messageController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();
  bool _isTyping = false;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _messageController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _messageController.removeListener(_onTextChanged);
    _messageController.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    final isCurrentlyTyping = _messageController.text.trim().isNotEmpty;
    if (isCurrentlyTyping != _isTyping) {
      setState(() {
        _isTyping = isCurrentlyTyping;
      });
      if (_isTyping) {
        widget.onTypingStart();
      } else {
        widget.onTypingStop();
      }
    }
  }

  void _sendMessage() {
    final message = _messageController.text.trim();
    if (message.isNotEmpty) {
      widget.onSendMessage(message);
      _messageController.clear();
      widget.onTypingStop();
    }
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        final fileSize = await image.length();
        if (fileSize > 2 * 1024 * 1024) {
          // 2MB limit
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Image size must be less than 2MB'),
                backgroundColor: AppTheme.lightTheme.colorScheme.error,
              ),
            );
          }
          return;
        }

        setState(() {
          _isUploading = true;
        });

        widget.onSendImage(image);

        // Simulate upload completion
        await Future.delayed(const Duration(seconds: 2));

        if (mounted) {
          setState(() {
            _isUploading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isUploading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to pick image'),
            backgroundColor: AppTheme.lightTheme.colorScheme.error,
          ),
        );
      }
    }
  }

  Future<void> _takePhoto() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        final fileSize = await image.length();
        if (fileSize > 2 * 1024 * 1024) {
          // 2MB limit
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Image size must be less than 2MB'),
                backgroundColor: AppTheme.lightTheme.colorScheme.error,
              ),
            );
          }
          return;
        }

        setState(() {
          _isUploading = true;
        });

        widget.onSendImage(image);

        // Simulate upload completion
        await Future.delayed(const Duration(seconds: 2));

        if (mounted) {
          setState(() {
            _isUploading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isUploading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to take photo'),
            backgroundColor: AppTheme.lightTheme.colorScheme.error,
          ),
        );
      }
    }
  }

  void _showImageOptions() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(4.w)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 10.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(1.w),
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              'Select Image',
              style: AppTheme.lightTheme.textTheme.titleMedium,
            ),
            SizedBox(height: 3.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    _takePhoto();
                  },
                  child: Column(
                    children: [
                      Container(
                        width: 15.w,
                        height: 15.w,
                        decoration: BoxDecoration(
                          color:
                              AppTheme.lightTheme.colorScheme.primaryContainer,
                          shape: BoxShape.circle,
                        ),
                        child: CustomIconWidget(
                          iconName: 'camera_alt',
                          size: 6.w,
                          color: AppTheme.lightTheme.colorScheme.primary,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        'Camera',
                        style: AppTheme.lightTheme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage();
                  },
                  child: Column(
                    children: [
                      Container(
                        width: 15.w,
                        height: 15.w,
                        decoration: BoxDecoration(
                          color:
                              AppTheme.lightTheme.colorScheme.primaryContainer,
                          shape: BoxShape.circle,
                        ),
                        child: CustomIconWidget(
                          iconName: 'photo_library',
                          size: 6.w,
                          color: AppTheme.lightTheme.colorScheme.primary,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        'Gallery',
                        style: AppTheme.lightTheme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 3.h),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        border: Border(
          top: BorderSide(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            if (_isUploading) ...[
              Container(
                padding: EdgeInsets.symmetric(vertical: 1.h),
                child: Row(
                  children: [
                    SizedBox(
                      width: 4.w,
                      height: 4.w,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppTheme.lightTheme.colorScheme.primary,
                        ),
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Text(
                      'Uploading image...',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurface
                            .withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            Row(
              children: [
                GestureDetector(
                  onTap: _showImageOptions,
                  child: Container(
                    width: 10.w,
                    height: 10.w,
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.primaryContainer,
                      shape: BoxShape.circle,
                    ),
                    child: CustomIconWidget(
                      iconName: 'camera_alt',
                      size: 5.w,
                      color: AppTheme.lightTheme.colorScheme.primary,
                    ),
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Container(
                    constraints: BoxConstraints(maxHeight: 20.h),
                    child: TextField(
                      controller: _messageController,
                      maxLines: null,
                      textInputAction: TextInputAction.newline,
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6.w),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: AppTheme.lightTheme.colorScheme.surface,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 4.w,
                          vertical: 1.5.h,
                        ),
                        suffixIcon: _messageController.text.trim().isNotEmpty
                            ? GestureDetector(
                                onTap: _sendMessage,
                                child: Container(
                                  margin: EdgeInsets.all(1.w),
                                  decoration: BoxDecoration(
                                    color:
                                        AppTheme.lightTheme.colorScheme.primary,
                                    shape: BoxShape.circle,
                                  ),
                                  child: CustomIconWidget(
                                    iconName: 'send',
                                    size: 4.w,
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            : null,
                      ),
                      style: AppTheme.lightTheme.textTheme.bodyMedium,
                    ),
                  ),
                ),
                if (_messageController.text.trim().isEmpty) ...[
                  SizedBox(width: 3.w),
                  GestureDetector(
                    onTap: _sendMessage,
                    child: Container(
                      width: 10.w,
                      height: 10.w,
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                      child: CustomIconWidget(
                        iconName: 'send',
                        size: 5.w,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
