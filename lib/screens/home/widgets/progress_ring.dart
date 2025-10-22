import 'package:flutter/material.dart';

class ProgressRing extends StatelessWidget {
  const ProgressRing(this.progress, this.color, {super.key});
  final double progress;
  final Color color;
  @override
  Widget build(BuildContext context) {
    final p = progress.clamp(0.0, 1.0);
    return SizedBox(
      width: 40,
      height: 40,
      child: Stack(children: [
        CircularProgressIndicator(
          value: p,
          strokeWidth: 4,
          valueColor: AlwaysStoppedAnimation<Color>(color),
          backgroundColor: color.withOpacity(0.2),
        ),
        Center(
          child: Text('${(p * 100).toInt()}%',
              style: TextStyle(
                  color: color, fontSize: 10, fontWeight: FontWeight.bold)),
        ),
      ]),
    );
  }
}

// buildProgressRing
