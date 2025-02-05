import 'package:client/screens/workouts_screen.dart';
import 'package:flutter/material.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Navigate to the TransactionListScreen
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const WorkoutsScreen(),
              ),
            );
          },
          child: const Text('View Workouts'),
        ),
      ),
    );
  }
}
