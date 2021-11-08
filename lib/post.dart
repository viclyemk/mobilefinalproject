import 'dart:ui';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobileproject/cubit/cubit.dart';
import 'package:mobileproject/home.dart';
import 'cubit/cubit.dart';
import 'package:web_socket_channel/io.dart';

class PostPage extends StatelessWidget {
  const PostPage({Key? key, required this.name}) : super(key: key);
  final String name;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: BlocProvider(
      create: (context) => MainCubit(),
      child: Post(name: name),
    ));
  }
}

class Post extends StatefulWidget {
  const Post({Key? key, required this.name}) : super(key: key);
  final String name;

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
  // void createPost(title, description, image) {
  //   channel.stream.listen((message) {
  //     final decodedMessage = jsonDecode(message);

  //     print(decodedMessage);
  //   });
  //   channel.sink.add(
  //       '{"type": "create_post","data": {"title": $title, "description": $description,"image": $image}}');
  // }

  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20);
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var descriptionController = TextEditingController();
  var imageController = TextEditingController();
  String title = '';
  String description = '';
  String image = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        centerTitle: true,
        title: const Text('New'),
        titleTextStyle: const TextStyle(
            color: Colors.black,
            fontSize: 30,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold),
      ),
      body: BlocBuilder<MainCubit, String>(
          bloc: context.read<MainCubit>(),
          builder: (context, state) {
            return Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(height: 20),
                  const Text(
                    'Title:',
                    style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: titleController,
                      obscureText: false,
                      style: style,
                      decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.fromLTRB(20, 15, 20, 15),
                          hintText: 'Input Title',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15))),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a title';
                        }
                        return null;
                      },
                      onChanged: (String? value) {
                        setState(() {
                          title = titleController.text.toString();
                        });
                        print(titleController.text.toString());
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    'Description:',
                    style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: descriptionController,
                      obscureText: false,
                      style: style,
                      decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.fromLTRB(20, 15, 20, 15),
                          hintText: 'Input Description',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15))),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a description';
                        }
                        return null;
                      },
                      onChanged: (String? value) {
                        setState(() {
                          description = descriptionController.text.toString();
                        });
                        print(description);
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    'Image:',
                    style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: imageController,
                      obscureText: false,
                      style: style,
                      decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.fromLTRB(20, 15, 20, 15),
                          hintText: 'Input Image',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15))),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a url';
                        }
                        return null;
                      },
                      onChanged: (String? value) {
                        setState(() {
                          image = imageController.text.toString();
                        });
                        print(image);
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          style:
                              ElevatedButton.styleFrom(primary: Colors.green),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text('Created!'),
                              ));
                              context.read<MainCubit>().openChannel();
                              context.read<MainCubit>().login(widget.name);
                              context
                                  .read<MainCubit>()
                                  .createPost(title, description, image);
                              Navigator.push(
                                  this.context,
                                  MaterialPageRoute(
                                      builder: (context) => Home(
                                            name: widget.name,
                                          )));
                            }
                          },
                          // icon: Icon(Icons.add, size: 18),
                          child: Text("Create Post"),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          style:
                              ElevatedButton.styleFrom(primary: Colors.green),
                          onPressed: () {
                            Navigator.push(
                                this.context,
                                MaterialPageRoute(
                                    builder: (context) => Home(
                                          name: widget.name,
                                        )));
                          },
                          // icon: Icon(Icons.add, size: 18),
                          child: Text("Cancel"),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            );
          }),
    );
  }
}
