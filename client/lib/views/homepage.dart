import 'package:client/views/user_section.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../widgets/message.dart';
import '../widgets/notification.dart';
import 'main_section.dart';


const String wsUrl = 'ws://localhost:2505';

class Homepage extends StatefulWidget {
  final String _title;
  const Homepage(this._title, {super.key});

  @override
  State<StatefulWidget> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final channel = WebSocketChannel.connect(Uri.parse(wsUrl));
  var logger = Logger();
  bool online = true;
  String string = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget._title),
      ),
      body: Center(
        child: ListView(
          children: [
            online ? const DataNotification() : Container(),
            ElevatedButton(
                onPressed: () {
                  if (!online) {
                    message(context, "No internet connection", "Info");
                    return;
                  }
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const TrainerSection()));
                },
                child: const Text('Trainer Section')),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const UserSection()));
                },
                child: const Text('User Section')),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
