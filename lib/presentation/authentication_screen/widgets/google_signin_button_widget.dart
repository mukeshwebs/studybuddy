import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class GoogleSigninButtonWidget extends StatefulWidget {
  final VoidCallback onPressed;
  final bool isLoading;

  const GoogleSigninButtonWidget({
    Key? key,
    required this.onPressed,
    this.isLoading = false,
  }) : super(key: key);

  @override
  State<GoogleSigninButtonWidget> createState() =>
      _GoogleSigninButtonWidgetState();
}

class _GoogleSigninButtonWidgetState extends State<GoogleSigninButtonWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _animationController.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    _animationController.reverse();
  }

  void _handleTapCancel() {
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: widget.isLoading ? null : _handleTapDown,
      onTapUp: widget.isLoading ? null : _handleTapUp,
      onTapCancel: widget.isLoading ? null : _handleTapCancel,
      onTap: widget.isLoading
          ? null
          : () {
              HapticFeedback.lightImpact();
              widget.onPressed();
            },
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: 85.w,
              height: 7.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.3),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.shadowColor,
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child:
                  widget.isLoading ? _buildLoadingState() : _buildNormalState(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNormalState() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomImageWidget(
          imageUrl: "https://developers.google.com/identity/images/g-logo.png",
          width: 6.w,
          height: 6.w,
          fit: BoxFit.contain,
        ),
        SizedBox(width: 4.w),
        Text(
          'Continue with Google',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurface,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 5.w,
          height: 5.w,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(
              AppTheme.lightTheme.colorScheme.primary,
            ),
          ),
        ),
        SizedBox(width: 4.w),
        Text(
          'Signing in...',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurface
                .withValues(alpha: 0.7),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
