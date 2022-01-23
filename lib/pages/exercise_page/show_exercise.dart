
import 'package:flutter/material.dart';
import 'package:native_training/components/show_exercise_dialog.dart';
import 'package:native_training/models/exercise.dart';
import 'package:native_training/services/service_provider.dart';

class ShowExercise extends StatefulWidget {
  ShowExercise(this.exercise, {Key key}) : super(key: key);

  final Exercise exercise;

  @override
  _ShowExerciseState createState() => _ShowExerciseState();
}

class _ShowExerciseState extends State<ShowExercise> {
  @override
  Widget build(BuildContext context) {
    return ShowExerciseDialog(
      exercise: widget.exercise,
      title: widget.exercise.title,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 150,
              child: ServiceProvider.instance.imageService
                  .getImageByUrl(widget.exercise.imageURL, fit: BoxFit.cover),
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
                initialValue: ServiceProvider.instance.exerciseService
                    .getTypeFromAbstract(widget.exercise.type),
                decoration: const InputDecoration(
                    labelText: 'Typ',
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
