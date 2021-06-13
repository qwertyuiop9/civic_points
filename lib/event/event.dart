import 'dart:convert';

import 'package:civic_points/serverConnection/constants.dart';
import 'package:civic_points/serverConnection/webService.dart';

class Event {
  final String id;
  final String comune;
  final String titoloEvento;
  final String descrizione;
  final String data;
  final String urlToImage;
  final int civicPoints;
  final String statoEvento;
  final String categoria;
  final String indirizzo;

  Event(
      {this.id,
      this.comune,
      this.titoloEvento,
      this.descrizione,
      this.data,
      this.urlToImage,
      this.civicPoints,
      this.statoEvento,
      this.categoria,
      this.indirizzo});

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
        id: json['_id'],
        comune: json['comune'],
        titoloEvento: json['titoloEvento'],
        descrizione: json['descrizione'],
        data: json['data'],
        statoEvento: json['statoEvento'],
        categoria: json['categoria'],
        indirizzo: json['indirizzo'],
        urlToImage: json['image_url'] ?? 'https://via.placeholder.com/150',
        //Constants.NEWS_PLACEHOLDER_IMAGE_ASSET_URL,
        civicPoints: 20);
  }

  static Resource<List<Event>> get all {
    return Resource(
        url: Constants.HEADLINE_NEWS_URL,
        parse: (response) {
          final result = json.decode(response.body);
          Iterable list = result;
          return list.map((model) => Event.fromJson(model)).toList();
        });
  }

  static Resource<List<Event>> get eventsBySearch {
    return Resource(
        url: Constants.HEADLINE_NEWS_URL,
        parse: (response) {
          final result = json.decode(response.body);
          Iterable list = result;
          return list.map((model) => Event.fromJson(model)).toList();
        });
  }

  // Da rimpiazzare con chiamata all'oggetto Opzione di spesa
  static Resource<List<Event>> get all_projects {
    return Resource(
        url: Constants.HEADLINE_BUY_OPTIONS,
        parse: (response) {
          final result = json.decode(response.body);
          Iterable list = result;
          return list.map((model) => Event.fromJson(model)).toList();
        });
  }

  static Event getNullPlaceholderEvent() {
    return new Event(
        id: '-1',
        comune: '/',
        titoloEvento: 'Nessun evento trovato',
        descrizione: 'Suggerimento: provare a ricercare con termini diversi...',
        data: '/',
        urlToImage:
            'https://previews.123rf.com/images/vectorknight/vectorknight1807/vectorknight180700074/105231216-upset-magnifying-glass-cute-not-found-symbol-and-unsuccessful-search-zoom-for-404-icon-no-suitable-r.jpg',
        civicPoints: 0,
        statoEvento: "/",
        categoria: "/",
        indirizzo: "/");
  }
}
