import 'package:big_call_app/core/theme/app_palettes.dart';
import 'package:flutter/material.dart';

class CardShell extends StatelessWidget {
  const CardShell({required this.colors, required this.child, super.key});

  final PaletteColors colors;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.background,
        border: Border.all(color: colors.border, width: 3),
        borderRadius: BorderRadius.circular(14),
      ),
      child: child,
    );
  }
}
