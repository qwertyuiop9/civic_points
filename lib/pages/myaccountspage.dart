import 'package:civic_points/pages/CitySelection.dart';
import 'package:flutter/material.dart';
import 'package:civic_points/login.dart';
import 'package:civic_points/signIn.dart';
import '../bloc.navigation_bloc/navigation_bloc.dart';
import 'package:civic_points/webService.dart';
import 'package:civic_points/comune.dart';

class MyAccountsPageList extends State<MyAccountsPage>{
  ///List<Comune> _comuni = [];
  List<Comune> _comuni = [new Comune(nome: 'Udine'), new Comune(nome: 'Gorizia'), new Comune(nome: 'Trieste'), new Comune(nome: 'Pordenone')];
  ///List<Comune> _comuni = [new Comune(nome: 'Udine')];
  bool boolComuneDiInteresse = false;
  bool boolComuneDiResidenza = false;

  @override
  void initState() {
    super.initState();
    ///_populateNewsArticles();
    if (!_comuni.isEmpty) {
      boolComuneDiResidenza = true;
      if (_comuni.asMap().containsKey(1)) {
        boolComuneDiInteresse = true;
      }
    }
  }

  void _populateNewsArticles() {
    Webservice().load(Comune.all).then((comune) => {
      setState(() => {_comuni = comune})
    });
  }

  Widget _buildItemsForComuniListView(BuildContext context, int index) {
    final comune = _comuni[index+1];
    return new Container(
          child: Column(
            children: <Widget>[
              Text(
                comune.nome,
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
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) =>
                                citySelection())
                        );
                      },
                    ),),
                    SizedBox(width: 10),
                    Flexible(child: RaisedButton(
                      child: Text("Cancella"),
                      textColor: Colors.white,
                      color: Colors.blueGrey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) =>
                                citySelection())
                        );
                      },
                    ),),
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
    var comuneDiResidenza;
    var _count;
    if (boolComuneDiResidenza){
      comuneDiResidenza = _comuni[0];
    }
    if (boolComuneDiInteresse) {
      _count = _comuni.length - 1;
    }

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
                    comuneDiResidenza.nome,
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
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>
                              citySelection())
                      );
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
                    itemCount: _count,
                    shrinkWrap: true,
                    itemBuilder: _buildItemsForComuniListView,
                  ),
                if (boolComuneDiResidenza)
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
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>
                              citySelection())
                      );
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
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>
                              citySelection())
                      );
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