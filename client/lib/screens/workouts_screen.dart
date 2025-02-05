import 'package:client/screens/workout_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import '../models/workout.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class WorkoutsScreen extends StatefulWidget {
  const WorkoutsScreen({super.key});

  @override
  State<StatefulWidget> createState() => _WorkoutsScreenState();
}

class _WorkoutsScreenState extends State<WorkoutsScreen> {
  List<Workout> _workouts = [];
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _fetchWorkouts();
    _connectWebSocket();
  }

  Future<void> _fetchWorkouts() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final response = await http.get(Uri.parse('http://localhost:2505/workouts'));

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        setState(() {
          _workouts = jsonList.map((json) => Workout.fromJSON(json)).toList();
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load transactions');
      }
    } catch (error) {
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
    }
  }

  void _connectWebSocket() {
    var channel = IOWebSocketChannel.connect('ws://localhost:2505');
    channel.stream.listen((message) {
      final newWorkout = Workout.fromJSON(jsonDecode(message));
      setState(() {
        _workouts.add(newWorkout);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('New workout added: ${newWorkout.name}')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workouts'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _hasError
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Failed to load workouts'),
            ElevatedButton(
              onPressed: _fetchWorkouts,
              child: const Text('Retry'),
            ),
          ],
        ),
      )
          : ListView.builder(
        itemCount: _workouts.length,
        itemBuilder: (context, index) {
          final workout = _workouts[index];
          return ListTile(
            title: Text(workout.name),
            subtitle: Text('${workout.type} - \$${workout.duration}'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WorkoutDetailScreen(workout: workout),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
