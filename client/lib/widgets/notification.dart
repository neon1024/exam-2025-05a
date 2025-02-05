// ignore_for_file: library_private_types_in_public_api

import 'dart:convert';
import 'package:logger/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../models/workout.dart';
import 'message.dart';


const String wsUrl = 'ws://localhost:2505';

class DataNotification extends StatefulWidget {
  const DataNotification({super.key});

  @override
  _DataNotificationState createState() => _DataNotificationState();
}

class _DataNotificationState extends State<DataNotification> {
  late WebSocketChannel _channel;
  static Logger logger = Logger();

  @override
  void initState() {
    super.initState();
    _connectToWebSocket();
  }

  void _connectToWebSocket() {
    _channel = WebSocketChannel.connect(Uri.parse(wsUrl));
    _channel.stream.listen((data) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        var workout = Workout.fromJSON(jsonDecode(data.toString()));
        logger.log(Level.info, "DataNotification: $workout");
        message(context, workout.toString(), "Data added");
      });
    }, onDone: () {
      _reconnectToWebSocket();
    }, onError: (error) {
      logger.e("WebSocket error: $error");
      _reconnectToWebSocket();
    });
  }

  void _reconnectToWebSocket() {
    Future.delayed(const Duration(seconds: 10), () {
      _connectToWebSocket();
    });
  }

  @override
  void dispose() {
    _channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Text('');
  }
}
