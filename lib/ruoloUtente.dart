import 'dart:convert';

import 'package:civic_points/constants.dart';
import 'package:civic_points/webService.dart';

class RuoloUtente {
  final String ruolo;

  RuoloUtente(
      {
      this.ruolo});

  factory RuoloUtente.fromJson(Map<String, dynamic> json) {
    return RuoloUtente(
        ruolo: json['ruolo'],
        );
  }

}
