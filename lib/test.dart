import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Test extends StatefulWidget {
  @override
  _TestState createState() => _TestState();
}

  getEvents() async {
  var request = http.Request('GET', Uri.parse('https://ingsw2020server.herokuapp.com/events/eventList'));
  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    print(await response.stream.bytesToString());
  }
  else {
    print(response.reasonPhrase);
  }
}

  getEvent(String eventID) async{
    String requestHTTP = 'https://ingsw2020server.herokuapp.com/events/' + eventID;
    var request = http.Request('GET', Uri.parse(requestHTTP));
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    }
    else {
      print(response.reasonPhrase);
    }
  }

class _TestState extends State<Test>{
  final inputComune = TextEditingController();
  final inputEvento = TextEditingController();
  final inputDescrizione = TextEditingController();
  final inputData = TextEditingController();
  DateTime selectedDate = DateTime.now();
  final inputEventID = TextEditingController();

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Test Retrieve/Add'),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                  child: Column(
                    children: <Widget>[
                      Icon(
                        Icons.account_circle,
                        size: 64,
                      ),
                      TextField(
                        decoration: InputDecoration(labelText: "Comune"),
                        controller: inputComune,
                      ),
                      TextField(
                        decoration: InputDecoration(labelText: "Titolo"),
                        controller: inputEvento,
                      ),
                      TextField(
                        decoration: InputDecoration(labelText: "Descrizione"),
                        controller: inputDescrizione,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 32, 0, 0),
                        child: Text("${selectedDate.toLocal()}".split(' ')[0]),
                      ),
                      SizedBox(height: 20.0,),
                      RaisedButton(
                        onPressed: () => _selectDate(context),
                        child: Text('Select date'),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (_) {
                                    return AlertDialog(
                                      title: Text('Aggiungere Evento?'),
                                      actions: [
                                        FlatButton(
                                          onPressed: () => Navigator.pop(context, false), // passing false
                                          child: Text('No'),
                                        ),
                                        FlatButton(
                                          onPressed: () => Navigator.pop(context, true), // passing true
                                          child: Text('Si'),
                                        ),
                                      ],
                                    );
                                  }).then((exit) {
                                if (exit == null) return;

                                if (exit) {
                                  // user pressed Yes button
                                  addEvent(
                                      inputComune.text,
                                      inputEvento.text,
                                      inputDescrizione.text,
                                      selectedDate.toLocal().toString().split(' ')[0]
                                  );
                                  print(selectedDate.toLocal().toString().split(' ')[0]);
                                } else {
                                  // user pressed No button
                                }
                              });
                            },
                            child: Text('Aggiungi Evento'),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              getEvents();
                              print(selectedDate.toLocal().toString());
                            },
                            child: Text('Ricevi Eventi'),
                          ),
                        ),
                      ),
                      TextField(
                        decoration: InputDecoration(labelText: "ID Evento"),
                        controller: inputEventID,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              getEvent(inputEventID.text);
                            },
                            child: Text('Ricevi Evento'),
                          ),
                        ),
                      )
                    ],
                  )),
            ),
          ),
        ),
      ),
    );
  }

  addEvent(String comune, String titolo, String descrizione, String data) async {
    print('Comune:' + comune);
    print('Titolo:' + titolo);
    print('Descrizione:' + descrizione);
    print('Data:' + data);

    Map dati = {
      'comune': comune,
      'titoloEvento': titolo,
      'descrizione': descrizione,
      'data': data
    };

    String body = json.encode(dati);
    print(body.toString());

    //TODO NON E' POSSIBILE USARE JSON ENCODE, DA GUARDARE. PUO' FARE PROBLEMI
    var headers = {
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST',
        Uri.parse('https://ingsw2020server.herokuapp.com/events/'));
    String requestString =
        '{\r\n    "comune": ' + '"' + comune + '"' + ',' +
            '\r\n    "titoloEvento": ' + '"' + titolo + '"' + ',' +
            '\r\n    "descrizione": ' + '"' + descrizione + '"' + ',' +
            '\r\n    "data": ' + '"' + data + '"' + '\r\n}';
    request.body = requestString;

    //Non funziona json.encode con il database
    //request.body= body;
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 201) {
      print(await response.stream.bytesToString());
      print('OK');
    }
    else {
      print(response.reasonPhrase);
      print('Errore');
    }
  }
}