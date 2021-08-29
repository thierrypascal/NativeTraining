import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:native_training/components/drawer.dart';
import 'package:native_training/models/exercise.dart';
import 'package:native_training/models/user.dart';
import 'package:native_training/pages/exercise_page/edit_exercise.dart';
import 'package:native_training/pages/exercise_page/my_exercises_page.dart';
import 'package:native_training/services/service_provider.dart';
import 'package:provider/provider.dart';

/// Simple class to display a dialog
class ShowDialog extends StatefulWidget {
  ShowDialog(
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
  _ShowDialogState createState() => _ShowDialogState();
}

class _ShowDialogState extends State<ShowDialog> {

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
                    const Text('\u00DCbung löschen')
                  ],
                ),
              ),
            ],
            onSelected: _handleTopMenu,
          ),
        ],
      ),
      body: Padding(
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
    );
  }

  ///Handles the decision where to route to
  void _handleTopMenu(String value) {
    switch (value) {
      case 'EditExercise':
        {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => (EditExercise(widget.exercise))));
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
