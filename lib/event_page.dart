import 'package:flutter/material.dart';

import 'Event.dart';

class DetailedEvent extends StatelessWidget {
  final Event event;

  final List<String> imageSource = [
    "https://tedxcatania.com/wp-content/uploads/2018/10/tedx.jpg",
    "https://sviluppomanageriale.it/media/zoo/images/3-citta-sostenibile_ca730cbae17431898db2108b135ef01e.png",
    "https://www.lavocedinewyork.com/wp-content/uploads/2019/05/lens-3046269_1280-620x430.jpg",
    "https://cf.microninja.me/wp-content/uploads/2018/05/heart-1847868_1280-e1526479142409.png"
  ];

  // In the constructor, require a Todo.
  DetailedEvent({Key key, @required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dettagli evento"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: double.infinity,
            color: Colors.white,
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(16, 16, 0, 16),
                  width: double.infinity,
                  color: Colors.white,
                  child: Text(
                    event.title,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                  child: Image.network(imageSource[event.id]),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    '''${(event.description)}''',
                    softWrap: true,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Pagina precedente'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
