import 'dart:ui';
import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:mobileproject/about.dart';
import 'package:mobileproject/post.dart';
import 'package:mobileproject/cubit/cubit.dart';
import 'cubit/cubit.dart';
import 'package:web_socket_channel/io.dart';
import 'package:mobileproject/details.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key, required this.name}) : super(key: key);
  final String name;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: BlocProvider(
      create: (context) => MainCubit(),
      child: Home(name: name),
    ));
  }
}

class Home extends StatefulWidget {
  const Home({Key? key, required this.name}) : super(key: key);
  final String name;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final channel =
      IOWebSocketChannel.connect('ws://besquare-demo.herokuapp.com');
  List post = [];
  bool sortType = true;

  List favourites = [];

  void getPost() {
    channel.stream.listen((posting) {
      final decodedMessage = jsonDecode(posting);

      setState(() {
        post = decodedMessage['data']['posts'];
      });
      print(post);
    });

    channel.sink.add('{"type": "get_posts"}');
  }

  void login() {
    channel.sink.add('{"type": "sign_in","data": {"name": "${widget.name}"}}');
  }

  void deletePost(_id) {
    channel.sink.add('{"type": "delete_post","data": {"postId": "$_id"}}');
  }

  void sorting() {
    if (sortType == true) {
      setState(() {
        post.sort((a, b) {
          var aDate = a['date'];
          var bDate = b['date'];
          return aDate.compareTo(bDate);
        });
        sortType = false;
      });
    } else if (sortType == false) {
      setState(() {
        post.sort((b, a) {
          var aDate = a['date'];
          var bDate = b['date'];
          return aDate.compareTo(bDate);
        });
        sortType = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getPost();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.red,
        centerTitle: true,
        title: Text('Home'),
        titleTextStyle: const TextStyle(
            color: Colors.black,
            fontSize: 30,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold),
      ),
      body: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                Container(
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.create),
                        onPressed: () {
                          Navigator.push(
                              this.context,
                              MaterialPageRoute(
                                  builder: (context) => PostPage(
                                        name: widget.name,
                                      )));
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.info),
                        onPressed: () {
                          Navigator.push(
                              this.context,
                              MaterialPageRoute(
                                  builder: (context) => About(
                                        name: widget.name,
                                      )));
                        },
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.sort),
                        onPressed: () {
                          sorting();
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.favorite),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
                // BlocBuilder<MainCubit, String>(
                //     bloc: context.read<MainCubit>(),
                //     builder: (context, state) {
                //       return
                Text(
                  'Username: ${widget.name}',
                  style: TextStyle(fontSize: 20),
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: post.length,
                      itemBuilder: (context, index) {
                        return Container(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PostDetails(
                                          title: post[index]['title'],
                                          description: post[index]
                                              ['description'],
                                          url: post[index]['image'],
                                          author: post[index]['author'],
                                          date: post[index]['date'])));
                            },
                            child: Card(
                                child: Row(
                              // mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                    child: Expanded(
                                  flex: 2,
                                  child: SizedBox(
                                      width: 60,
                                      height: 60,
                                      child: Image(
                                        image: NetworkImage(Uri.parse(
                                                    '${post[index]["image"]}')
                                                .isAbsolute
                                            ? '${post[index]["image"]}'
                                            : 'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'),
                                        fit: BoxFit.contain,
                                      )),
                                )),
                                Container(
                                  child: Expanded(
                                      flex: 4,
                                      child: Container(
                                        child: Column(children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  '${post[index]["title"]}',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 15),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 4),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  '${post[index]["description"]}',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 3,
                                                  style:
                                                      TextStyle(fontSize: 15),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 20),
                                          Row(
                                            children: [
                                              Text(
                                                '${post[index]["date"].toString().characters.take(10)}',
                                                style: TextStyle(fontSize: 15),
                                              ),
                                            ],
                                          ),
                                        ]),
                                      )),
                                ),
                                Container(
                                    child: Expanded(
                                  flex: 1,
                                  child: Column(
                                    children: [
                                      IconButton(
                                          icon: const Icon(Icons.delete),
                                          onPressed: widget.name ==
                                                  post[index]['author']
                                              ? () {
                                                  login();
                                                  deletePost(
                                                      post[index]['_id']);
                                                  Navigator.push(
                                                      this.context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              Home(
                                                                name:
                                                                    widget.name,
                                                              )));
                                                }
                                              : null),
                                      IconButton(
                                        icon: Icon(Icons.favorite),
                                        color: favourites.contains(post[index])
                                            ? Colors.red
                                            : Colors.grey,
                                        onPressed: () {
                                          if (favourites
                                              .contains(post[index])) {
                                            setState(() {
                                              favourites.remove(post[index]);
                                            });
                                          } else {
                                            setState(() {
                                              favourites.add(post[index]);
                                            });
                                          }
                                          print(favourites);
                                        },
                                      ),
                                    ],
                                  ),
                                )),
                              ],
                            )),
                          ),
                        );
                      }),
                ),
                // }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
