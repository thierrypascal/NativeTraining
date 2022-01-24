import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart';
import 'package:native_training/components/drawer.dart';
import 'package:native_training/components/information_object_list_widget.dart';
import 'package:native_training/components/show_exercise_dialog.dart';
import 'package:native_training/components/show_workout_dialog.dart';
import 'package:native_training/models/exercise.dart';
import 'package:native_training/models/workout.dart';
import 'package:native_training/services/service_provider.dart';

class PlayWorkout extends StatefulWidget {
  PlayWorkout(this.workout, {Key key}) : super(key: key);

  final Workout workout;

  @override
  _PlayWorkoutState createState() => _PlayWorkoutState();
}

class _PlayWorkoutState extends State<PlayWorkout> {
  PageController controller = PageController();
  List<Exercise> allExercises = [];

  @override
  void initState() {
    // TODO: implement initState
    allExercises.addAll(widget.workout.warmupExercises);
    allExercises.addAll(widget.workout.workoutExercises);
    allExercises.addAll(widget.workout.cooldownExercises);
    super.initState();
  }

  // SharedAxisTransitionType _transitionType = SharedAxisTransitionType.vertical;

  // PageTransitionSwitcher(
  // duration: const Duration(milliseconds: 300),
  // reverse: !_isLoggedIn,
  // transitionBuilder: (
  // Widget child,
  //     Animation<double> animation,
  // Animation<double> secondaryAnimation,
  // ) {
  // return SharedAxisTransition(
  // child: child,
  // animation: animation,
  // secondaryAnimation: secondaryAnimation,
  // transitionType: _transitionType,
  // );
  // },
  // child: _isLoggedIn ? _CoursePage() : _SignInPage(),
  // ),

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      drawer: MyDrawer(),
      appBar: AppBar(
        title: Text(widget.workout.title),
      ),
      body: PageView(
        scrollDirection: Axis.vertical,
        controller: controller,
        children: [
          Text("P1"),
          Text("P2"),
        ],
      )
    );
  }
}
