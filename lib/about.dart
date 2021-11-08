import 'package:flutter/material.dart';

class About extends StatelessWidget {
  const About({Key? key, required this.name}) : super(key: key);
  final String name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          centerTitle: true,
          title: Text('Info'),
          titleTextStyle: const TextStyle(
              color: Colors.black,
              fontSize: 30,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.bold),
        ),
        body: ListView(children: [
          SizedBox(height: 10),
          Container(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('About',
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 30,
                      fontWeight: FontWeight.bold)),
            ],
          )),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            child: Container(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    'This app is a social media where you can view and create posts. You are able to connect with people and read the updates that are posted by them. ',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ),
              ],
            )),
          )
        ]));
  }
}
