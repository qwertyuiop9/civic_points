import 'package:civic_points/event_created.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:quiver/strings.dart';
import 'Event.dart';
import 'package:date_field/date_field.dart';

//Screen for event data entry
class createEvent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Crea evento'),
        ),
        body: createEventForm());
  }
}

// Create Form widget.
class createEventForm extends StatefulWidget {
  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

//Create class for event categories. Necessary for DropdownButton correct operation.
class Categoria {
  const Categoria(this.name);
  final String name;
}

// Create a corresponding State class.
// This class holds data related to the form.
class MyCustomFormState extends State<createEventForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();
  //Variables for event entry
  String titolo = '';
  String descrizione = '';
  String indirizzo = '';
  String comune = '';
  String info_url = '';
  String image_url = '';
  int timestamp;
  Categoria categoriaSelezionata;
  //Add to following list the categories
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
          validator: (value) {
            if (value.isEmpty) return 'Prego inserire titolo';
          },
          onChanged: (value) {
            setState(() {
              titolo = value;
            });
          }),
    );

    formWidget.add(
      new TextFormField(
          decoration: InputDecoration(
              labelText: 'Descrizione'),
          validator: (value) {
            if (value.isEmpty) return 'Prego inserire descrizione';
          },
          onChanged: (value) {
            setState(() {
              descrizione = value;
            });
          }),
    );

    formWidget.add(
      new TextFormField(
          decoration: InputDecoration(
              labelText: 'Indirizzo'),
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
          decoration: InputDecoration(
              labelText: 'Comune'),
          validator: (value) {
            if (value.isEmpty) return 'Prego inserire comune';
          },
          onChanged: (value) {
            setState(() {
              comune = value;
            });
          }),
    );

    formWidget.add(new DateTimeFormField(
      decoration: const InputDecoration(
        hintStyle: TextStyle(color: Colors.black45),
        errorStyle: TextStyle(color: Colors.redAccent),
        border: OutlineInputBorder(),
        suffixIcon: Icon(Icons.event_note),
        labelText: 'Data e ora',
      ),
      autovalidateMode: AutovalidateMode.always,
      validator: (e) =>
      (e?.day ?? 0) == 1 ? 'Prego inserire data e ora' : null,
      onDateSelected: (DateTime value) {
        timestamp = value.millisecondsSinceEpoch;
      },
    ),
    );

    formWidget.add(new DropdownButton<Categoria>(
      hint: new Text("Seleziona categoria"),
      value: categoriaSelezionata,
      onChanged: (Categoria newValue) {
        setState(() {
          categoriaSelezionata = newValue;
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

    formWidget.add(
      new TextFormField(
          decoration: InputDecoration(
              labelText: 'URL per informazioni'),
          validator: (value) {
            if (value.isEmpty) return 'Prego inserire URL per informazioni';
          },
          onChanged: (value) {
            setState(() {
              info_url = value;
            });
          }),
    );

    formWidget.add(
      new TextFormField(
          decoration: InputDecoration(
              labelText: 'URL immagine'),
          validator: (value) {
            if (value.isEmpty) return 'Prego inserire URL immagine';
          },
          onChanged: (value) {
            setState(() {
              image_url = value;
            });
          }),
    );

    void eventCreate() async {
      if (_formKey.currentState.validate() && _termsChecked) {
        _formKey.currentState.save();
        var headers = {'Content-Type': 'application/json'};
        var request = http.Request(
            'POST', Uri.parse('http://ingsw2020server.herokuapp.com/events'));
        request.body = '''{
                    "comune": "${comune}",
                    "indirizzo": "${indirizzo}",
                    "info_url": "${info_url}",
                    "image_url": "${image_url}",
                    "categoria": "${categoriaSelezionata.name}",
                    "titoloEvento": "${titolo}",
                    "descrizione": "${descrizione}",
                    "data": "${timestamp}"
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
