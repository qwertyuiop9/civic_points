import 'package:civic_points/EventListState.dart';
import 'package:civic_points/eventCreate.dart';
import 'package:civic_points/login.dart';
import 'package:civic_points/signIn.dart';
import 'package:flutter/material.dart';
import 'package:civic_points/bloc.navigation_bloc/navigation_bloc.dart';

import 'ProjectOptionsCivicPoints.dart';

//Main screen app
class WelcomeScreen extends StatelessWidget with NavigationStates {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //centerTitle: true,
        titleSpacing: 50.0,
        title: new Text("Home"),
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
                SizedBox(height: 200),
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
