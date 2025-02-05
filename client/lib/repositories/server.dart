import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../models/workout.dart';


const String baseUrl = 'http://localhost:2505';

class ServerRepository {
  static final ServerRepository instance = ServerRepository._init();
  static final Dio dio = Dio();
  var logger = Logger();

  ServerRepository._init();

  Future<List<Workout>> getWorkouts() async {
    logger.log(Level.info, "getWorkouts() called");
    final response = await dio.get('$baseUrl/workouts');
    logger.log(Level.info, "getWorkouts() response: $response");
    if (response.statusCode == 200) {
      return (response.data as List)
          .map((e) => Workout.fromJSON(e))
          .toList();
    } else {
      logger.log(Level.error, "getWorkouts() error: ${response.statusMessage}");
      throw Exception(response.statusMessage);
    }
  }

  // TODO get workout

  Future<Workout> addWorkout(Workout workout) async {
    logger.log(Level.info, "addWorkout() called");
    final response = await dio.post('$baseUrl/workouts', data: workout.toJsonWithoutId());
    logger.log(Level.info, "addWorkout() response: $response");
    if (response.statusCode == 200) {
      return Workout.fromJSON(response.data);
    } else {
      logger.log(Level.error, "addWorkout() error: ${response.statusMessage}");
      throw Exception(response.statusMessage);
    }
  }

// TODO delete workout

// TODO get all workouts
}
