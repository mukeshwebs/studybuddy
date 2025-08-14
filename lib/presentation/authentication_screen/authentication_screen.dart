import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/google_signin_button_widget.dart';
import './widgets/privacy_footer_widget.dart';
import './widgets/tagline_widget.dart';
import './widgets/welcome_illustration_widget.dart';

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({Key? key}) : super(key: key);

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen>
    with TickerProviderStateMixin {
  bool _isLoading = false;
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Mock authentication data
  final List<Map<String, dynamic>> mockUsers = [
    {
      "id": "user_001",
      "email": "student@gmail.com",
      "name": "Anonymous Student",
      "isNewUser": false,
      "lastLogin": DateTime.now().subtract(Duration(days: 2)),
    },
    {
      "id": "user_002",
      "email": "newstudent@gmail.com",
      "name": "New Student",
      "isNewUser": true,
      "lastLogin": null,
    }
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startEntryAnimation();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));
  }

  void _startEntryAnimation() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _fadeController.forward();
        _slideController.forward();
      }
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  Future<void> _handleGoogleSignIn() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate authentication process
      await Future.delayed(const Duration(milliseconds: 2000));

      // Mock authentication logic
      final authenticatedUser = mockUsers.first;
      final isNewUser = (authenticatedUser["isNewUser"] as bool?) ?? true;

      // Provide haptic feedback on success
      HapticFeedback.mediumImpact();

      if (mounted) {
        // Navigate based on user status
        if (isNewUser) {
          Navigator.pushReplacementNamed(context, '/onboarding-setup-screen');
        } else {
          Navigator.pushReplacementNamed(context, '/study-pool-screen');
        }
      }
    } catch (error) {
      if (mounted) {
        _showErrorDialog('Authentication failed. Please try again.');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              CustomIconWidget(
                iconName: 'error_outline',
                color: AppTheme.lightTheme.colorScheme.error,
                size: 6.w,
              ),
              SizedBox(width: 3.w),
              Text(
                'Authentication Error',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.error,
                ),
              ),
            ],
          ),
          content: Text(
            message,
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Try Again',
                style: TextStyle(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Container(
                width: 100.w,
                constraints: BoxConstraints(
                  minHeight: 90.h,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 5.h),

                    // App branding
                    _buildAppBranding(),

                    SizedBox(height: 4.h),

                    // Welcome illustration
                    const WelcomeIllustrationWidget(),

                    SizedBox(height: 4.h),

                    // Tagline
                    const TaglineWidget(),

                    SizedBox(height: 5.h),

                    // Google Sign-in button
                    GoogleSigninButtonWidget(
                      onPressed: _handleGoogleSignIn,
                      isLoading: _isLoading,
                    ),

                    SizedBox(height: 3.h),

                    // Alternative sign-in options for iOS
                    if (Theme.of(context).platform == TargetPlatform.iOS)
                      _buildAppleSignInButton(),

                    SizedBox(height: 4.h),

                    // Privacy footer
                    const PrivacyFooterWidget(),

                    SizedBox(height: 3.h),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppBranding() {
    return Column(
      children: [
        Container(
          width: 20.w,
          height: 20.w,
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
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Center(
            child: CustomIconWidget(
              iconName: 'school',
              color: Colors.white,
              size: 10.w,
            ),
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          'StudyBuddy',
          style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.primary,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }

  Widget _buildAppleSignInButton() {
    return Container(
      width: 85.w,
      height: 7.h,
      child: OutlinedButton(
        onPressed: _isLoading
            ? null
            : () {
                HapticFeedback.lightImpact();
                _handleGoogleSignIn(); // Using same mock logic for Apple Sign-In
              },
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          side: BorderSide.none,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'apple',
              color: Colors.white,
              size: 6.w,
            ),
            SizedBox(width: 4.w),
            Text(
              'Continue with Apple',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
