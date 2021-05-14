import 'dart:convert';

import 'package:civic_points/constants.dart';
import 'package:civic_points/webService.dart';

class Comune {
  final String nome;

  Comune(
      {
      this.nome});

  factory Comune.fromJson(Map<String, dynamic> json) {
    return Comune(
        nome: json['comune'],
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
