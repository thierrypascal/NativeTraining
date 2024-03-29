import 'package:flutter/material.dart';
import 'package:native_training/components/information_object_list_widget.dart';
import 'package:native_training/components/show_workout_dialog.dart';
import 'package:native_training/models/workout.dart';
import 'package:native_training/pages/workout_page/play_workout_page.dart';
import 'package:native_training/services/service_provider.dart';

class ShowWorkoutPage extends StatefulWidget {
  ShowWorkoutPage(this.workout, {Key key}) : super(key: key);

  final Workout workout;

  @override
  _ShowWorkoutPageState createState() => _ShowWorkoutPageState();
}

class _ShowWorkoutPageState extends State<ShowWorkoutPage> {
  final exerciseService = ServiceProvider.instance.exerciseService;

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
                            context, MaterialPageRoute(builder: (context) => PlayWorkoutPage(widget.workout)));
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
                objects: exerciseService.getWorkoutExercises(widget.workout.warmupExercises),
              ),
            Stack(alignment: Alignment.topRight, children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 10),
                child: Divider(
                  thickness: 2,
                  color: Colors.green,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Text("Aufw\u00E4rmen"),
              ),
            ]),
            if (widget.workout.workoutExercises.isNotEmpty)
              InformationObjectListWidget(
                false,
                key: UniqueKey(),
                objects: exerciseService.getWorkoutExercises(widget.workout.workoutExercises),
              ),
            Stack(
              alignment: Alignment.topRight,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 10),
                  child: Divider(
                    thickness: 2,
                    color: Colors.deepOrange,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Text("Training"),
                ),
              ],
            ),
            if (widget.workout.cooldownExercises.isNotEmpty)
              InformationObjectListWidget(
                false,
                key: UniqueKey(),
                objects: exerciseService.getWorkoutExercises(widget.workout.cooldownExercises),
              ),
            Stack(
              alignment: Alignment.topRight,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 10),
                  child: Divider(
                    thickness: 2,
                    color: Colors.deepPurple,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Text("Dehnen"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
