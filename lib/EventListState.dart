import 'package:civic_points/eventDetailsPage.dart';
import 'package:civic_points/search/advanced_search.dart';
import 'package:civic_points/search/search.dart';
import 'package:civic_points/webService.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'event.dart';

class EventsListState extends State<EventsList> {
  List<Event> _eventDetails = [];
  var title_search = "";
  final titleController = TextEditingController();
  var searchOn = false;
  var vertical_search_box_size = 50.0;
  var horizontal_search_box_size = 50.0;

  @override
  void initState() {
    super.initState();
    _populateNewsArticles();
    searchOn = true;
  }

  void _populateNewsArticles() {
    Webservice().load(Event.all).then((event) => {
          setState(() => {_eventDetails = event})
        });
  }

  Widget _buildItemsForListView(BuildContext context, int index) {
    final event = _eventDetails[index];
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
                child: RaisedButton(
                  child: Text("Scopri di più"),
                  textColor: Colors.white,
                  color: Colors.blueGrey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DetailedEvent(
                                event: _eventDetails[index],
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

  Icon cusIcon = Icon(Icons.search);
  Widget cusSearchBar = Text('Eventi disponibili');
  TextEditingController titleSearchController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: cusSearchBar,
          actions: <Widget>[
            IconButton(
                icon: cusIcon,
                onPressed: () {
                  setState(() {
                    if (this.cusIcon.icon == Icons.search) {
                      this.cusIcon = Icon(Icons.cancel);
                      this.cusSearchBar = TextField(
                        textInputAction: TextInputAction.go,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Search term',
                        ),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                        ),
                        controller: titleSearchController,
                        onSubmitted: (String text) async {
                          print('SUBMITTED');
                          List<Event> searchedEventList =
                              await searchEventsByTitle(text);
                          if (searchedEventList.length < 1) {
                            searchedEventList = [
                              Event.getNullPlaceholderEvent()
                            ];
                            setState(() {
                              this._eventDetails = searchedEventList;
                            });
                          } else {
                            setState(() {
                              this._eventDetails = searchedEventList;
                            });
                          }
                        },
                      );
                    } else {
                      this.cusIcon = Icon(Icons.search);
                      this.cusSearchBar = Text('Eventi ricercati');
                    }
                  });
                }),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AdvancedSearch(
                        searchParams:
                            new SearchParams(this.title_search, null, null, []),
                      )),
            );
          },
          label: const Text('Cerca'),
          icon: const Icon(Icons.search),
          backgroundColor: Colors.blue,
        ),
        body: ListView.builder(
          itemCount: _eventDetails.length,
          itemBuilder: _buildItemsForListView,
        ));
  }

  void updateEventListBySearch(String text) async {
    this._eventDetails = await searchEventsByTitle(text);
    print("\n\n");
    print("Lista eventi attuale");
    print(this._eventDetails);
  }

  final Dio _dio;

  EventsListState()
      : _dio = Dio(BaseOptions(
          baseUrl: 'https://ingsw2020server.herokuapp.com/events/',
          headers: {
            'Accept': 'application/json',
          },
        ));

  Future<List> searchEventsByTitle(String title) async {
    final response =
        await _dio.get('search', queryParameters: {'title': title});
    print('\nINIZIO DATI OTTENUTI\n');
    print(response.data);
    print('\FINE DATI OTTENUTI\n');
    List<Event> retrievedEvents =
        List<Event>.from(response.data.map((model) => Event.fromJson(model)));
    print(retrievedEvents);
    return retrievedEvents;
  }
}

class EventsList extends StatefulWidget {
  @override
  createState() => EventsListState();
}
