import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:stiv/core/theme/theme_data.dart';

/// Sección de bienvenida con animación de entrada
class WelcomeSection extends StatefulWidget {
  final String firstName;

  const WelcomeSection({
    super.key,
    required this.firstName,
  });

  @override
  State<WelcomeSection> createState() => _WelcomeSectionState();
}

class _WelcomeSectionState extends State<WelcomeSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AppDurations.normal,
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildWelcomeText(),
              const SizedBox(height: AppSpacing.sm),
              _buildSubtitle(),
              const SizedBox(height: AppSpacing.lg),
        
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeText() {
    return DefaultTextStyle(
      style: const TextStyle(
        fontSize: 32,
        fontFamily: 'Rubik',
        fontWeight: FontWeight.w700,
        height: 1.2,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        Text(
          'Mantén siempre\ntus dispositivos',
          style: const TextStyle(
            color: AppColors.textPrimary,
          ),
        ),
          AnimatedTextKit(
            animatedTexts: [
              TypewriterAnimatedText(
                'Operativos con Stiv',
                cursor: '_'  ,


                textStyle: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 36,

                ),
                speed: const Duration(milliseconds: 100),
              ),
            ],isRepeatingAnimation: true,
            displayFullTextOnTap: true,
            pause: const Duration(seconds: 2),

           


          ),
        ],
      ),
    );
  }

  Widget _buildSubtitle() {
    return const SizedBox.shrink();
  }

}

