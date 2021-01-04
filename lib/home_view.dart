import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'Event.dart';
import 'data_repo.dart';
import 'event_page.dart';
import 'serverConnection.dart';
import 'dart:convert';

///La pagina viene creata come StatefulWidget per riuscire ad usare la funzione
///initState() che viene caricata quando la pagina viene caricata
class EventListPage extends StatefulWidget{
  @override
  _EventListPageState createState() => _EventListPageState();
}

class _EventListPageState extends State<EventListPage> {

  final List<Event> eventList = [
    Event(0, idEventTitle[1], 20.0, DateTime.now(), idEventDescription[1]),
    Event(1, idEventTitle[2], 50.0, DateTime.now(), idEventDescription[2]),
    Event(2, idEventTitle[3], 10.0, DateTime.now(), idEventDescription[3]),
    Event(3, idEventTitle[4], 27.4, DateTime.now(), idEventDescription[4])
  ];

  final List<String> imageSource = [
    "https://tedxcatania.com/wp-content/uploads/2018/10/tedx.jpg",
    "https://sviluppomanageriale.it/media/zoo/images/3-citta-sostenibile_ca730cbae17431898db2108b135ef01e.png",
    "https://www.lavocedinewyork.com/wp-content/uploads/2019/05/lens-3046269_1280-620x430.jpg",
    "https://cf.microninja.me/wp-content/uploads/2018/05/heart-1847868_1280-e1526479142409.png"
  ];

  ///Variabili inizializzate perla pagina degli eventi
  List<Event> eventList1 = [];
  List<String> imageSource1 = [];

  ///Funzione inistState che viene chiamata quando la pagina si carica
  void initState(){
    super.initState();
    loadDataFromServer();
  }

  ///Funzione che viene chiamata in initState
  loadDataFromServer() async {
    print('Loaded page');
    String response = await serverConnection.getAllEvents();
    print(response);
    final body = json.decode(response);
    for (int ctr = 0; ctr <= (body.length - 1); ctr++){
      eventList1.add(Event(ctr, body[0]['titoloEvento'], 20.0, DateTime.parse(body[0]['data']), body[0]['descrizione']));
      imageSource1.add('https://picsum.photos/500/300');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Eventi disponibili"),
      ),
      body: Container(
        child: new ListView.builder(
          itemCount: eventIds.length,
          itemBuilder: (BuildContext context, int index) =>
              buildEventCard(context, index),
        ),
      ),
    );
  }

  Widget buildEventCard(BuildContext context, int index) {
    final event = eventList[index];
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
                  event.title,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
                child: Container(
                  alignment: Alignment.center,
                  child: Image.network(imageSource[index],
                      height: 250, width: double.infinity, fit: BoxFit.cover),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: Row(
                  children: [
                    Flexible(
                      child: Text(
                        '''${(event.description).replaceRange(150, event.description.length, '...')}''',
                        maxLines: 6,
                        softWrap: true,
                      ),
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
                    Text(DateFormat('dd/MM/yyyy')
                        .format(event.startDate)
                        .toString()),
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
                                event: eventList[index],
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
}
