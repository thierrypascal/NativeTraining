import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:native_training/components/edit_dialog.dart';
import 'package:native_training/components/information_object_list_widget.dart';
import 'package:native_training/components/select_image_for_exercise.dart';
import 'package:native_training/components/white_redirect_page.dart';
import 'package:native_training/models/exercise.dart';
import 'package:native_training/models/user.dart';
import 'package:native_training/models/workout.dart';
import 'package:native_training/pages/exercise_page/my_exercises_page.dart';
import 'package:native_training/pages/workout_page/my_workouts_page.dart';
import 'package:native_training/services/service_provider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class EditWorkout extends StatefulWidget {
  EditWorkout({@required this.isEdit, this.workout, this.route, Key key})
      : super(key: key);

  /// if this workflow is used to edit
  final bool isEdit;

  /// the Page which you will be redirected to after the timeout
  final Widget route;

  ///The exercise that will be modified/created
  final Workout workout;

  @override
  _EditWorkoutState createState() => _EditWorkoutState();
}

class _EditWorkoutState extends State<EditWorkout> {
  final _formKey = GlobalKey<FormState>();
  final workoutProvider = ServiceProvider.instance.workoutService;
  Workout workout;
  String _title;
  String _description;
  List<Exercise> _selectedWarmupExercises = [];
  List<Exercise> _selectedWorkoutExercises = [];
  List<Exercise> _selectedCooldownExercises = [];

  @override
  void initState() {
    (widget.workout != null)
        ? workout = widget.workout
        : workout = Workout.empty();
    if (workout.warmupExercises.isNotEmpty) {
      _selectedWarmupExercises.addAll(workout.warmupExercises);
    }
    if (workout.workoutExercises.isNotEmpty) {
      _selectedWorkoutExercises.addAll(workout.workoutExercises);
    }
    if (workout.cooldownExercises.isNotEmpty) {
      _selectedCooldownExercises.addAll(workout.cooldownExercises);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context, listen: false);

    return EditDialog(
      //TODO: modify EditDialog to show color of selected type
      title: widget.isEdit ? 'Training bearbeiten' : 'Neues Training',
      abortCallback: () {
        Navigator.pop(context);
      },
      saveCallback: () async {
        _formKey.currentState.save();
        if (_title.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Du musst deinem Training einen Namen geben'),
          ));
        } else {
          if (!widget.isEdit && user.workouts.contains(_title)) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content:
                  Text('Du hast bereits ein Training mit dem Titel $_title.\n'
                      'Wähle bitte einen Anderen.'),
            ));
          }
          workout.title = _title;
          workout.description = _description;
          workout.owner = user.userUUID;
          await workout.saveWorkout();
          user.saveUser();
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => WhiteRedirectPage(
                    'Das Training $_title wurde gespeichert.',
                    widget.route ?? MyWorkoutPage(),
                    duration: 2,
                  )));
        }
      },
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
                child: TextFormField(
                  initialValue: workout.title,
                  decoration: const InputDecoration(
                      labelText: 'Titel',
                      contentPadding: EdgeInsets.symmetric(vertical: 4)),
                  onSaved: (value) => _title = value,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
                child: TextFormField(
                  maxLines: null,
                  initialValue: workout.description,
                  decoration: const InputDecoration(
                      labelText: 'Beschreibung',
                      contentPadding: EdgeInsets.symmetric(vertical: 4)),
                  onSaved: (value) => _description = value,
                ),
              ),
              (workout.warmupExercises.isNotEmpty)
                  ? InformationObjectListWidget(
                      objects: _selectedWarmupExercises,
                    )
              //TODO: change to color of Theme
                  : Text("empty"),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: Divider(
                  thickness: 2,
                ),
              ),
              (workout.workoutExercises.isNotEmpty)
                  ? InformationObjectListWidget(
                objects: _selectedWorkoutExercises,
              )
                  : Text("empty"),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: Divider(
                  thickness: 2,
                ),
              ),
              (workout.cooldownExercises.isNotEmpty)
                  ? InformationObjectListWidget(
                objects: _selectedCooldownExercises,
              )
                  : Text("empty"),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: Divider(
                  thickness: 2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
