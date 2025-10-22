import 'package:flutter/material.dart';
import '../../../models/theme.dart';

class GradientBackground extends StatelessWidget {
  final Widget child;
  final bool isDark;

  const GradientBackground({
    super.key,
    required this.child,
    this.isDark = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: isDark ? AppTheme.darkGradient : AppTheme.cyanWhiteGradient,
      ),
      child: child,
    );
  }
}
