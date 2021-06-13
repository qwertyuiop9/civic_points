import 'package:civic_points/event/eventListState.dart';
import 'package:civic_points/event/eventCreate.dart';
import 'package:flutter/material.dart';
import 'package:civic_points/bloc.navigation_bloc/navigationBloc.dart';
import 'package:civic_points/userProfile/mayorRoleRequest.dart';
import 'event/projectOptionsCivicPoints.dart';
import 'package:civic_points/userProfile/userProfile.dart';
import 'package:civic_points/serverConnection/webService.dart';

/// Define state of WelcomeScreen.
class WelcomeScreenState extends State<WelcomeScreen> {
  ProfiloUtente profilo;
  /// Variable: true if ruolo == 'sindaco', false if ruolo == 'cittadino'.
  /// If true shows the "Richiedi il ruolo di sindaco" button.
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

/// App main screen.
class WelcomeScreen extends StatefulWidget with NavigationStates {
  @override
  createState() => WelcomeScreenState();
}