import 'package:flutter/material.dart';
import 'package:civic_points/sidebar/sidebarLayout.dart';

/// Screen to confirm event creation.
class createdRole extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: Container(
        margin: const EdgeInsets.fromLTRB(16, 16, 0, 0),
        width: double.infinity,
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              SizedBox(height: 40),
              Text(
                'Richiesta inviata con successo',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              RaisedButton(
                onPressed: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => SideBarLayout()));
                },
                child: Text("Home"),
                textColor: Colors.white,
                color: Colors.blueGrey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                elevation: 5,
              ),
            ],
          ),
        ),
      ),
    );
  }
  Future navigateToEventListPage(context) async {
    Navigator.push(context, MaterialPageRoute(builder: (context) => SideBarLayout()));
  }
}