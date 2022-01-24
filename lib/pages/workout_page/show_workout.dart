import 'package:flutter/material.dart';
import 'package:native_training/components/information_object_list_widget.dart';
import 'package:native_training/components/show_exercise_dialog.dart';
import 'package:native_training/components/show_workout_dialog.dart';
import 'package:native_training/models/exercise.dart';
import 'package:native_training/models/workout.dart';
import 'package:native_training/pages/workout_page/play_workout.dart';
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
      needsInset: false,
      workout: widget.workout,
      title: widget.workout.title,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      child: Text("Training starten"),
                      style: ButtonStyle(
                        visualDensity: VisualDensity.adaptivePlatformDensity,
                      ),
                      onPressed: () {
                        Navigator.push(
                            context, MaterialPageRoute(builder: (context) => PlayWorkout(widget.workout)));
                      },
                    ),
                  ),
                ],
              ),
            ),
            Padding(padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0) ,child: Align(alignment: Alignment.centerLeft, child: Text(widget.workout.description))),
            if (widget.workout.warmupExercises.isNotEmpty)
              InformationObjectListWidget(
                false,
                key: UniqueKey(),
                objects: widget.workout.warmupExercises,
              ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Divider(
                thickness: 2,
                color: Colors.green,
              ),
            ),
            if (widget.workout.workoutExercises.isNotEmpty)
              InformationObjectListWidget(
                false,
                key: UniqueKey(),
                objects: widget.workout.workoutExercises,
              ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Divider(
                thickness: 2,
                color: Colors.deepOrange,
              ),
            ),
            if (widget.workout.cooldownExercises.isNotEmpty)
              InformationObjectListWidget(
                false,
                key: UniqueKey(),
                objects: widget.workout.cooldownExercises,
              ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Divider(
                thickness: 2,
                color: Colors.deepPurple,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
