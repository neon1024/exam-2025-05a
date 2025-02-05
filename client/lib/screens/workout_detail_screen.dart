import 'package:flutter/material.dart';
import '../models/workout.dart';


class WorkoutDetailScreen extends StatelessWidget {
  final Workout workout;

  const WorkoutDetailScreen({super.key, required this.workout});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ID: ${workout.id}'),
            Text('Name: ${workout.name}'),
            Text('Trainer: \$${workout.trainer}'),
            Text('Description: ${workout.description}'),
            Text('Status: ${workout.status}'),
            Text('Participants: ${workout.participants}'),
            Text('Type: ${workout.type}'),
            Text('Duration: ${workout.duration}'),
          ],
        ),
      ),
    );
  }
}
