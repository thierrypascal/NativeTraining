import 'package:flutter/material.dart';
import 'package:native_training/components/drawer.dart';
import 'package:native_training/components/information_object_list_widget.dart';
import 'package:native_training/models/user.dart';
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Neues Training',
        child: Icon(Icons.add),
      ),
    );
  }
}
