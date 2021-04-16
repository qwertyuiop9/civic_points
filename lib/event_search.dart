import 'package:civic_points/event_created.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:quiver/strings.dart';
import 'Event.dart';
import 'package:date_field/date_field.dart';

class searchEvent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Cerca eventi'),
        ),
        body: createEventSearchForm());
  }
}

// Create a Form widget.
class createEventSearchForm extends StatefulWidget {
  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

//Creo una classe per le categorie dell'evento, necessaria per il corretto funzionamento del DropdownButton
class Categoria {
  const Categoria(this.name);
  final String name;
}

// Create a corresponding State class.
// This class holds data related to the form.
class MyCustomFormState extends State<createEventSearchForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();
  //Dichiaro le variabili per l'inserimento dell'evento
  String titolo = '';
  String category_1 = '';
  String category_2 = '';
  int date_from;
  int date_to;
  String comune = '';
  Categoria categoriaSelezionata_1;
  Categoria categoriaSelezionata_2;
  //Aggiungere nella seguente lista le categorie
  List<Categoria> categorie = <Categoria>[Categoria('Sport'), Categoria('Cultura'), Categoria('Spettacolo')];
  bool _termsChecked = true;


  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
          margin: EdgeInsets.all(10.0),
          child: new ListView(
            children: getFormWidget(),
          )
      ),
    );
  }

  List<Widget> getFormWidget() {
    List<Widget> formWidget = new List();
    formWidget.add(
      new TextFormField(
          decoration: InputDecoration(
              labelText: 'Titolo'),
          onChanged: (value) {
            setState(() {
              titolo = value;
            });
          }),
    );

    formWidget.add(
      new TextFormField(
          decoration: InputDecoration(
              labelText: 'Comune'),
          onChanged: (value) {
            setState(() {
              comune = value;
            });
          }),
    );

    formWidget.add(
      new DateTimeFormField(
        decoration: const InputDecoration(
        hintStyle: TextStyle(color: Colors.black45),
        errorStyle: TextStyle(color: Colors.redAccent),
        border: OutlineInputBorder(),
        suffixIcon: Icon(Icons.event_note),
        labelText: 'Data inizio ricerca',
      ),
        mode: DateTimeFieldPickerMode.date,
        autovalidateMode: AutovalidateMode.always,
        validator: (e) =>
        (e?.day ?? 0) == 1 ? 'Prego inserire data' : null,
        onDateSelected: (DateTime value) {
          date_from = value.millisecondsSinceEpoch;
        },
    ),
    );

    formWidget.add(
      new DateTimeFormField(
        decoration: const InputDecoration(
          hintStyle: TextStyle(color: Colors.black45),
          errorStyle: TextStyle(color: Colors.redAccent),
          border: OutlineInputBorder(),
          suffixIcon: Icon(Icons.event_note),
          labelText: 'Data inizio ricerca',
        ),
        mode: DateTimeFieldPickerMode.date,
        autovalidateMode: AutovalidateMode.always,
        validator: (e) =>
        (e?.day ?? 0) == 1 ? 'Prego inserire data' : null,
        onDateSelected: (DateTime value) {
          date_to = value.millisecondsSinceEpoch;
        },
      ),
    );

    formWidget.add(new DropdownButton<Categoria>(
      hint: new Text("Seleziona categoria"),
      value: categoriaSelezionata_1,
      onChanged: (Categoria newValue) {
        setState(() {
          categoriaSelezionata_1 = newValue;
        });
      },
      items: categorie.map((Categoria categoria) {
        return new DropdownMenuItem<Categoria>(
          value: categoria,
          child: new Text(
            categoria.name,
            style: new TextStyle(color: Colors.black),
          ),
        );
      }).toList(),
    )
    );

    formWidget.add(new DropdownButton<Categoria>(
      hint: new Text("Seleziona categoria"),
      value: categoriaSelezionata_2,
      onChanged: (Categoria newValue) {
        setState(() {
          categoriaSelezionata_2 = newValue;
        });
      },
      items: categorie.map((Categoria categoria) {
        return new DropdownMenuItem<Categoria>(
          value: categoria,
          child: new Text(
            categoria.name,
            style: new TextStyle(color: Colors.black),
          ),
        );
      }).toList(),
    )
    );

    void eventCreate() async {
      if (_formKey.currentState.validate() && _termsChecked) {
        _formKey.currentState.save();
        var headers = {'Content-Type': 'application/json'};
        var request = http.Request(
            'POST', Uri.parse('http://ingsw2020server.herokuapp.com/events/search'));
        request.body = '''{
                    "titoloRicercato": "${titolo}",
                    "categoria_1": "${categoriaSelezionata_1.name}",
                    "categoria_2": "${categoriaSelezionata_1.name}",
                    "date_from": "${date_to}"
                    "date_to": "${date_from}"
                    "comune": "${comune}",
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
    }
    formWidget.add(new RaisedButton(
        color: Colors.blueGrey,
        textColor: Colors.white,
        child: new Text('Invia'),
        onPressed: eventCreate));
    return formWidget;
  }
}
