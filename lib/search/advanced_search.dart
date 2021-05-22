import 'dart:convert';
import 'dart:io';

import 'package:civic_points/search/search.dart';
import 'package:civic_points/search/search_result_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../signIn.dart';

class AdvancedSearch extends StatefulWidget {
  final SearchParams searchParams;

  const AdvancedSearch({Key key, this.searchParams}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AdvancedSearchState(searchParams);
}

class _AdvancedSearchState extends State<AdvancedSearch> {
  final titleController = TextEditingController();
  final SearchParams searchParams;
  String start_date = '';
  String end_date = '';
  List<String> _categories = [];
  // Creare una lista di booleani pari al numero di categorie disponibili alla scelta
  List<bool> _is_category_active = [];

  // Costruttore base

  final Dio _dio;

  _AdvancedSearchState(this.searchParams)
      : _dio = Dio(BaseOptions(
          baseUrl: 'https://ingsw2020server.herokuapp.com',
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token'
          },
        ));

  void getUserCategories(SearchParams params) async {
    var album = await fetchAlbum();
    print(album.categorie);
    setState(() {
      this._categories = album.categorie;
    });
  }

  @override
  void initState() {
    super.initState();
    this._categories = _getUserCategories();
    // Creo una lista lunga quanto il numero di categorie disponibili e la riempio di valori falsi al fine di rappresentare la selezione delle checkbox
    this._is_category_active = List.filled(this._categories.length, false);
    getUserCategories(searchParams);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ricerca avanzata"),
      ),
      body: Center(
        child: Container(
          width: double.infinity,
          color: Colors.white,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 16, 16, 0),
                child: Text(
                  'Titolo evento',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  textInputAction: TextInputAction.go,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Titolo: ',
                  ),
                  style: TextStyle(color: Colors.black, fontSize: 16.0),
                  controller: this.titleController,
                  onSubmitted: (String text) {
                    searchParams.title_keyword = text;
                  },
                  cursorColor: Colors.blue,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Ricerca per data',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 0, 16, 0),
                child: Row(
                  children: [
                    ElevatedButton(
                        child: Text('Inserisci data iniziale'),
                        onPressed: () {
                          showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2001),
                            lastDate: DateTime(2022),
                          ).then((pickedDate) {
                            print(pickedDate);
                            this.searchParams.start_date = pickedDate;
                            setState(() {
                              this.start_date =
                                  '${pickedDate.day.toString()}/${pickedDate.month.toString()}/${pickedDate.year.toString()}';
                              this.searchParams.start_date = pickedDate;
                            });
                          });
                        }),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text('$start_date'),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 0, 16, 16),
                child: Row(
                  children: [
                    ElevatedButton(
                        child: Text('Inserisci data finale'),
                        onPressed: () {
                          showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2001),
                            lastDate: DateTime(2022),
                          ).then((pickedDate) {
                            print(pickedDate);
                            this.searchParams.end_date = pickedDate;
                            setState(() {
                              this.end_date =
                                  '${pickedDate.day.toString()}/${pickedDate.month.toString()}/${pickedDate.year.toString()}';
                              this.searchParams.end_date = pickedDate;
                            });
                          });
                        }),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text('$end_date'),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Seleziona categorie',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: Container(
                    color: Color(0xfffbfaff),
                    child: ListView.builder(
                      itemCount: _categories.length,
                      itemBuilder: _buildCategoryItemForListView,
                    )),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                child: ElevatedButton(
                  onPressed: () {
                    this.searchParams.categories =
                        getSelectedCategories(_categories, _is_category_active);
                    print(_categories);
                    print(_is_category_active);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ResultsList(
                                params: searchParams,
                              )),
                    );
                  },
                  child: Text(
                    'Avvia ricerca',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryItemForListView(BuildContext context, int index) {
    final String category = _categories[index];
    return CheckboxListTile(
      title: Text(category),
      value: _is_category_active[index],
      onChanged: (bool newValue) {
        setState(() {
          _is_category_active[index] = newValue;
          print(newValue);
        });
      },
    );
  }

  // Chiamata http che restituisce una lista di categorie relative all'utente in base al suo profilo
  List<String> _getUserCategories() {
    /** Aggiungere l'implementazione**/

    return [
      'Caricando categoria...',
      'Caricando categoria...',
      'Caricando categoria...',
      'Caricando categoria...'
    ];
  }

  List<String> getSelectedCategories(
      List<String> categories, List<bool> is_category_active) {
    List<String> selected = [];
    for (var i = 0; i < categories.length; i++) {
      if (is_category_active[i]) {
        selected.add(categories[i]);
      }
    }
    if (selected.length == 0) {
      return _getUserCategories();
    } else {
      return selected;
    }
  }
}

Future<Album> fetchAlbum() async {
  final response = await http.get(
    Uri.parse(
        'https://ingsw2020server.herokuapp.com/users/me/categorieDisponibili'),
    // Send authorization headers to the backend.
    headers: {
      HttpHeaders.authorizationHeader: 'Bearer $token',
    },
  );
  final responseJson = jsonDecode(response.body);

  return Album.fromJson(responseJson);
}

class Album {
  final List<String> categorie;

  Album({
    this.categorie,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      categorie: json['categorieDiInteresse'].cast<String>(),
    );
  }
}
