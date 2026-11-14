const _units = [
  'zéro',
  'une',
  'deux',
  'trois',
  'quatre',
  'cinq',
  'six',
  'sept',
  'huit',
  'neuf',
  'dix',
  'onze',
  'douze',
  'treize',
  'quatorze',
  'quinze',
  'seize',
  'dix-sept',
  'dix-huit',
  'dix-neuf',
];

const _tens = {2: 'vingt', 3: 'trente', 4: 'quarante', 5: 'cinquante'};

// Écrit en toutes lettres et au féminin (« une heure », « vingt et une ») :
// les moteurs de synthèse lisent « 1 heure » ou « 21 heures » de façon
// inégale, alors que le texte en lettres est toujours prononcé correctement.
String _number(int n) {
  if (n < 20) return _units[n];

  final ten = _tens[n ~/ 10]!;
  return switch (n % 10) {
    0 => ten,
    1 => '$ten et une',
    final unit => '$ten-${_units[unit]}',
  };
}

String spokenTime(DateTime time) {
  final hour = switch (time.hour) {
    0 => 'minuit',
    12 => 'midi',
    1 => 'une heure',
    final h => '${_number(h)} heures',
  };

  final minute = time.minute == 0 ? '' : ' ${_number(time.minute)}';
  return 'Il est $hour$minute';
}
