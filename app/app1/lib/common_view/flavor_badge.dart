import 'package:flutter/material.dart';
import 'package:shared/shared.dart';

/// Small chip showing which environment the build targets (DEV/PREPROD/PROD).
class FlavorBadge extends StatelessWidget {
  const FlavorBadge({super.key});

  @override
  Widget build(BuildContext context) {
    final flavor = EnvConstants.flavor;
    final color = switch (flavor) {
      Flavor.dev => Colors.green,
      Flavor.preprod => Colors.orange,
      Flavor.prod => Colors.red,
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Text(
        flavor.label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
