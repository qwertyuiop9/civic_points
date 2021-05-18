import 'package:civic_points/pages/CitySelection.dart';
import 'package:civic_points/signIn.dart';
import 'package:civic_points/webService.dart';
import 'package:flutter/material.dart';
import 'package:civic_points/pages/profileParameters.dart';
import 'package:civic_points/signIn.dart';
import 'package:civic_points/idToken.dart';
import '../bloc.navigation_bloc/navigation_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:civic_points/profiloUtente.dart';

class MyAccountsPageList extends State<MyAccountsPage> {
  //List<Comune>_comuni = [];

  //List<Comune> _comuni = [new Comune(nomeComune: 'Gorizia'),new Comune(nomeComune: 'Udine'),new Comune(nomeComune: 'Trieste'),new Comune(nomeComune: 'Pordenone')];

  //List<Comune> _comuni = [new Comune(nomeComune: 'Udine')];

  ProfiloUtente profilo;
  bool boolComuneDiInteresse = true;
  bool boolComuneDiResidenza = true;
  int modifica;
  int indice;
  bool aggiungi = false;
  var comuneCancella;

  @override
  void initState() {
    super.initState();
    _getProfilo();
    /*if (profilo.comuneDiResidenza != null) {
      boolComuneDiResidenza = true;
      if (profilo.comuniDiInteresse.asMap().containsKey(1)) {
        boolComuneDiInteresse = true;
      }
      _comuni = profilo.comuniDiInteresse;
      _comuni.insert(0, profilo.comuneDiResidenza);
    }*/
  }

  void _getProfilo() {
    WebserviceToken().load(ProfiloUtente.profilo).then((profiloRicevuto) => {
      setState(() => {this.profilo = profiloRicevuto}),
    });
  }

  void deleteComune() async {
    var headers = {'Content-Type': 'application/json',
      'Authorization': 'Bearer ${token}'};
    var request = http.Request(
        'DELETE', Uri.parse('http://ingsw2020server.herokuapp.com/users/me/comuni'));
    request.body = '''{
                  "comune": "${comuneCancella}"
                }''';
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 201) {
      print(response.statusCode);
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }

  Widget _buildItemsForComuniListView(BuildContext context, int index) {
    final comune = profilo.comuniDiInteresse[index].nomeComune;
    return new Container(
      child: Column(
        children: <Widget>[
          Text(
            comune,
            style: TextStyle(
                fontSize: 20,
                color: Colors.blueGrey,
                fontWeight: FontWeight.bold),
          ),
          ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Flexible(
                  child: RaisedButton(
                    child: Text("Modifica"),
                    textColor: Colors.white,
                    color: Colors.blueGrey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    onPressed: () {
                      modifica = 2;
                      //indice = index + 1;
                      indice = index;
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => citySelection(
                                profileParameters:
                                new ProfileParameters(modifica, indice, aggiungi, comune),
                              )));
                    },
                  ),
                ),
                SizedBox(width: 10),
                Flexible(
                  child: RaisedButton(
                    child: Text("Cancella"),
                    textColor: Colors.white,
                    color: Colors.blueGrey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    onPressed: () {
                      comuneCancella = comune;
                      deleteComune();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => citySelection()));
                    },
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    try {
      print (profilo.comuneDiResidenza.nomeComune);
    } catch (e) {
      boolComuneDiResidenza = false;
      try {
        print(profilo.comuniDiInteresse[0].nomeComune);
      } catch (e) {
        boolComuneDiInteresse = false;
      }
    }
    var comuneResidenza = profilo.comuneDiResidenza.nomeComune;
    print(profilo.comuneDiResidenza.nomeComune);
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 50.0,
        title: new Text("Il mio profilo"),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.fromLTRB(16, 16, 0, 0),
          width: double.infinity,
          color: Colors.white,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                SizedBox(height: 40),
                CircleAvatar(
                  backgroundImage: NetworkImage(
                    imageUrl,
                  ),
                  radius: 48,
                  backgroundColor: Colors.transparent,
                ),
                SizedBox(height: 48),
                Text(
                  'Utente',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  name,
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.blueGrey,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Text(
                  'E-mail',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  email,
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.blueGrey,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                if (boolComuneDiResidenza)
                  Text(
                    'Comune di residenza',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                if (boolComuneDiResidenza)
                  Text(
                    comuneResidenza,
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.blueGrey,
                        fontWeight: FontWeight.bold),
                  ),
                if (boolComuneDiResidenza)
                  RaisedButton(
                    child: Text("Modifica"),
                    textColor: Colors.white,
                    color: Colors.blueGrey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    onPressed: () {
                      modifica = 1;
                      indice = 0;
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => citySelection(
                                profileParameters:
                                new ProfileParameters(modifica, indice, aggiungi, ''),
                              )));
                    },
                  ),
                if (boolComuneDiInteresse && boolComuneDiResidenza)
                  SizedBox(height: 20),
                if (boolComuneDiInteresse && boolComuneDiResidenza)
                  Text(
                    'Comuni di interesse',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                if (boolComuneDiInteresse && boolComuneDiResidenza)
                  ListView.builder(
                    //itemCount: _count,
                    itemCount: profilo.comuniDiInteresse.length,
                    shrinkWrap: true,
                    itemBuilder: _buildItemsForComuniListView,
                  ),
                if (boolComuneDiResidenza && !boolComuneDiInteresse)
                  SizedBox(height: 20),
                if (boolComuneDiResidenza)
                  RaisedButton(
                    child: Text("Aggiungi comune di interesse"),
                    textColor: Colors.white,
                    color: Colors.blueGrey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    onPressed: () {
                      modifica = 2;
                      //indice = _comuni.length+1;
                      indice = profilo.comuniDiInteresse.length;
                      aggiungi = true;
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => citySelection(
                                profileParameters:
                                new ProfileParameters(modifica, indice, aggiungi, ''),
                              )));
                    },
                  ),
                if (!boolComuneDiResidenza)
                  RaisedButton(
                    child: Text("Aggiungi comune di residenza"),
                    textColor: Colors.white,
                    color: Colors.blueGrey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    onPressed: () {
                      modifica = 1;
                      indice = 0;
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => citySelection(
                                profileParameters:
                                new ProfileParameters(modifica, indice, aggiungi, ''),
                              )));
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MyAccountsPage extends StatefulWidget with NavigationStates {
  @override
  createState() => MyAccountsPageList();
}
