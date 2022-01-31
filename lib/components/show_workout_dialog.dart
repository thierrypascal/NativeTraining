import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:native_training/components/drawer.dart';
import 'package:native_training/models/user.dart';
import 'package:native_training/models/workout.dart';
import 'package:native_training/pages/workout_page/edit_workout_page.dart';
import 'package:native_training/pages/workout_page/my_workouts_page.dart';
import 'package:native_training/services/service_provider.dart';
import 'package:provider/provider.dart';

/// Simple class to display a dialog
class ShowWorkoutDialog extends StatefulWidget {
  ShowWorkoutDialog(
      {@required this.workout,
        @required this.title,
        @required this.body,
        this.needsInset = true,
        Key key})
      : super(key: key);

  final Workout workout;
  final String title;
  final Widget body;
  final bool needsInset;

  @override
  _ShowWorkoutDialogState createState() => _ShowWorkoutDialogState();
}

class _ShowWorkoutDialogState extends State<ShowWorkoutDialog> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
          title: Text(widget.title),
        actions: <Widget>[
          PopupMenuButton(
            itemBuilder: (bc) => [
              PopupMenuItem(
                value: 'EditWorkout',
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Icon(
                        Icons.edit,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const Text('Training bearbeiten')
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'DeleteWorkout',
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Icon(
                        Icons.delete_forever,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const Text('Training l\u00F6schen')
                  ],
                ),
              ),
            ],
            onSelected: _handleTopMenu,
          ),
        ],
      ),
      body: Container(
        child: Padding(
          padding: widget.needsInset ? const EdgeInsets.fromLTRB(40, 10, 8, 8) : const EdgeInsets.fromLTRB(8, 10, 8, 8),
          child: Card(
            elevation: 5,
            child: Column(
              children: [
                Expanded(
                  child: widget.body,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 15.0,
                    right: 15,
                    bottom: 10,
                  ),
                  child: Row(
                    children: [
                      ElevatedButton.icon(
                        label: Text('Zur\u00FCck'),
                        icon: Icon(Icons.arrow_back),
                        style: ButtonStyle(
                            visualDensity: VisualDensity.adaptivePlatformDensity),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ///Handles the decision where to route to
  void _handleTopMenu(String value) {
    switch (value) {
      case 'EditWorkout':
        {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => (EditWorkoutPage(isEdit: true, workout: widget.workout,))));
          break;
        }
      case 'DeleteWorkout':
        {
          deleteWorkout(widget.workout, context);
          break;
        }
    }
  }

  ///Handles the deletation dialog of the workout
  void deleteWorkout(Workout workout, BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Bist du dir sicher?'),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).primaryColor),
                  ),
                  child: const Text('Abbrechen'),
                ),
              ),
              SizedBox(width: 10,),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    ServiceProvider.instance.workoutService.deleteWorkout(widget.workout);
                    Provider.of<User>(context, listen: false).deleteWorkout(widget.workout);
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => MyWorkoutPage()));
                  },
                  style: ButtonStyle(
                    backgroundColor:
                    MaterialStateProperty.all<Color>(Theme.of(context).errorColor),
                  ),
                  child: const Text('L\u00F6schen'),
                ),
              ),
            ],
          ),
        ));
  }
}
