import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'notificationHandler.dart';

import '../signIn/signIn.dart';

Future<void> initNotificationService () async{
  String deviceToken = await FirebaseMessaging.instance.getToken();
  print("DeviceToken: " + deviceToken);
  await saveTokenToDatabase(deviceToken);
  FirebaseMessaging.instance.onTokenRefresh.listen(saveTokenToDatabase);

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    nh.scheduleNotification(message);
    print(message);
  });


}

Future<void> saveTokenToDatabase(String deviceToken) async {
  String userId = FirebaseAuth.instance.currentUser.uid;
  print("UserId" + userId);
  registerDevice(deviceToken);
}


void registerDevice(String deviceToken) async {

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${token}'
    };
    var request = http.Request('POST',
        Uri.parse('http://ingsw2020server.herokuapp.com/users/registerDevice'));
    request.body = '''{
                    "deviceToken": "${deviceToken}"
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