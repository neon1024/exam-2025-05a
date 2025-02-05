class Workout {
  final int? id;
  final String name;
  final String trainer;
  final String description;
  final String status;
  final int participants;
  final String type;
  final int duration;

  const Workout({
    this.id,
    required this.name,
    required this.trainer,
    required this.description,
    required this.status,
    required this.participants,
    required this.type,
    required this.duration,
    });

  factory Workout.fromJSON(Map<String, dynamic> json) {
    return switch(json) {
      {
      "id": int id,
      "name": String name,
      "trainer": String trainer,
      "description": String description,
      "status": String status,
      "participants": int participants,
      "type": String type,
      "duration": int duration
      } =>
          Workout(
              id: id,
              name: name,
              trainer: trainer,
              description: description,
              status: status,
              participants: participants,
              type: type,
              duration: duration
          ),
      _ => throw const FormatException("Failed to load workout.")
    };
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "trainer": trainer,
      "description": description,
      "status": status,
      "participants": participants,
      "type": type,
      "duration": duration
    };
  }

  Map<String, dynamic> toJsonWithoutId() {
    return {
      "name": name,
      "trainer": trainer,
      "description": description,
      "status": status,
      "participants": participants,
      "type": type,
      "duration": duration
    };
  }

  Workout copy({
    int? id,
    String? name,
    String? trainer,
    String? description,
    String? status,
    int? participants,
    String? type,
    int? duration
  }) {
    return Workout(
      id: id ?? this.id,
      name: name ?? this.name,
      trainer: trainer ?? this.trainer,
      description: description ?? this.description,
      status: status ?? this.status,
      participants: participants ?? this.participants,
      type: type ?? this.type,
      duration: duration ?? this.duration,
    );
  }

  @override
  String toString() {
    return "Workout | id: $id, name: $name, trainer: $trainer, description: $description, status: $status, participants: $participants, type: $type, duration: $duration";
  }
}
