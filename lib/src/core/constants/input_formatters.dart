import 'package:flutter/services.dart';

final digitsInputFormatter = <TextInputFormatter>[
  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
];
