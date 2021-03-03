import 'package:civic_points/event_details_page.dart';
import 'package:civic_points/webservice.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'event.dart';

class EventsListState extends State<EventsList> {
  List<Event> _eventDetails = [];

  @override
  void initState() {
    super.initState();
    _populateNewsArticles();
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
                  color: Colors.blue,
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
          title: Text('Events'),
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
