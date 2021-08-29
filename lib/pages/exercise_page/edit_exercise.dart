import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:native_training/components/card_edit_dialog.dart';
import 'package:native_training/components/select_image_for_exercise.dart';
import 'package:native_training/components/white_redirect_page.dart';
import 'package:native_training/models/exercise.dart';
import 'package:native_training/models/user.dart';
import 'package:native_training/pages/exercise_page/my_exercises_page.dart';
import 'package:native_training/services/service_provider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class EditExercise extends StatefulWidget {
  EditExercise(this.exercise, {this.route, Key key}) : super(key: key);

  /// the Page which you will be redirected to after the timeout
  final Widget route;

  final Exercise exercise;

  @override
  _EditExerciseState createState() => _EditExerciseState();
}

class _EditExerciseState extends State<EditExercise> {
  final _formKey = GlobalKey<FormState>();
  String _toDeleteURL;
  bool _deleteRequested = false;
  Uint8List _toSaveImage;
  bool _saveRequested = false;
  String _title;
  String _description;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context, listen: false);

    return CardEditDialog(
      title: '\u00DCbung bearbeiten',
      abortCallback: () {
        Navigator.pop(context);
      },
      saveCallback: () async {
        if (_saveRequested) {
          widget.exercise.imageURL = await ServiceProvider.instance.imageService
              .uploadImage(_toSaveImage, 'exercisepictures',
                  filename: '${widget.exercise.title}_${const Uuid().v4()}');
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
            widget.exercise.title = _title;
            widget.exercise.description = _description;
            widget.exercise.owner = user.userUUID;
            await widget.exercise.saveExercise();
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
                exercise: widget.exercise,
                displayText: 'Bild hinzufügen',
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
                child: TextFormField(
                  initialValue: widget.exercise.title,
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
                  initialValue: widget.exercise.description,
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
