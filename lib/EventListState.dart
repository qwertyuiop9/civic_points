import 'package:civic_points/event_details_page.dart';
import 'package:civic_points/webservice.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'event.dart';

class EventsListState extends State<EventsList> {
  List<Event> _eventDetails = [];
  var title_search = "";
  Widget search_box = null;
  int state = 0;
  final titleController = TextEditingController();
  var searchOn = true;

  @override
  void initState() {
    super.initState();
    _populateNewsArticles();
    searchOn = true;
    search_box = _getSearchBox();
  }

  void _populateNewsArticles() {
    Webservice().load(Event.all).then((event) => {
          setState(() => {_eventDetails = event})
        });
  }

  // Questo metodo deve restituire il risultato della ricerca degli eventi dove il parametro titolo è nella variabile "titolo_da_cercare"
  void _updateEventListBySearch() {
    var titolo_da_cercare = title_search;
    Webservice().load(Event.eventsBySearch).then((event) => {
          setState(() => {_eventDetails = event})
        });
  }

  Widget _getSearchBox() {
    if (searchOn) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(32, 0, 32, 0),
        child: Container(
          child: TextField(
            onSubmitted: (text) {
              print(text);
              this.title_search = text.trim();
              _updateEventListBySearch();
            },
            cursorColor: Colors.black54,
            controller: titleController,
          ),
        ),
      );
    } else {
      return Container(
        width: 0,
        height: 0,
      );
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Eventi disponibili'),
          actions: <Widget>[
            IconButton(
              onPressed: () {
                if (searchOn) {
                  searchOn = false;
                  setState(() {
                    search_box = _getSearchBox();
                  });
                } else {
                  searchOn = true;
                  setState(() {
                    search_box = _getSearchBox();
                  });
                }
              },
              icon: Icon(Icons.search),
            ),
          ],
          bottom: PreferredSize(
            preferredSize: Size(50, 50),
            child: search_box,
          ),
        ),
        body: ListView.builder(
          itemCount: _eventDetails.length,
          itemBuilder: _buildItemsForListView,
        ));
  }
}

class EventsList extends StatefulWidget {
  @override
  createState() => EventsListState();
}
