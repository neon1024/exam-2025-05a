import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '../models/workout.dart';
import '../repositories/database.dart';
import '../repositories/server.dart';


class DataService extends ChangeNotifier {
  final DatabaseRepository _dbRepo;
  final ServerRepository _serverRepo;
  bool online = true;
  static Logger logger = Logger();
  bool isLoading = false;
  String string = '';

  static Future<DataService> init() async {
    return DataService(DatabaseRepository(), ServerRepository.instance);
  }

  DataService(this._dbRepo, this._serverRepo);

  Future<List<Workout>> getWorkouts() async {
    try {
      List<Workout> workouts = [];
      if (online) {
        workouts = await _serverRepo.getWorkouts();
        await _dbRepo.updateWorkouts(workouts);
      } else {
        workouts = await _dbRepo.getWorkouts();
      }
      return workouts;
    } catch (e) {
      logger.e(e);
      return [];
    }
  }

  Future<List<Workout>> getWorkoutsSorted() async {
    try {
      List<Workout> workouts = [];
      if (online) {
        workouts = await _serverRepo.getWorkouts();
        await _dbRepo.updateWorkouts(workouts);
      } else {
        workouts = await _dbRepo.getWorkouts();
      }

      workouts.sort((a, b) {
        int participantsComparison = a.participants.compareTo(b.participants);
        if (participantsComparison != 0) {
          return participantsComparison;
        } else {
          return a.participants.compareTo(b.participants);
        }
      });

      return workouts;

    } catch (e) {
      logger.e(e);
      return [];
    }
  }

  Future<void> addWorkout(Workout workout) async {
    if (!online) {
      throw Exception("Operation not available offline");
    }
    try {
      var newWorkout = await _serverRepo.addWorkout(workout);
      await _dbRepo.addWorkout(workout);
      notifyListeners();
    } catch (e) {
      logger.e(e);
      throw Exception(e);
    }
  }
}
