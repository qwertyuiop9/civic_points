import 'package:civic_points/event/event.dart';
import 'package:civic_points/event/eventDetailsPage.dart';
import 'package:civic_points/search/search.dart';
import 'package:civic_points/signIn/signIn.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ResultsListState extends State<ResultsList> {
  List<Event> _resultedEvents = [];
  final SearchParams params;

  final Dio _dio;

  ResultsListState(this.params)
      : _dio = Dio(BaseOptions(
          baseUrl: 'https://ingsw2020server.herokuapp.com/events',
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token'
          },
        ));

  Future<List> searchEventsByTitle(SearchParams params) async {
    final response = await _dio.get('/filterSearch', queryParameters: {
      'category': params.categories,
      'titoloEvento': params.title_keyword,
      'date_from': params.start_date,
      'date_to': params.end_date
    });
    List<Event> _resultedEvents =
        List<Event>.from(response.data.map((model) => Event.fromJson(model)));
    print(_resultedEvents);
    return _resultedEvents;
  }

  @override
  void initState() {
    super.initState();
    updateEventListBySearch(this.params);
    print("Inizializzazone");
    print('Titolo ricercato: ${this.params.title_keyword}');
    print('Categorie ricercate: ${this.params.categories}');
    print('Data inizio ricerca: ${this.params.start_date}');
    print('Data fine ricerca: ${this.params.end_date}');
  }

  Widget _buildItemsForListView(BuildContext context, int index) {
    final event = _resultedEvents[index];
    return new Container(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.fromLTRB(16, 16, 0, 0),
                width: double.infinity,
                color: Colors.white,
                child: Text(
                  event.titoloEvento,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
                child: Container(
                  alignment: Alignment.center,
                  child: Image.network(event.urlToImage,
                      height: 250, width: double.infinity, fit: BoxFit.cover),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: Row(
                  children: [
                    Flexible(
                      child: Text(event.descrizione),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 24, 0, 8),
                child: Row(
                  children: <Widget>[
                    Text(
                      "CP: ${event.civicPoints.toString()}",
                      style: new TextStyle(color: Colors.green),
                    ),
                    Spacer(),
                    Text(
                        /*DateFormat('dd/MM/yyyy')
                        .format(event.data)
                        .toString())
                        */
                        event.data),
                  ],
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  child: Text("Scopri di più"),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DetailedEvent(
                                event: _resultedEvents[index],
                              )),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Risultati ricerca'),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.pop(context);
          },
          label: const Text('Indietro'),
          icon: const Icon(Icons.arrow_back),
          backgroundColor: Colors.blue,
        ),
        body: ListView.builder(
          itemCount: _resultedEvents.length,
          itemBuilder: _buildItemsForListView,
        ));
  }

  void updateEventListBySearch(SearchParams params) async {
    List<Event> eventiTrovati = await searchEventsByTitle(params);
    print("\n\n");
    print("Lista eventi attuale");
    setState(() {
      this._resultedEvents = eventiTrovati;
    });
  }
}

class ResultsList extends StatefulWidget {
  final SearchParams params;

  const ResultsList({Key key, this.params}) : super(key: key);

  @override
  createState() => ResultsListState(params);
}
