import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:native_training/components/drawer.dart';
import 'package:native_training/components/information_object_list_widget.dart';
import 'package:native_training/models/user.dart';
import 'package:native_training/pages/exercise_page/edit_exercise.dart';
import 'package:native_training/pages/workout_page/edit_workout.dart';
import 'package:native_training/services/service_provider.dart';
import 'package:provider/provider.dart';

///Displays a list of the users workouts
class MyWorkoutPage extends StatelessWidget {
  MyWorkoutPage({Key key}) : super (key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Meine Trainings")),
      drawer: MyDrawer(),
      body: InformationObjectListWidget(
        objects: ServiceProvider.instance.workoutService
            .getAllWorkoutsFromUser(user),
      ),
      floatingActionButton: OpenContainer(
        closedColor: Theme.of(context).primaryColor,
        transitionDuration: Duration(milliseconds: 500),
        closedBuilder: (BuildContext c, VoidCallback action) {
          return SizedBox(
            height: 56,
            width: 56,
            child: Center(
              //TODO: use theme color
              child: Icon(Icons.add, color: Colors.white),
            ),
          );
        },
        openBuilder: (BuildContext c, VoidCallback action) => EditWorkout(isEdit: false),
        closedElevation: 6.0,
        closedShape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(56 / 2),
          ),
        ),
      ),
    );
  }
}
