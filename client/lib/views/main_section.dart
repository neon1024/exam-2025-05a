// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import '../models/workout.dart';
import '../services/data.dart';
import '../views/add_data.dart';
import '../widgets/message.dart';


class WorkoutsSection extends StatefulWidget {
  const WorkoutsSection({super.key});

  @override
  _WorkoutsSectionState createState() => _WorkoutsSectionState();
}

class _WorkoutsSectionState extends State<WorkoutsSection> {
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
        title: const Text('Employee Section'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(25.0),
        children: const [
          Element(),
          SizedBox(height: 20),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (online) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const AddData(),
              ),
            );
          } else {
            message(context, "Cannot add data while offline.", "Error");
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
  @override
  void dispose() {
    super.dispose();
  }
}

class Element extends StatelessWidget {
  const Element({super.key});

  @override
  Widget build(BuildContext context) {
    final dataService = Provider.of<DataService>(context);
    return FutureBuilder<List<Workout>>(
      future: dataService.getWorkouts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text('No data available.');
        } else {
          final allData = snapshot.data;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var data in allData!)
                ListTile(
                  title: Text(data.name),
                  subtitle: Text(
                    'Type: ${data.type}, Duration: ${data.duration}, Participants: ${data.participants}',
                  ),
                ),
            ],
          );
        }
      },
    );
  }
}
