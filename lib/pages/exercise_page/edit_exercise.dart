import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:native_training/components/edit_dialog.dart';
import 'package:native_training/components/select_image_for_exercise.dart';
import 'package:native_training/components/white_redirect_page.dart';
import 'package:native_training/models/exercise.dart';
import 'package:native_training/models/user.dart';
import 'package:native_training/pages/exercise_page/my_exercises_page.dart';
import 'package:native_training/services/service_provider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

//TODO: Edit/Create as one workflow

class EditExercise extends StatefulWidget {
  EditExercise({@required this.isEdit, this.exercise, this.route, Key key}) : super(key: key);

  /// if this workflow is used to edit
  final bool isEdit;

  /// the Page which you will be redirected to after the timeout
  final Widget route;

  ///The exercise that will be modified/created
  final Exercise exercise;

  @override
  _EditExerciseState createState() => _EditExerciseState();
}

class _EditExerciseState extends State<EditExercise> {
  final _formKey = GlobalKey<FormState>();
  final exerciseProvider = ServiceProvider.instance.exerciseService;
  Exercise exercise;
  String _toDeleteURL;
  bool _deleteRequested = false;
  Uint8List _toSaveImage;
  bool _saveRequested = false;
  String _title;
  String _description;
  String _selectedType;
  final _type = ['Anderes', 'Aufw\u00E4rmen', 'Training', 'Dehnen'];

  @override
  void initState() {
    (widget.exercise != null) ? exercise = widget.exercise : exercise = Exercise.empty();
    (widget.exercise != null) ? _selectedType = exerciseProvider.getTypeFromAbstract(widget.exercise.type) : _selectedType = _type.elementAt(2);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context, listen: false);

    return EditDialog(
      title: widget.isEdit ? '\u00DCbung bearbeiten' : 'Neue \u00DCbung',
      abortCallback: () {
        Navigator.pop(context);
      },
      saveCallback: () async {
        if (_saveRequested) {
          exercise.imageURL = await ServiceProvider.instance.imageService
              .uploadImage(_toSaveImage, 'exercisepictures',
                  filename: '${exercise.title}_${const Uuid().v4()}');
        }
        if (_deleteRequested) {
          ServiceProvider.instance.imageService
              .deleteImage(imageURL: _toDeleteURL);
        }
        _formKey.currentState.save();
        if (_title.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Du musst deiner \u00DCbung einen Namen geben'),
          ));
        } else {
          if (!widget.isEdit && user.exercises.contains(_title)) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                  'Du hast bereits eine \u00DCbung mit dem Titel $_title.\n'
                      'Wähle bitte einen Anderen.'),
            ));
          }
          exercise.title = _title;
          exercise.description = _description;
          exercise.owner = user.userUUID;
          exercise.type =
              exerciseProvider.getAbstractFromType(_selectedType);
          await exercise.saveExercise();
          user.saveUser();
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => WhiteRedirectPage(
                    'Die \u00DCbung $_title wurde gespeichert.',
                    widget.route ?? MyExercisePage(),
                    duration: 2,
                  )));
        }
      },
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SelectExerciseImage(
                deleteFunction: (toDeleteURL) {
                  _toDeleteURL = toDeleteURL;
                  _deleteRequested = true;
                },
                saveFunction: (imageFile) {
                  setState(() {
                    _toSaveImage = imageFile;
                    _saveRequested = true;
                  });
                  Navigator.of(context).pop();
                },
                toSaveImage: _toSaveImage,
                exercise: exercise,
                displayText: 'Bild hinzufügen',
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
                child: TextFormField(
                  initialValue: exercise.title,
                  decoration: const InputDecoration(
                      labelText: 'Titel',
                      contentPadding: EdgeInsets.symmetric(vertical: 4)),
                  onSaved: (value) => _title = value,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                    isExpanded: true,
                    value: _selectedType,
                    onChanged: (value) => setState(() => _selectedType = value),
                    hint: const Text('Typ auswählen'),
                    items: _type.map((String dropDownStringItem) {
                      return DropdownMenuItem<String>(
                        value: dropDownStringItem,
                        child: Text(dropDownStringItem),
                      );
                    }).toList(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
                child: TextFormField(
                  maxLines: null,
                  initialValue: exercise.description,
                  decoration: const InputDecoration(
                      labelText: 'Beschreibung',
                      contentPadding: EdgeInsets.symmetric(vertical: 4)),
                  onSaved: (value) => _description = value,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
