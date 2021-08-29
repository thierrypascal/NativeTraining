import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:native_training/components/edit_dialog.dart';
import 'package:native_training/components/select_image_for_exercise.dart';
import 'package:native_training/components/show_dialog.dart';
import 'package:native_training/components/white_redirect_page.dart';
import 'package:native_training/models/exercise.dart';
import 'package:native_training/models/information_object.dart';
import 'package:native_training/models/user.dart';
import 'package:native_training/pages/exercise_page/my_exercises_page.dart';
import 'package:native_training/services/service_provider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class ShowExercise extends StatefulWidget {
  ShowExercise(this.exercise, {Key key}) : super(key: key);

  final InformationObject exercise;

  @override
  _ShowExerciseState createState() => _ShowExerciseState();
}

class _ShowExerciseState extends State<ShowExercise> {
  @override
  Widget build(BuildContext context) {
    return ShowDialog(
      exercise: widget.exercise,
      title: widget.exercise.title,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 150,
              child: ServiceProvider.instance.imageService.getImageByUrl(
                  widget.exercise.imageURL, fit: BoxFit.cover),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
              child: TextFormField(
                enabled: false,
                initialValue: widget.exercise.title,
                decoration: const InputDecoration(
                    labelText: 'Titel',
                    contentPadding: EdgeInsets.symmetric(vertical: 4)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
              child: TextFormField(
                enabled: false,
                maxLines: null,
                initialValue: widget.exercise.description,
                decoration: const InputDecoration(
                    labelText: 'Beschreibung',
                    contentPadding: EdgeInsets.symmetric(vertical: 4)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
