import 'package:flutter/material.dart';
import 'package:native_training/components/drawer.dart';
import 'package:native_training/components/information_object_list_widget.dart';
import 'package:native_training/models/user.dart';
import 'package:native_training/pages/exercise_page/edit_exercise.dart';
import 'package:native_training/services/service_provider.dart';
import 'package:provider/provider.dart';

///Displays a list of the users exercises
class MyExercisePage extends StatelessWidget {
  MyExercisePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Meine \u00DCbungen')),
      drawer: MyDrawer(),
      body: Column(
        children: <Widget> [
          InformationObjectListWidget(
            objects: ServiceProvider.instance.exerciseService
                .getAllExercisesFromUserOfType(user, 0),
          ),
          InformationObjectListWidget(
            objects: ServiceProvider.instance.exerciseService
                .getAllExercisesFromUserOfType(user, 1),
          ),
          InformationObjectListWidget(
            objects: ServiceProvider.instance.exerciseService
                .getAllExercisesFromUserOfType(user, 2),
          ),
          InformationObjectListWidget(
            objects: ServiceProvider.instance.exerciseService
                .getAllExercisesFromUserOfType(user, 3),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EditExercise(
                    isEdit: false,
                        route: MyExercisePage(),
                      )));
        },
        tooltip: 'Neue \u00DCbung',
        child: Icon(Icons.add),
      ),
    );
  }
}
