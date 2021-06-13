import 'package:civic_points/userProfile/citySelection.dart';
import 'package:civic_points/userProfile/profileParameters.dart';
import 'package:civic_points/userProfile/userProfile.dart';
import 'package:civic_points/signIn/signIn.dart';
import 'package:civic_points/serverConnection/webService.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../bloc.navigation_bloc/navigationBloc.dart';

/// Define state of MyAccountsPage
class MyAccountsPageList extends State<MyAccountsPage> {
  /// Object to handle user profile information received from server.
  ProfiloUtente profilo;
  /// Variable set at the first time to false, to check if the object arriving from the server
  /// has a home city already set (true) or not (false).
  bool boolComuneDiResidenza = false;
  /// Variable set at the first time to false, to check if the object arriving from the server
  /// has a city of interest already set (true) or not (false).
  bool boolComuneDiInteresse = false;
  /// Variable to check if the user wants to modify the home city (variable set to 1)
  /// or he wants to add a city of interest (variable set to 2).
  /// The variable is sent to the citySelection screen to handle the buttons view
  /// and understand the user desire.
  int modifica;
  /// Variable to store city index in list and to send that index through profileParameters
  /// to the citySelection screen.
  int indice;
  /// Variable to know if the user want to add a city of interest. Redundant at the moment.
  bool aggiungi = false;
  /// Variable to store the name of the city of interest to delete.
  var comuneCancella;
  /// Variable false if ruolo == 'cittadino', true if ruolo == 'sindaco'.
  /// It handles the view of the fields "Ruolo" and "Comune amministrato" (shown if variable set to true).
  bool boolRuoloSindaco;

  /// Method to initialize state.
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getProfilo();
    });
  }

  /// Method to get the user profile information from the server.
  void _getProfilo() {
    WebserviceToken().load(ProfiloUtente.profilo).then((profiloRicevuto) => {
          setState(() => {this.profilo = profiloRicevuto}),
        });
  }

  /// Method to delete a city of interest from the list of the user's cities of interest.
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
    var comuneAmministrato;

    try {
      comuneResidenza = (profilo == null) ? null : profilo.comuneDiResidenza.nomeComune;
      ruolo = (profilo == null) ? null : profilo.ruolo;
      print ('comune di residenza cè');
      try {
        comuneInteresse = (profilo == null) ? null : (profilo.comuniDiInteresse[0].nomeComune);
        comuneAmministrato = (profilo == null) ? null : (profilo.comuneAmministrato.nomeComune);
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
                      Text(
                        name,
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.blueGrey,
                            fontWeight: FontWeight.bold),
                      ),
                      /*Di seguito si lascia l'implementazione con star di colore blu dopo il nome, nel caso in cui un utente sia anche sindaco
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
                      ),*/
                      if (boolRuoloSindaco == true)
                        SizedBox(height: 20),
                      if (boolRuoloSindaco == true)
                        Text(
                          'Ruolo',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      if (boolRuoloSindaco == true)
                        Text(
                          'Sindaco',
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.blueGrey,
                              fontWeight: FontWeight.bold),
                        ),
                      if (boolRuoloSindaco == true)
                        SizedBox(height: 20),
                      if (boolRuoloSindaco == true)
                        Text(
                          'Comune amministrato',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      if (boolRuoloSindaco == true)
                        Text(
                          comuneAmministrato,
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.blueGrey,
                              fontWeight: FontWeight.bold),
                        ),

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

/// Screen to view the user profile information.
class MyAccountsPage extends StatefulWidget with NavigationStates {
  @override
  createState() => MyAccountsPageList();
}
