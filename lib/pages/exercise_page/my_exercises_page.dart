import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:native_training/components/drawer.dart';
import 'package:native_training/components/information_object_list_widget.dart';
import 'package:native_training/models/user.dart';
import 'package:native_training/pages/exercise_page/edit_exercise_page.dart';
import 'package:native_training/services/service_provider.dart';
import 'package:provider/provider.dart';

///Displays a list of the users exercises
class MyExercisePage extends StatelessWidget {
  MyExercisePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    final exerciseService = ServiceProvider.instance.exerciseService;

    return Scaffold(
      key: UniqueKey(),
      appBar: AppBar(title: const Text('Meine \u00DCbungen')),
      drawer: MyDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            InformationObjectListWidget(
              false,
              objects: exerciseService.getAllExercisesFromUserOfType(user, 0),
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
            InformationObjectListWidget(
              false,
              objects: exerciseService.getAllExercisesFromUserOfType(user, 1),
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
            InformationObjectListWidget(
              false,
              objects: exerciseService.getAllExercisesFromUserOfType(user, 2),
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
            InformationObjectListWidget(
              false,
              objects: exerciseService.getAllExercisesFromUserOfType(user, 3),
            ),
          ],
        ),
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
        openBuilder: (BuildContext c, VoidCallback action) => EditExercisePage(
          isEdit: false,
          route: MyExercisePage(),
        ),
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
