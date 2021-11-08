import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';

final channel = IOWebSocketChannel.connect('ws://besquare-demo.herokuapp.com');
List post = [];

class PostDetails extends StatelessWidget {
  const PostDetails(
      {Key? key,
      required this.title,
      required this.description,
      required this.url,
      required this.author,
      required this.date})
      : super(key: key);

  final String title;
  final String description;
  final String url;
  final String author;
  final String date;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          centerTitle: true,
          title: Text('View'),
          titleTextStyle: const TextStyle(
              color: Colors.black,
              fontSize: 30,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.bold),
        ),
        body: ListView(
          children: [
            SizedBox(height: 30),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(title,
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 30,
                            fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 200,
                    child: Image(
                      image: NetworkImage(Uri.parse(url).isAbsolute
                          ? url
                          : 'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'),
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: Container(
                child: Row(
                  children: [
                    Flexible(
                      child: Text(
                        description,
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: Container(
                child: Row(
                  children: [
                    Flexible(
                      child: Text('Author: $author',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 20,
                          )),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: Container(
                child: Row(
                  children: [
                    Flexible(
                      child: Text(
                          'Date Creation: ${date.toString().characters.take(10)}',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 20,
                          )),
                    ),
                  ],
                ),
              ),
            )
          ],
        ));
  }
}
