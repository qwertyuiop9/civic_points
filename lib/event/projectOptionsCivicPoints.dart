import 'package:civic_points/serverConnection/webService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'event.dart';

class ProjectsListState extends State<ProjectList> {
  List<Event> _eventDetails = [];

  @override
  void initState() {
    super.initState();
    _populateNewsArticles();
  }

  void _populateNewsArticles() {
    Webservice().load(Event.all_projects).then((event) => {
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
                padding: const EdgeInsets.all(0.0),
                child: Row(
                  children: [
                    Flexible(
                      child: Text(event.comune),
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
          title: Text('Eventi'),
        ),
        body: ListView.builder(
          itemCount: _eventDetails.length,
          itemBuilder: _buildItemsForListView,
        ));
  }
}

class ProjectList extends StatefulWidget {
  @override
  createState() => ProjectsListState();
}
