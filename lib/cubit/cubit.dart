import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;

class MainCubit extends Cubit<String> {
  MainCubit() : super('');
  final channel =
      IOWebSocketChannel.connect('ws://besquare-demo.herokuapp.com');

  void openChannel() {
    channel.stream.listen((message) {
      final decodedMessage = jsonDecode(message);

      print(decodedMessage);
      channel.sink.close();
    });
  }

  void login(name) {
    channel.sink.add('{"type": "sign_in","data": {"name": "$name"}}');
    emit(name);
  }

  void createPost(title, description, image) {
    channel.sink.add(
        '{"type": "create_post","data": {"title": "$title", "description": "$description","image": "$image"}}');
  }
}
