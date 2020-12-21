import 'package:http/http.dart' as http;
import 'dart:convert';

class serverConnection{

  ///Funzione getAllEvents che ritorna tutti gli eventi nel server, ritorna
  ///una String [returnString] con tutti gli eventi
  static Future<String> getAllEvents() async {
    String returnString = '';
    var request = http.Request('GET',
        Uri.parse('https://ingsw2020server.herokuapp.com/events/eventList'));
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    }
    else {
      returnString = response.reasonPhrase;
    }
    return returnString;
  }

  ///Funzione getEventByID, riceve [eventID] dall'utente per poi ritornare una
  ///String [returnString] con i dettagli dell'evento
  ///
  /// TODO Cercare anche tramite titolo
  static Future<String> getEventByID(String eventID) async{
    String returnString = '';
    String requestHTTP = 'https://ingsw2020server.herokuapp.com/events/' + eventID;
    var request = http.Request('GET', Uri.parse(requestHTTP));
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    }
    else {
      returnString = response.reasonPhrase;
    }
    return returnString;
  }

  ///Funzione addEvent, prende le informazioni dell'evento [comune], [titolo],
  ///[descrizione] e [data] per poi aggiungerle al server. Stampa 'OK' oppure
  ///'Errore' diependentemente dal server
  ///
  ///TODO Non e' possibile usare json encode e la string json viene generata manualmente, in  bad practice
  ///TODO Da aggiungere la possibilita' dell'orario nella data
  static addEvent(String comune, String titolo, String descrizione, String data) async {
    /*
    Map dati = {
      'comune': comune,
      'titoloEvento': titolo,
      'descrizione': descrizione,
      'data': data
    };
    String body = json.encode(dati);
    */

    var headers = {
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST',
        Uri.parse('https://ingsw2020server.herokuapp.com/events/'));
    String requestString =
        '{\r\n    "comune": ' + '"' + comune + '"' + ',' +
            '\r\n    "titoloEvento": ' + '"' + titolo + '"' + ',' +
            '\r\n    "descrizione": ' + '"' + descrizione + '"' + ',' +
            '\r\n    "data": ' + '"' + data + '"' + '\r\n}';
    request.body = requestString;
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 201) {
      print(await response.stream.bytesToString());
      print('OK');
    }
    else {
      print(response.reasonPhrase);
      print('Errore');
    }
  }
}