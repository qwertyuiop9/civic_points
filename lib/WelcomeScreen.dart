import 'package:civic_points/EventListState.dart';
import 'package:civic_points/eventCreate.dart';
import 'package:flutter/material.dart';
import 'package:civic_points/bloc.navigation_bloc/navigation_bloc.dart';
import 'package:civic_points/mayorRoleRequest.dart';
import 'ProjectOptionsCivicPoints.dart';
import 'package:civic_points/profiloUtente.dart';
import 'package:civic_points/webService.dart';
import 'package:http/http.dart' as http;

//Main screen app
//class WelcomeScreen extends StatelessWidget with NavigationStates {
class WelcomeScreenState extends State<WelcomeScreen> {
  ProfiloUtente profilo;
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
  @override
  Widget build(BuildContext context) {
    var ruolo;
    try {
      ruolo = (profilo == null) ? null : profilo.ruolo;
      print ('ruolo cè');
    } catch (e) {
      print ('ruolo non cè');
    }
    if (ruolo == 'cittadino') {
      boolRuoloSindaco = false;
    } else if (ruolo == 'sindaco') {
      boolRuoloSindaco = true;
    }
    return Scaffold(
      appBar: AppBar(
        //centerTitle: true,
        titleSpacing: 50.0,
        title: new Text("Home"),
        automaticallyImplyLeading: false,
      ),
      body: (profilo == null)
          ? Center(
        child: CircularProgressIndicator(),
      ) : SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.fromLTRB(16, 16, 0, 0),
          width: double.infinity,
          color: Colors.white,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                SizedBox(height: 170),
                RaisedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => createEvent()));
                  },
                  child: Text("Crea evento"),
                  textColor: Colors.white,
                  color: Colors.blueGrey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  elevation: 5,
                ),
                SizedBox(height: 40),
                RaisedButton(
                  onPressed: () {
                    navigateToEventListPage(context);
                  },
                  child: Text("Eventi disponibili"),
                  textColor: Colors.white,
                  color: Colors.blueGrey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  elevation: 5,
                ),
                SizedBox(height: 40),
                RaisedButton(
                  onPressed: () {
                    navigateToCivicPointsProjects(context);
                  },
                  child: Text("Opzioni di spesa disponibili"),
                  textColor: Colors.white,
                  color: Colors.blueGrey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  elevation: 5,
                ),
                SizedBox(height: 40),
                if (boolRuoloSindaco == false)
                  RaisedButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) =>
                              MayorRoleRequest()));
                    },
                    child: Text("Richiedi il ruolo di sindaco"),
                    textColor: Colors.white,
                    color: Colors.blueGrey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    elevation: 5,
                  )

              ],
            ),
          ),
        ),
      ),
    );
  }

  Future navigateToEventListPage(context) async {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => EventsList()));
  }
  Future navigateToCivicPointsProjects(context) async {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ProjectList()));
  }
}

class WelcomeScreen extends StatefulWidget with NavigationStates {
  @override
  createState() => WelcomeScreenState();
}