import 'package:flutter/material.dart';
import 'serverConnection.dart';

class Test extends StatefulWidget {
  @override
  _TestState createState() => _TestState();
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
                                  serverConnection.addEvent(
                                      inputComune.text,
                                      inputEvento.text,
                                      inputDescrizione.text,
                                      selectedDate.toLocal().toString().split(' ')[0]);
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
                            onPressed: () async {
                              String response = await serverConnection.getAllEvents();
                              print(response);
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
                            onPressed: () async {
                              String response = await serverConnection.getEventByID(inputEventID.text);
                              print(response);
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
}