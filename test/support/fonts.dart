import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> loadAppFonts() async {
  TestWidgetsFlutterBinding.ensureInitialized();

  final loader = FontLoader('Atkinson Hyperlegible');
  for (final path in const [
    'assets/fonts/AtkinsonHyperlegible-Regular.ttf',
    'assets/fonts/AtkinsonHyperlegible-Bold.ttf',
  ]) {
    final bytes = File(path).readAsBytesSync();
    loader.addFont(Future.value(ByteData.view(bytes.buffer)));
  }
  await loader.load();

  await _loadMaterialIconsFont();
}

Future<void> _loadMaterialIconsFont() async {
  final root = _resolveFlutterRoot();
  final fontFile = File(
    '$root/bin/cache/artifacts/material_fonts/MaterialIcons-Regular.otf',
  );

  if (!fontFile.existsSync()) {
    throw StateError(
      'Police MaterialIcons introuvable à "${fontFile.path}". '
      "Impossible de générer des goldens fiables pour les icônes "
      '(bouton d\'appel, étoile de section) sans elle. '
      'FLUTTER_ROOT résolu : "$root" '
      '(Platform.resolvedExecutable="${Platform.resolvedExecutable}", '
      'FLUTTER_ROOT env="${Platform.environment['FLUTTER_ROOT']}").',
    );
  }

  final loader = FontLoader('MaterialIcons');
  loader.addFont(
    Future.value(ByteData.view(fontFile.readAsBytesSync().buffer)),
  );
  await loader.load();
}

String _resolveFlutterRoot() {
  final envRoot = Platform.environment['FLUTTER_ROOT'];
  if (envRoot != null && envRoot.isNotEmpty) return envRoot;

  final segments = Platform.resolvedExecutable.split(Platform.pathSeparator);
  final binIndex = segments.lastIndexOf('bin');
  if (binIndex > 0) {
    return segments.sublist(0, binIndex).join(Platform.pathSeparator);
  }

  throw StateError(
    'Impossible de déduire FLUTTER_ROOT : ni la variable d\'environnement '
    'ni Platform.resolvedExecutable ("${Platform.resolvedExecutable}") ne '
    "permettent de le localiser.",
  );
}
