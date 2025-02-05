// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import '../models/workout.dart';
import '../widgets/text_box.dart';
import '../services/data.dart';
import '../widgets/message.dart';


class AddData extends StatefulWidget {
  const AddData({super.key});

  @override
  State<StatefulWidget> createState() => _AddDataState();
}

class _AddDataState extends State<AddData> {
  var logger = Logger();
  late TextEditingController nameController;
  late TextEditingController trainerController;
  late TextEditingController descriptionController;
  late TextEditingController statusController;
  late TextEditingController participantsController;
  late TextEditingController typeController;
  late TextEditingController durationController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    trainerController = TextEditingController();
    descriptionController = TextEditingController();
    statusController = TextEditingController();
    participantsController = TextEditingController();
    typeController = TextEditingController();
    durationController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final dataService = Provider.of<DataService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Data"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TextBox(nameController, 'Name'),
            TextBox(trainerController, 'Trainer'),
            TextBox(descriptionController, 'Description'),
            TextBox(statusController, 'Status'),
            TextBox(participantsController, 'Participants'),
            TextBox(typeController, 'Type'),
            TextBox(durationController, 'Duration'),
            ElevatedButton(
              onPressed: () async {
                String name = nameController.text;
                String? trainer = trainerController.text;
                String? description = descriptionController.text;
                String? status = statusController.text;
                int participants = int.tryParse(participantsController.text) != null ? int.parse(participantsController.text) : 1;
                String? type = typeController.text;
                int duration = int.tryParse(durationController.text) != null ? int.parse(durationController.text) : 1;

                if (name.isNotEmpty) {
                  final newWorkout = Workout(
                      name: name,
                      trainer: trainer,
                      description: description,
                      status: status,
                      participants: participants,
                      type: type,
                      duration: duration);
                  if (dataService.online) {
                    try {
                      await dataService.addWorkout(newWorkout);
                      nameController.clear();
                      trainerController.clear();
                      descriptionController.clear();
                      statusController.clear();
                      participantsController.clear();
                      typeController.clear();
                      durationController.clear();
                    } catch (e) {
                      message(context, "Error when adding data", "Error");
                      logger.e(e);
                    }
                  } else {
                    message(context, "Operation not available offline", "Error");
                  }
                } else {
                  // Add error messages for each field
                }
              },
              child: const Text("Save"),
            )
          ],
        ),
      ),
    );
  }
}
