import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobileproject/cubit/cubit.dart';
import 'package:mobileproject/home.dart';
import 'cubit/cubit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Login UI',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: BlocProvider(
          create: (context) => MainCubit(),
          child: const LoginPage(),
        ));
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20);
  var textController = TextEditingController();
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String name = '';

  @override
  Widget build(BuildContext context) {
    final nameField = TextFormField(
      controller: textController,
      // obscureText: false,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: 'Username',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30))),
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your Name';
        }
        return null;
      },

      onChanged: (String? value) {
        setState(() {
          name = textController.text.toString();
        });
        print(textController.text.toString());
      },
    );

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          centerTitle: true,
          title: Text('Login'),
          titleTextStyle: TextStyle(
              color: Colors.black,
              fontSize: 30,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.bold),
        ),
        body: ListView(
          children: [
            BlocBuilder<MainCubit, String>(
                bloc: context.read<MainCubit>(),
                builder: (context, state) {
                  return Form(
                    key: _formKey,
                    child: Column(children: <Widget>[
                      Center(
                          child: Container(
                        padding: EdgeInsets.fromLTRB(20, 30, 20, 20),
                        child: Text('Welcome',
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 30,
                                fontWeight: FontWeight.bold)),
                      )),
                      SizedBox(
                        height: 155,
                        child: Image.asset(
                          "assets/besquare_logo.png",
                          fit: BoxFit.contain,
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                          padding: EdgeInsets.only(
                            top: 10,
                            left: 20,
                            right: 20,
                            bottom: 10,
                          ),
                          child: nameField),
                      SizedBox(height: 20),
                      Container(
                        padding: EdgeInsets.only(
                          left: 100,
                          right: 100,
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Colors.green, fixedSize: Size(100, 50)),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text('Logged In!'),
                              ));
                              context.read<MainCubit>().openChannel();
                              context.read<MainCubit>().login(name);
                              Navigator.push(
                                  this.context,
                                  MaterialPageRoute(
                                      builder: (context) => Home(name: name)));
                            }
                          },
                          child: Text("Login"),
                        ),
                      )
                    ]),
                  );
                })
          ],
        ));
  }
}
