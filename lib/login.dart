import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  final userController = TextEditingController();
  final pswController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Login'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
                child: Column(
              children: <Widget>[
                Icon(
                  Icons.account_circle,
                  size: 64,
                ),
                TextField(
                  decoration: InputDecoration(labelText: "Username"),
                  controller: userController,
                ),
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(labelText: "Password"),
                  controller: pswController,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Esecuzione login
                        var loginResult =
                            login(userController.text, pswController.text)
                                .then((value) => 0);
                        print(loginResult);
                      },
                      child: Text('Login'),
                    ),
                  ),
                ),
              ],
            )),
          ),
        ),
      ),
    );
  }

  Future<int> login(String username, String psw) async {
    print(username + " " + psw);
    return 0;
  }
}
