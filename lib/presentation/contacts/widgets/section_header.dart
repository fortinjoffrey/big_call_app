import 'dart:async';

import 'package:big_call_app/core/theme/app_palettes.dart';
import 'package:big_call_app/core/theme/text_sizes.dart';
import 'package:big_call_app/domain/entities/app_settings.dart';
import 'package:flutter/material.dart';

const kSecretTapCount = 5;
const kSecretTapWindow = Duration(seconds: 2);

class SectionHeader extends StatefulWidget {
  const SectionHeader({
    required this.title,
    required this.palette,
    this.icon,
    this.iconColor,
    this.onSecretTaps,
    super.key,
  });

  final String title;
  final AppPalette palette;

  final IconData? icon;

  final Color? iconColor;

  final VoidCallback? onSecretTaps;

  @override
  State<SectionHeader> createState() => _SectionHeaderState();
}

class _SectionHeaderState extends State<SectionHeader> {
  int _taps = 0;
  Timer? _resetTimer;

  @override
  void dispose() {
    _resetTimer?.cancel();
    super.dispose();
  }

  void _onTap() {
    _resetTimer?.cancel();
    _taps++;

    if (_taps >= kSecretTapCount) {
      _taps = 0;
      widget.onSecretTaps?.call();
      return;
    }

    _resetTimer = Timer(kSecretTapWindow, () => _taps = 0);
  }

  @override
  Widget build(BuildContext context) {
    final colors = paletteColors[widget.palette]!;

    return GestureDetector(
      onTap: widget.onSecretTaps == null ? null : _onTap,
      child: Container(
        width: double.infinity,
        color: colors.header,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 22),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (widget.icon != null) ...[
              Icon(
                widget.icon,
                size: kHeaderBaseSize * 1.4,
                color: widget.iconColor ?? colors.onHeader,
              ),
              const SizedBox(width: 8),
            ],
            Flexible(
              child: Text(
                widget.title.toUpperCase(),
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
