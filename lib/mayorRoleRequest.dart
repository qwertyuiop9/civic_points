import 'package:civic_points/eventCreated.dart';
import 'package:civic_points/signIn.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'notifications/Notification_Handler.dart';

//Screen for event data entry
class MayorRoleRequest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Richiedi il ruolo di sindaco'),
        ),
        body: MayorRoleRequestForm());
  }
}

// Create Form widget.
class MayorRoleRequestForm extends StatefulWidget {
  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class MyCustomFormState extends State<MayorRoleRequestForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();
  //Variables for event entry
  String nome = '';
  String cognome = '';
  String indirizzo = '';
  String comune = '';
  int timestamp;
  bool _termsChecked = true;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
          margin: EdgeInsets.all(10.0),
          child: new ListView(
            children: getFormWidget(),
          )),
    );
  }

  List<Widget> getFormWidget() {
    List<Widget> formWidget = new List();
    formWidget.add(
      new TextFormField(
          decoration: InputDecoration(labelText: 'Nome'),
          validator: (value) {
            if (value.isEmpty) return 'Prego inserire nome';
          },
          onChanged: (value) {
            setState(() {
              nome = value;
            });
          }),
    );

    formWidget.add(
      new TextFormField(
          decoration: InputDecoration(labelText: 'Cognome'),
          validator: (value) {
            if (value.isEmpty) return 'Prego inserire cognome';
          },
          onChanged: (value) {
            setState(() {
              cognome = value;
            });
          }),
    );

    formWidget.add(
      new TextFormField(
          decoration: InputDecoration(labelText: 'Indirizzo'),
          validator: (value) {
            if (value.isEmpty) return 'Prego inserire indirizzo';
          },
          onChanged: (value) {
            setState(() {
              indirizzo = value;
            });
          }),
    );

    formWidget.add(
      new TextFormField(
          decoration: InputDecoration(labelText: 'Comune'),
          validator: (value) {
            if (value.isEmpty) return 'Prego inserire comune';
          },
          onChanged: (value) {
            setState(() {
              comune = value;
            });
          }),
    );

    void roleRequest() async {
      if (_formKey.currentState.validate() && _termsChecked) {
        _formKey.currentState.save();
        timestamp = DateTime.now().millisecondsSinceEpoch;
        var headers = {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${token}'
        };
        var request = http.Request('POST',
            Uri.parse('http://ingsw2020server.herokuapp.com/...........'));
        request.body = '''{
                    "nome": "${nome}",
                    "cognome": "${cognome}",
                    "indirizzo": "${indirizzo}",
                    "comune": "${comune}",
                    "timestamp": "${timestamp}"
                  }''';
        request.headers.addAll(headers);

        http.StreamedResponse response = await request.send();

        if (response.statusCode == 201) {
          print(response.statusCode);
          print(await response.stream.bytesToString());
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => createdEvent()));
        } else {
          print(response.reasonPhrase);
        }
      }
      // Schedulazione notifica (l'utente ha l'attribuzione del ruolo di sindaco)
      nh.scheduleNotification();
    }

    formWidget.add(new RaisedButton(
        color: Colors.blueGrey,
        textColor: Colors.white,
        child: new Text('Invia richiesta'),
        onPressed: roleRequest));
    return formWidget;
  }
}
