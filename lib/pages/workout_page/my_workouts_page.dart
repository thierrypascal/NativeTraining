import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:native_training/components/drawer.dart';
import 'package:native_training/components/information_object_list_widget.dart';
import 'package:native_training/models/user.dart';
import 'package:native_training/pages/workout_page/edit_workout_page.dart';
import 'package:native_training/services/service_provider.dart';
import 'package:provider/provider.dart';

///Displays a list of the users workouts
class MyWorkoutPage extends StatefulWidget {
  MyWorkoutPage({Key key}) : super(key: key);

  @override
  State<MyWorkoutPage> createState() => _MyWorkoutPageState();
}

class _MyWorkoutPageState extends State<MyWorkoutPage> {
  @override
  void initState() {
    _uglySetState();

    super.initState();
  }

  _uglySetState() {
    //very ugly method to "reload" as soon as objects has loaded
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {});
      } else {
        //if !mounted, wait again 500ms and try again
        _uglySetState();
      }
    });
  }

  //TODO: Nach registrieren kann beim erstenmal keine Workouts/Exercises angezeigt werden. Nach erneutem Starten der App geht es, hot reload reicht nicht aus

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    final objects = ServiceProvider.instance.workoutService.getAllWorkoutsFromUser(user);

    return Scaffold(
      key: UniqueKey(),
      appBar: AppBar(title: const Text("Meine Trainings")),
      drawer: MyDrawer(),
      body: InformationObjectListWidget(
        false,
        objects: objects,
        isWorkout: true,
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
        openBuilder: (BuildContext c, VoidCallback action) => EditWorkoutPage(isEdit: false),
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
