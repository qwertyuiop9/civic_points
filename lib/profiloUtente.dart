import 'dart:convert';
import 'package:civic_points/ruoloUtente.dart';
import 'package:civic_points/constants.dart';
import 'package:civic_points/webService.dart';
import 'package:civic_points/comune.dart';

class ProfiloUtente {
  final String userId;
  final String email;
  final RuoloUtente ruolo;
  final Comune comuneDiResidenza;
  final List<Comune> comuniDiInteresse;

  ProfiloUtente(
      {
      this.userId,
      this.email,
      this.ruolo,
      this.comuneDiResidenza,
      this.comuniDiInteresse,});

  factory ProfiloUtente.fromJson(Map<String, dynamic> json) {
    return ProfiloUtente(
        userId: json['user_id'],
        email: json['email'],
        ruolo: json['ruolo'],
        comuneDiResidenza: json['comuneDiResidenza'],
        comuniDiInteresse: json['comuneDiInteresse'],
        );
  }

  static Resource<ProfiloUtente> get profilo {
    return Resource(
        url: Constants.HEADLINE_NEWS_URL,
        parse: (response) {
          final result = json.decode(response.body);
          return result;
        });
  }

}
