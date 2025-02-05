import 'package:logger/logger.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import '../models/workout.dart';


class DatabaseRepository {
  static const int _version = 1;
  static const String _name = 'Workouts.db';
  static Logger logger = Logger();

  Future<sqflite.Database> _getDB() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = join(directory.path, _name);
    return await sqflite.openDatabase(path, version: _version,
        onCreate: (db, version) async {
          await db.execute('''
            CREATE TABLE workouts (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              name TEXT NOT NULL,
              trainer TEXT,
              description TEXT,
              status TEXT,
              participants INTEGER,
              type TEXT,
              duration INTEGER
            )
          ''');
        });
  }

  Future<List<Workout>> getWorkouts() async {
    final db = await _getDB();
    final result = await db.query('workouts');
    logger.log(Level.info, "getWorkouts() result: $result");
    return result.map((e) => Workout.fromJSON(e)).toList();
  }

  Future<Workout> addWorkout(Workout workout) async {
    final db = await _getDB();
    final id = await db.insert('workouts', workout.toJsonWithoutId(), conflictAlgorithm: sqflite.ConflictAlgorithm.replace);
    logger.log(Level.info, "addWorkout() id: $id");
    return workout.copy(id: id);
  }

  Future<void> updateWorkouts(List<Workout> workouts) async {
    var db = await _getDB();
    await db.delete('workouts');
    for (var workout in workouts) {
      await db.insert('workouts', workout.toJsonWithoutId());
    }
    logger.log(Level.info, "updateWorkouts() result: $workouts");
  }

  Future<void> close() async {
    final db = await _getDB();
    await db.close();
  }
}
