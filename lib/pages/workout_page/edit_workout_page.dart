import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:native_training/components/edit_dialog.dart';
import 'package:native_training/components/information_object_list_widget.dart';
import 'package:native_training/components/select_image_for_exercise.dart';
import 'package:native_training/components/simple_information_object_card_widget.dart';
import 'package:native_training/components/white_redirect_page.dart';
import 'package:native_training/models/exercise.dart';
import 'package:native_training/models/user.dart';
import 'package:native_training/models/workout.dart';
import 'package:native_training/pages/exercise_page/my_exercises_page.dart';
import 'package:native_training/pages/exercise_page/show_exercise_page.dart';
import 'package:native_training/pages/workout_page/my_workouts_page.dart';
import 'package:native_training/services/service_provider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class EditWorkoutPage extends StatefulWidget {
  EditWorkoutPage({@required this.isEdit, this.workout, this.route, Key key}) : super(key: key);

  /// if this workflow is used to edit
  final bool isEdit;

  /// the Page which you will be redirected to after the timeout
  final Widget route;

  ///The exercise that will be modified/created
  final Workout workout;

  @override
  _EditWorkoutPageState createState() => _EditWorkoutPageState();
}

class _EditWorkoutPageState extends State<EditWorkoutPage> {
  final _formKey = GlobalKey<FormState>();
  final workoutService = ServiceProvider.instance.workoutService;
  final exerciseService = ServiceProvider.instance.exerciseService;
  Workout workout;
  String _title;
  String _description;
  List<Exercise> _selectedWarmupExercises = [];
  List<Exercise> _selectedWorkoutExercises = [];
  List<Exercise> _selectedCooldownExercises = [];

  @override
  void initState() {
    (widget.workout != null) ? workout = widget.workout : workout = Workout.empty();
    if (workout.warmupExercises.isNotEmpty) {
      _selectedWarmupExercises.addAll(workout.warmupExercises);
      workoutService.currentlySelectedWarmupExercises = workout.warmupExercises;
    }
    if (workout.workoutExercises.isNotEmpty) {
      _selectedWorkoutExercises.addAll(workout.workoutExercises);
      workoutService.currentlySelectedWorkoutExercises = workout.workoutExercises;
    }
    if (workout.cooldownExercises.isNotEmpty) {
      _selectedCooldownExercises.addAll(workout.cooldownExercises);
      workoutService.currentlySelectedCooldownExercises = workout.cooldownExercises;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context, listen: false);

    return EditDialog(
      needsInset: false,
      title: widget.isEdit ? 'Training bearbeiten' : 'Neues Training',
      abortCallback: () {
        workoutService.clearAllCurrentlySelectedWorkouts();
        Navigator.pop(context);
      },
      cancelCallback: () {
        workoutService.clearAllCurrentlySelectedWorkouts();
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
              content: Text('Du hast bereits ein Training mit dem Titel $_title.\n'
                  'Wähle bitte einen Anderen.'),
            ));
          }
          workout.title = _title;
          workout.description = _description;
          workout.owner = user.userUUID;
          workout.warmupExercises = _selectedWarmupExercises;
          workout.workoutExercises = _selectedWorkoutExercises;
          workout.cooldownExercises = _selectedCooldownExercises;
          await workout.saveWorkout();
          user.addWorkout(workout);
          user.saveUser();
          workoutService.clearAllCurrentlySelectedWorkouts();
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => WhiteRedirectPage(
                    'Das Training $_title wurde gespeichert.',
                    widget.route ?? MyWorkoutPage(),
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
                  decoration:
                      const InputDecoration(labelText: 'Titel', contentPadding: EdgeInsets.symmetric(vertical: 4)),
                  onSaved: (value) => _title = value,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
                child: TextFormField(
                  maxLines: null,
                  initialValue: workout.description,
                  decoration: const InputDecoration(
                      labelText: 'Beschreibung', contentPadding: EdgeInsets.symmetric(vertical: 4)),
                  onSaved: (value) => _description = value,
                ),
              ),
              if (_selectedWarmupExercises.isNotEmpty) _selectedWarmupExercisesList(),
              _addWarmupExercises(user),
              _divider(Colors.green),
              if (_selectedWorkoutExercises.isNotEmpty) _selectedWorkoutExercisesList(),
              _addWorkoutExercises(user),
              _divider(Colors.deepOrange),
              if (_selectedCooldownExercises.isNotEmpty) _selectedCooldownExercisesList(),
              _addCooldownExercises(user),
              _divider(Colors.deepPurple),
            ],
          ),
        ),
      ),
    );
  }

  Widget _selectedWarmupExercisesList() {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Flexible(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: _selectedWarmupExercises.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            'Noch kein Eintrag vorhanden, m\u00F6chtest du einen neuen anlegen?',
                            textScaleFactor: 2,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  : ReorderableListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: _selectedWarmupExercises.length,
                      itemBuilder: (context, index) {
                        final element = _selectedWarmupExercises.elementAt(index);
                        return SimpleInformationObjectCard(
                          element,
                          key: Key('$index'),
                          serviceProvider: ServiceProvider.instance,
                          onTapHandler: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => ShowExercisePage(element)));
                          },
                          showDeleteAndEdit: true,
                          onDeleteHandler: () {
                            setState(() {
                              _selectedWarmupExercises.removeAt(index);
                            });
                          },
                        );
                      },
                      onReorder: (int oldIndex, int newIndex) {
                        setState(() {
                          if (oldIndex < newIndex) {
                            newIndex -= 1;
                          }
                          final Exercise item = _selectedWarmupExercises.removeAt(oldIndex);
                          _selectedWarmupExercises.insert(newIndex, item);
                        });
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _addWarmupExercises(User user) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text("Aufw\u00E4rm\u00FCbung hinzuf\u00FCgen"),
        IconButton(
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return Container(
                      child: SingleChildScrollView(
                        child: InformationObjectListWidget(
                          true,
                          objects: exerciseService.getAllExercisesFromUserOfTypePlusType0(user, 1),
                          type: 1,
                        ),
                      ),
                    );
                  }).whenComplete(() => {
                    if (workoutService.getCurrentlySelectedWarmupWorkouts() != null)
                      {
                        setState(() {
                          _selectedWarmupExercises = workoutService.getCurrentlySelectedWarmupWorkouts();
                        }),
                      },
                  });
            },
            icon: Icon(Icons.add)),
      ],
    );
  }

  Widget _selectedWorkoutExercisesList() {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Flexible(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: _selectedWorkoutExercises.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            'Noch kein Eintrag vorhanden, m\u00F6chtest du einen neuen anlegen?',
                            textScaleFactor: 2,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  : ReorderableListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: _selectedWorkoutExercises.length,
                      itemBuilder: (context, index) {
                        final element = _selectedWorkoutExercises.elementAt(index);
                        return SimpleInformationObjectCard(
                          element,
                          key: Key('$index'),
                          serviceProvider: ServiceProvider.instance,
                          onTapHandler: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => ShowExercisePage(element)));
                          },
                          showDeleteAndEdit: true,
                          onDeleteHandler: () {
                            setState(() {
                              _selectedWorkoutExercises.removeAt(index);
                            });
                          },
                        );
                      },
                      onReorder: (int oldIndex, int newIndex) {
                        setState(() {
                          if (oldIndex < newIndex) {
                            newIndex -= 1;
                          }
                          final Exercise item = _selectedWorkoutExercises.removeAt(oldIndex);
                          _selectedWorkoutExercises.insert(newIndex, item);
                        });
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _addWorkoutExercises(User user) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text("Trainings\u00FCbung hinzuf\u00FCgen"),
        IconButton(
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return Container(
                      child: SingleChildScrollView(
                        child: InformationObjectListWidget(
                          true,
                          objects: exerciseService.getAllExercisesFromUserOfTypePlusType0(user, 2),
                          type: 2,
                        ),
                      ),
                    );
                  }).whenComplete(() => {
                    if (workoutService.getCurrentlySelectedWorkoutWorkouts() != null)
                      {
                        setState(() {
                          _selectedWorkoutExercises = workoutService.getCurrentlySelectedWorkoutWorkouts();
                        })
                      },
                  });
            },
            icon: Icon(Icons.add)),
      ],
    );
  }

  Widget _selectedCooldownExercisesList() {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Flexible(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: _selectedCooldownExercises.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            'Noch kein Eintrag vorhanden, m\u00F6chtest du einen neuen anlegen?',
                            textScaleFactor: 2,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  : ReorderableListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: _selectedCooldownExercises.length,
                      itemBuilder: (context, index) {
                        final element = _selectedCooldownExercises.elementAt(index);
                        return SimpleInformationObjectCard(
                          element,
                          key: Key('$index'),
                          serviceProvider: ServiceProvider.instance,
                          onTapHandler: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => ShowExercisePage(element)));
                          },
                          showDeleteAndEdit: true,
                          onDeleteHandler: () {
                            setState(() {
                              _selectedCooldownExercises.removeAt(index);
                            });
                          },
                        );
                      },
                      onReorder: (int oldIndex, int newIndex) {
                        setState(() {
                          if (oldIndex < newIndex) {
                            newIndex -= 1;
                          }
                          final Exercise item = _selectedCooldownExercises.removeAt(oldIndex);
                          _selectedCooldownExercises.insert(newIndex, item);
                        });
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _addCooldownExercises(User user) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text("Dehn\u00FCbung hinzuf\u00FCgen"),
        IconButton(
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return Container(
                      child: SingleChildScrollView(
                        child: InformationObjectListWidget(
                          true,
                          objects: exerciseService.getAllExercisesFromUserOfTypePlusType0(user, 3),
                          type: 3,
                        ),
                      ),
                    );
                  }).whenComplete(() => {
                    if (workoutService.getCurrentlySelectedCooldownWorkouts() != null)
                      {
                        setState(() {
                          _selectedCooldownExercises = workoutService.getCurrentlySelectedCooldownWorkouts();
                        })
                      },
                  });
            },
            icon: Icon(Icons.add)),
      ],
    );
  }

  Widget _divider(Color color) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: Divider(
        thickness: 2,
        color: color,
      ),
    );
  }
}
