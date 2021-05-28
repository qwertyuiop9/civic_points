import 'package:civic_points/pages/CitySelection.dart';
import 'package:civic_points/pages/profileParameters.dart';
import 'package:civic_points/profiloUtente.dart';
import 'package:civic_points/signIn.dart';
import 'package:civic_points/webService.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../bloc.navigation_bloc/navigation_bloc.dart';

class MyAccountsPageList extends State<MyAccountsPage> {
  //List<Comune>_comuni = [];

  //List<Comune> _comuni = [new Comune(nomeComune: 'Gorizia'),new Comune(nomeComune: 'Udine'),new Comune(nomeComune: 'Trieste'),new Comune(nomeComune: 'Pordenone')];

  //List<Comune> _comuni = [new Comune(nomeComune: 'Udine')];

  ProfiloUtente profilo;
  bool boolComuneDiInteresse = false;
  bool boolComuneDiResidenza = false;
  int modifica;
  int indice;
  bool aggiungi = false;
  var comuneCancella;
  bool boolRuoloSindaco;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getProfilo();
    });
  }

  void _getProfilo() {
    WebserviceToken().load(ProfiloUtente.profilo).then((profiloRicevuto) => {
          setState(() => {this.profilo = profiloRicevuto}),
        });
  }

  void deleteComune(var comuneCancella) async {
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${token}'
    };
    var request = http.Request('DELETE',
        Uri.parse('http://ingsw2020server.herokuapp.com/users/me/comuni'));
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
                                    profileParameters: new ProfileParameters(
                                        modifica, indice, aggiungi, comune),
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
                      deleteComune(comuneCancella);
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _getProfilo();
                      });
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
    var comuneResidenza;
    var comuneInteresse;
    var ruolo;

    try {
      comuneResidenza = (profilo == null) ? null : profilo.comuneDiResidenza.nomeComune;
      ruolo = (profilo == null) ? null : profilo.ruolo;
      print ('comune di residenza cè');
      try {
        comuneInteresse = (profilo == null) ? null : (profilo.comuniDiInteresse[0].nomeComune);

        print ('comune di interesse cè');
      } catch (e) {
        print ('comune di residenza non cè');
      }
    } catch (e) {
      print ('comune di interesse non cè');
    }

    if (comuneResidenza  != null){
      boolComuneDiResidenza = true;
    }
    if (comuneInteresse != null){
      boolComuneDiInteresse = true;
    }
    if (ruolo == 'cittadino') {
      boolRuoloSindaco = false;
    } else if (ruolo == 'sindaco') {
      boolRuoloSindaco = true;
    }
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 50.0,
        title: new Text("Il mio profilo"),
        automaticallyImplyLeading: false,
      ),
      body: (profilo == null)
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
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
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      /*Text(
                        name,
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.blueGrey,
                            fontWeight: FontWeight.bold),
                      ),*/
                      InkWell(
                        child: Container(
                            height: 50.0,
                            alignment: Alignment.center,
                            child: Stack(
                                children:<Widget>[
                                  Align(alignment: Alignment.center, child: Text(name,
                                    style: TextStyle(fontSize: 20,
                                        color: Colors.blueGrey,
                                        fontWeight: FontWeight.bold),)),
                                  boolRuoloSindaco ? Positioned(top: 12.0, right: 20.0, child: Container(
                                    child: Image(
                                      image: AssetImage(
                                        'assets/icona_sindaco_blu.png',
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                    height: 25,
                                    width: 25,
                                  ),) : Container(),
                                ])
                        ),
                      ),
                      /*ListTile(
                        title: Text(
                          name,
                          style: TextStyle(fontSize: 20,
                              color: Colors.blueGrey,
                              fontWeight: FontWeight.bold),
                        ),
                        trailing: Container(
                          child: Image(
                            image: AssetImage(
                              'assets/icona_sindaco_blu.png',
                            ),
                            fit: BoxFit.cover,
                          ),
                          height: 25,
                          width: 25,
                        ),
                      ),*/
                      SizedBox(height: 20),
                      Text(
                        'E-mail',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
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
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
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
                                              new ProfileParameters(modifica,
                                                  indice, aggiungi, ''),
                                        )));
                          },
                        ),
                      if (boolComuneDiInteresse && boolComuneDiResidenza)
                        SizedBox(height: 20),
                      if (boolComuneDiInteresse && boolComuneDiResidenza)
                        Text(
                          'Comuni di interesse',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      if (boolComuneDiInteresse && boolComuneDiResidenza)
                        ListView.builder(
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
                            indice = profilo.comuniDiInteresse.length;
                            aggiungi = true;
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => citySelection(
                                          profileParameters:
                                              new ProfileParameters(modifica,
                                                  indice, aggiungi, ''),
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
                                              new ProfileParameters(modifica,
                                                  indice, aggiungi, ''),
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
