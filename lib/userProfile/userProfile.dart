import 'dart:convert';
import 'package:civic_points/serverConnection/constants.dart';
import 'package:civic_points/serverConnection/webService.dart';

/// Class to handle user profile JSON object received from server.
class ProfiloUtente {
  /// Role of the user.
  String ruolo;
  /// List of city of interest.
  List<Comune> comuniDiInteresse;
  String sId;
  String uid;
  /// Home city of the user.
  Comune comuneDiResidenza;
  /// Version of the user profile.
  int iV;
  /// User address, added only if the user has asked the mayor role.
  String indirizzo;
  /// User surname, added only if the user has asked the mayor role.
  String cognomeSindaco;
  /// City administrated by the mayor, added only if the user has asked the mayor role.
  Comune comuneAmministrato;
  /// User name, added only if the user has asked the mayor role.
  String nomeSindaco;

  ProfiloUtente(
      {this.ruolo,
        this.comuniDiInteresse,
        this.sId,
        this.uid,
        this.comuneDiResidenza,
        this.iV,
        this.indirizzo,
        this.cognomeSindaco,
        this.comuneAmministrato,
        this.nomeSindaco
      });

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
    indirizzo = json['indirizzo'];
    cognomeSindaco = json['cognomeSindaco'];
    comuneAmministrato = json['comuneAmministrato'] != null
        ? new Comune.fromJson(json['comuneAmministrato'])
        : null;
    nomeSindaco = json['nomeSindaco'];
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
    data['indirizzo'] = this.indirizzo;
    data['cognomeSindaco'] = this.cognomeSindaco;
    if (this.comuneAmministrato != null) {
      data['comuneAmministrato'] = this.comuneAmministrato.toJson();
    }
    data['nomeSindaco'] = this.nomeSindaco;
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

/// Class to handle the object city received from the server.
class Comune{
  bool enabled;
  /// List of event categories available for the related city.
  List<String> categorieDisponibili;
  String sId;
  /// Name of the city.
  String nomeComune;
  /// Version of the object Comune.
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
