// ignore_for_file: library_private_types_in_public_api, must_be_immutable

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import '../models/workout.dart';
import '../services/data.dart';
import '../widgets/message.dart';


class UserSection extends StatefulWidget {
  const UserSection({super.key});

  @override
  _MainSectionState createState() => _MainSectionState();
}

class _MainSectionState extends State<UserSection> {
  var logger = Logger();
  bool online = true;
  bool isLoading = false;
  String string = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Section'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Text("Workouts In Progress", style: TextStyle(fontSize: 20)),
            Element(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class Element extends StatelessWidget {
  var logger = Logger();
  bool online = true;
  bool isLoading = false;
  String string = '';

  Element({super.key});
  @override
  Widget build(BuildContext context) {
    final dataService = Provider.of<DataService>(context);
    // connection();
    return Column(
      children: [
        FutureBuilder<List<Workout>>(
          future: dataService.getWorkouts(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              final dataAttributes = snapshot.data?.where((data) => data.status == "in progress");
              return Padding(
                padding: const EdgeInsets.all(25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (var data in dataAttributes!)
                      ListTile(
                        title: Text(data.name),
                        subtitle: Text("Status: ${data.status}\nDuration: ${data.duration}\nParticipants: ${data.participants}"),
                        onTap: () {
                          if (online) {
                            message(context, "Online", "Info");
                          } else {
                            message(context, "Reservation is available only when online", "Error");
                          }
                        },
                      ),
                  ],
                ),
              );
            }
          },
        )
      ],
    );
  }
}
