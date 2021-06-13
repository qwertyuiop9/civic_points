import 'package:civic_points/userProfile/profileParameters.dart';
import 'package:civic_points/signIn/signIn.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:civic_points/sidebar/sidebarLayout.dart';

/// Define state of citySelection.
class citySelectionState extends State<citySelection> {
  /// Variable to store country data in onChanged method.
  String countryValue = "";
  /// Variable to store state data in onChanged method.
  String stateValue = "";
  /// Variable to store city data in onChanged method.
  String cityValue = "";
  /// Variable to store city data in setState method.
  String comune = "";
  /// Variable to receive the profile parameters from MyAccountsPage.
  final ProfileParameters profileParameters;
  /// Receive parameters from MyAccountsPage.
  citySelectionState(this.profileParameters);
  /// Variable to store city index in list from profileParameters. Variable not used at the moment.
  int indice;
  /// Variable to view the "Ritorna" button. At the first time it is set to false.
  /// It changes when user want to modify his home city, after he as send the new city selected.
  bool boolVisualizza = false;
  /// Variable not used at the moment.
  bool boolInserito = false;
  /// Variable to view the "Ritorna" button. At the first time it is set to false.
  /// It changes when user want only to add a city of interest, after he has added the first city.
  bool boolRitorna = false;
  /// Variable to view the button "Aggiungi comune di interesse".
  /// Button shown only after sending a selected city.
  bool boolAggiungi = false;
  /// Variable to communicate to server that the city to add is the home city.
  bool boolSend = false;

  /// Method to send the request for adding a city, or modifying a city home, to the server.
  void sendComune() async {
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${token}'
    };
    var request = http.Request('PATCH',
        Uri.parse('http://ingsw2020server.herokuapp.com/users/me/comuni'));
    request.body = '''{
                  "diResidenza": ${boolSend},
                  "comuneCancella": "${profileParameters.comuneCancella}",
                  "comuneAggiungi": "${comune}"
                }''';
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(response.statusCode);
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            height: 600,
            child: Column(
              children: [
                Text(
                  'Seleziona un comune',
                  style: TextStyle(fontSize: 24),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                  child: Divider(
                    color: Colors.blue,
                  ),
                ),

                ///Adding CSC Picker Widget in app
                CSCPicker(
                  ///Enable disable state dropdown [OPTIONAL PARAMETER]
                  showStates: true,

                  /// Enable disable city drop down [OPTIONAL PARAMETER]
                  showCities: true,

                  ///Enable (get flag with country name) / Disable (Disable flag) / ShowInDropdownOnly (display flag in dropdown only) [OPTIONAL PARAMETER]
                  flagState: CountryFlag.DISABLE,

                  ///Dropdown box decoration to style your dropdown selector [OPTIONAL PARAMETER] (USE with disabledDropdownDecoration)
                  dropdownDecoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Colors.white,
                      border:
                          Border.all(color: Colors.grey.shade300, width: 1)),

                  ///Disabled Dropdown box decoration to style your dropdown selector [OPTIONAL PARAMETER]  (USE with disabled dropdownDecoration)
                  disabledDropdownDecoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Colors.grey.shade300,
                      border:
                          Border.all(color: Colors.grey.shade300, width: 1)),

                  ///Default Country
                  defaultCountry: DefaultCountry.Italy,

                  ///selected item style [OPTIONAL PARAMETER]
                  selectedItemStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                  ),

                  ///DropdownDialog Heading style [OPTIONAL PARAMETER]
                  dropdownHeadingStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 17,
                      fontWeight: FontWeight.bold),

                  ///DropdownDialog Item style [OPTIONAL PARAMETER]
                  dropdownItemStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                  ),

                  ///Dialog box radius [OPTIONAL PARAMETER]
                  dropdownDialogRadius: 10.0,

                  ///Search bar radius [OPTIONAL PARAMETER]
                  searchBarRadius: 10.0,

                  ///triggers once country selected in dropdown
                  onCountryChanged: (value) {
                    setState(() {
                      ///store value in country variable
                      countryValue = value;
                    });
                  },

                  ///triggers once state selected in dropdown
                  onStateChanged: (value) {
                    setState(() {
                      ///store value in state variable
                      stateValue = value;
                    });
                  },

                  ///triggers once city selected in dropdown
                  onCityChanged: (value) {
                    setState(() {
                      ///store value in city variable
                      cityValue = value;
                    });
                  },
                ),
                if (!boolVisualizza && !boolRitorna | !boolAggiungi)

                  ///print newly selected country state and city in Text Widget
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: RaisedButton(
                        textColor: Colors.white,
                        color: Colors.blueGrey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        onPressed: () {
                          setState(() {
                            comune = "$cityValue";
                            indice = profileParameters.indice;
                            if (profileParameters.modifica == 1) {
                              boolVisualizza = true;
                              boolSend = true;
                            }
                            if (profileParameters.modifica == 2) {
                              boolRitorna = true;
                              boolAggiungi = true;
                            }
                            if (profileParameters.aggiungi) {
                              boolAggiungi = true;
                            }
                          });
                          sendComune();
                        },
                        child: Text("Conferma")),
                  ),
                SizedBox(height: 20),
                if (boolVisualizza | boolRitorna | boolAggiungi)
                  Text(comune + " inserito!"),

                if (boolVisualizza | boolAggiungi | boolRitorna)

                  ///print newly selected country state and city in Text Widget
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: RaisedButton(
                        textColor: Colors.white,
                        color: Colors.blueGrey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        onPressed: () {
                          setState(() {
                            indice = profileParameters.indice + 1;
                            boolVisualizza = false;
                            boolAggiungi = false;
                            boolRitorna = false;
                            profileParameters.modifica = 2;
                            boolSend = false;
                          });
                        },
                        child: Text("Aggiungi comune di interesse")),
                  ),
                if (boolVisualizza | boolRitorna)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SideBarLayout()));
                        },
                        child: Text(
                          "Ritorna al profilo",
                          style: TextStyle(
                              color: Colors.white,
                              backgroundColor: Colors.blueGrey),
                        )),
                  ),
              ],
            )),
      ),
    );
  }
}


/// Screen to select a city.
/// {@category userProfile}
class citySelection extends StatefulWidget {
  final ProfileParameters profileParameters;

  const citySelection({Key key, this.profileParameters}) : super(key: key);

  @override
  citySelectionState createState() => citySelectionState(profileParameters);
}
