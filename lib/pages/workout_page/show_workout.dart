import 'package:flutter/material.dart';
import 'package:native_training/components/show_exercise_dialog.dart';
import 'package:native_training/components/show_workout_dialog.dart';
import 'package:native_training/models/exercise.dart';
import 'package:native_training/models/workout.dart';
import 'package:native_training/services/service_provider.dart';

class ShowWorkout extends StatefulWidget {
  ShowWorkout(this.workout, {Key key}) : super(key: key);

  final Workout workout;

  @override
  _ShowWorkoutState createState() => _ShowWorkoutState();
}

class _ShowWorkoutState extends State<ShowWorkout> {
  @override
  Widget build(BuildContext context) {
    return ShowWorkoutDialog(
      workout: widget.workout,
      title: widget.workout.title,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
          child: Column(
            children: [
              Text("- WIP -"),
              Text("Title: " + widget.workout.title),
              Text("Description: " + widget.workout.description),
            ],
          ),
        ),
      ),
    );
  }
}
