import 'package:flutter/material.dart';

class LetterAnchorRegistry {
  final _anchors = <_LetterAnchorState>{};

  void _register(_LetterAnchorState anchor) => _anchors.add(anchor);

  void _unregister(_LetterAnchorState anchor) => _anchors.remove(anchor);

  String? topmostLetter(RenderBox viewport, {required double readingZone}) {
    String? letter;
    var smallestTop = double.infinity;

    for (final anchor in _anchors) {
      final box = anchor.context.findRenderObject() as RenderBox?;
      if (box == null || !box.hasSize || !box.attached) continue;

      final top = box.localToGlobal(Offset.zero, ancestor: viewport).dy;
      final bottom = top + box.size.height;
      if (bottom <= 0 || top >= readingZone) continue;

      if (top < smallestTop) {
        smallestTop = top;
        letter = anchor.widget.letter;
      }
    }
    return letter;
  }
}

class LetterAnchor extends StatefulWidget {
  const LetterAnchor({
    required this.registry,
    required this.letter,
    required this.child,
    super.key,
  });

  final LetterAnchorRegistry registry;
  final String? letter;
  final Widget child;

  @override
  State<LetterAnchor> createState() => _LetterAnchorState();
}

class _LetterAnchorState extends State<LetterAnchor> {
  @override
  void initState() {
    super.initState();
    widget.registry._register(this);
  }

  @override
  void dispose() {
    widget.registry._unregister(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

class LetterScrollAnnouncer extends StatefulWidget {
  const LetterScrollAnnouncer({
    required this.registry,
    required this.onLetterReached,
    required this.child,
    super.key,
  });

  final LetterAnchorRegistry registry;
  final void Function(String letter) onLetterReached;
  final Widget child;

  @override
  State<LetterScrollAnnouncer> createState() => LetterScrollAnnouncerState();
}

class LetterScrollAnnouncerState extends State<LetterScrollAnnouncer> {
  static const _readingZoneFraction = 0.4;

  final _viewportKey = GlobalKey();

  String? _announced;

  void forget() => _announced = null;

  bool _onNotification(ScrollNotification notification) {
    if (notification is! ScrollUpdateNotification) return false;
    if (notification.depth > 0) return false;

    final viewport =
        _viewportKey.currentContext?.findRenderObject() as RenderBox?;
    if (viewport == null || !viewport.hasSize) return false;

    final letter = widget.registry.topmostLetter(
      viewport,
      readingZone: viewport.size.height * _readingZoneFraction,
    );
    if (letter == null || letter == _announced) return false;

    _announced = letter;
    widget.onLetterReached(letter);
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: _onNotification,
      child: SizedBox(key: _viewportKey, child: widget.child),
    );
  }
}
