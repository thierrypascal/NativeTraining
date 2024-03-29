import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:native_training/components/drawer.dart';
import 'package:native_training/models/exercise.dart';
import 'package:native_training/models/user.dart';
import 'package:native_training/pages/exercise_page/edit_exercise_page.dart';
import 'package:native_training/pages/exercise_page/my_exercises_page.dart';
import 'package:native_training/services/service_provider.dart';
import 'package:provider/provider.dart';

/// Simple class to display a dialog
class ShowExerciseDialog extends StatefulWidget {
  ShowExerciseDialog(
      {@required this.exercise,
        @required this.title,
        @required this.body,
        this.needsInset = true,
        Key key})
      : super(key: key);

  final Exercise exercise;
  final String title;
  final Widget body;
  final bool needsInset;

  @override
  _ShowExerciseDialogState createState() => _ShowExerciseDialogState();
}

class _ShowExerciseDialogState extends State<ShowExerciseDialog> {
  Color gradientStart;

  @override
  void initState() {
    switch (widget.exercise.type) {
      case 0:
        gradientStart = Colors.grey;
        break;
      case 1:
        gradientStart = Colors.green;
        break;
      case 2:
        gradientStart = Colors.deepOrange;
        break;
      case 3:
        gradientStart = Colors.deepPurple;
        break;
      default:
        gradientStart = Colors.grey;
        break;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      drawer: MyDrawer(),
      appBar: AppBar(
          title: Text(widget.title),
        actions: <Widget>[
          PopupMenuButton(
            itemBuilder: (bc) => [
              PopupMenuItem(
                value: 'EditExercise',
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Icon(
                        Icons.edit,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const Text('\u00DCbung bearbeiten')
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'DeleteExercise',
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Icon(
                        Icons.delete_forever,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const Text('\u00DCbung l\u00F6schen')
                  ],
                ),
              ),
            ],
            onSelected: _handleTopMenu,
          ),
        ],
      ),
      body: Container(
        decoration: new BoxDecoration(
          gradient: new LinearGradient(colors: [gradientStart, Theme.of(context).scaffoldBackgroundColor],
              begin: const FractionalOffset(0.0, 1.0),
              end: const FractionalOffset(1.0, 1.0),
              stops: [0.0,1.0],
              tileMode: TileMode.clamp,
          ),
        ),
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
      case 'EditExercise':
        {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => (EditExercisePage(isEdit: true, exercise: widget.exercise,))));
          break;
        }
      case 'DeleteExercise':
        {
          deleteExercise(widget.exercise, context);
          break;
        }
    }
  }

  ///Handles the deletation dialog of the exercise
  void deleteExercise(Exercise exercise, BuildContext context) {
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
                    ServiceProvider.instance.exerciseService.deleteExercise(widget.exercise);
                    Provider.of<User>(context, listen: false).deleteExercise(widget.exercise);
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => MyExercisePage()));
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
