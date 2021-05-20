import 'dart:convert';
import 'package:civic_points/constants.dart';
import 'package:civic_points/webService.dart';

class ProfiloUtente {
  String ruolo;
  List<Comune> comuniDiInteresse;
  String sId;
  String uid;
  Comune comuneDiResidenza;
  int iV;

  ProfiloUtente(
      {this.ruolo,
        this.comuniDiInteresse,
        this.sId,
        this.uid,
        this.comuneDiResidenza,
        this.iV});

  ProfiloUtente.fromJson(Map<String, dynamic> json) {
    ruolo = json['ruolo'];
    if (json['comuniDiInteresse'] != null) {
      comuniDiInteresse = new List<Comune>();
      json['comuniDiInteresse'].forEach((v) {
        comuniDiInteresse.add(new Comune.fromJson(v));
      });
    }
    sId = json['_id'];
    uid = json['uid'];
    comuneDiResidenza = json['comuneDiResidenza'] != null
        ? new Comune.fromJson(json['comuneDiResidenza'])
        : null;
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ruolo'] = this.ruolo;
    if (this.comuniDiInteresse != null) {
      data['comuniDiInteresse'] =
          this.comuniDiInteresse.map((v) => v.toJson()).toList();
    }
    data['_id'] = this.sId;
    data['uid'] = this.uid;
    if (this.comuneDiResidenza != null) {
      data['comuneDiResidenza'] = this.comuneDiResidenza.toJson();
    }
    data['__v'] = this.iV;
    return data;
  }

  static Resource<ProfiloUtente> get profilo {
    return Resource(
        url: Constants.HEADLINE_GET_PROFILO,
        parse: (response) {
          ProfiloUtente profilo = ProfiloUtente.fromJson(jsonDecode(response.body));
          print(jsonDecode(response.body));
          return profilo;
        });
  }
}

class Comune{
  bool enabled;
  List<String> categorieDisponibili;
  String sId;
  String nomeComune;
  int iV;

  Comune(
      {this.enabled,
        this.categorieDisponibili,
        this.sId,
        this.nomeComune,
        this.iV});

  Comune.fromJson(Map<String, dynamic> json) {
    enabled = json['enabled'];
    categorieDisponibili = json['categorieDisponibili'].cast<String>();
    sId = json['_id'];
    nomeComune = json['nomeComune'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['enabled'] = this.enabled;
    data['categorieDisponibili'] = this.categorieDisponibili;
    data['_id'] = this.sId;
    data['nomeComune'] = this.nomeComune;
    data['__v'] = this.iV;
    return data;
  }

}
