import 'dart:convert';

import 'package:civic_points/constants.dart';
import 'package:civic_points/webService.dart';

class Comune {
  final String nome;
  final List<String> categorieDisponibili;

  Comune(
      {
      this.nome,
      this.categorieDisponibili});

  factory Comune.fromJson(Map<String, dynamic> json) {
    return Comune(
        nome: json['nomeComune'],
        categorieDisponibili: json['categorieDisponibili'],
        );
  }

  static Resource<List<Comune>> get all {
    return Resource(
        url: Constants.HEADLINE_NEWS_URL,
        parse: (response) {
          final result = json.decode(response.body);
          Iterable list = result;
          return list.map((model) => Comune.fromJson(model)).toList();
        });
  }

}
