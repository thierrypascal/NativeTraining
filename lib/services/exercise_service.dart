import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:native_training/models/exercise.dart';
import 'package:native_training/models/user.dart';
import 'package:native_training/services/service_provider.dart';
import 'package:native_training/services/storage_provider.dart';

/// A service which loads all exercises and stores them
class ExerciseService extends ChangeNotifier {
  final List<Exercise> _exercises = [];
  StreamSubscription _streamSubscription;
  StorageProvider _storage;

  /// init the service, should only be used once
  ExerciseService({StorageProvider storageProvider}) {
    _storage = storageProvider ?? StorageProvider.instance;
    _streamSubscription = _storage.database.collection('exercises').snapshots().listen(_updateElements);
  }

  @override
  void dispose() {
    _streamSubscription.cancel();
    super.dispose();
  }

  void _updateElements(QuerySnapshot snapshots) {
    _exercises.clear();
    for (final DocumentSnapshot snapshot in snapshots.docs) {
      _exercises.add(Exercise.fromSnapshot(snapshot));
    }
    notifyListeners();
  }

  /// Returns a list of exercises which the provided User has
  List<Exercise> getAllExercisesFromUser(User user) {
    return _exercises.where((exercise) => exercise.owner == user.userUUID).toList();
  }

  /// Returns a list of exercises of a type which the provided User has
  List<Exercise> getAllExercisesFromUserOfType(User user, int type) {
    return _exercises
        .where((exercise) => exercise.owner == user.userUUID)
        .where((exercise) => exercise.type == type)
        .toList();
  }

  /// Returns a list of exercises of a type which the provided User has
  List<Exercise> getAllExercisesFromUserOfTypePlusType0(User user, int type) {
    return _exercises
        .where((exercise) => exercise.owner == user.userUUID)
        .where((exercise) => exercise.type == type || exercise.type == 0)
        .toList();
  }

  ///Delete all exercises from the user when the account is being deleted
  void deleteAllExercisesFromUser(User user) {
    final exercises = [];

    exercises.addAll(_exercises.where((exercise) => exercise.owner == user.userUUID));
    exercises.forEach((element) {
      deleteExercise(element);
    });
  }

  /// Returns a list of all registered exercises
  List<Exercise> getAllExercises() {
    return _exercises;
  }

  /// returns a single exercise referenced by the provided reference
  Exercise getExerciseByReference(DocumentReference reference) {
    return _exercises.where((element) => element.reference == reference).first;
  }

  /// returns the [Exercise] identified by the title
  Exercise getExerciseByTitle(String title) {
    try {
      return _exercises.where((element) => element.title == title).first;
    } on StateError {
      return null;
    }
  }

  /// returns the [Exercise] identified by the title
  List<Exercise> getWorkoutExercises(List<String> list) {
    List<Exercise> result = [];
    list.forEach((e) {
      try {
        result.add(_exercises.where((element) => element.title == e).first);
      }catch (e){
      }
    });
    return result;
  }

  /// returns the [Exercise] identified by the title
  List<String> getWorkoutExercisesTitle(List<Exercise> list) {
    List<String> result = [];
    list.forEach((e) {
      result.add(e.title);
    });
    return result;
  }

  ///function to delete the exercise from an user
  Future<void> deleteExercise(Exercise exercise) async {
    if (exercise.reference != null) {
      if (exercise.imageURL != null && exercise.imageURL.isNotEmpty) {
        ServiceProvider.instance.imageService.deleteImage(imageURL: exercise.imageURL);
      }
      _storage.database.doc(exercise.reference.path).delete();
    }
    _exercises.remove(exercise);
  }

  /// returns the numerical value of the type
  int getAbstractFromType(String type) {
    int abstrType = 0;
    switch (type) {
      case 'Anderes':
        abstrType = 0;
        break;
      case 'Aufw\u00E4rmen':
        abstrType = 1;
        break;
      case 'Training':
        abstrType = 2;
        break;
      case 'Dehnen':
        abstrType = 3;
        break;
    }
    return abstrType;
  }

  ///returns the String representation of the type
  String getTypeFromAbstract(int abstrType) {
    String type = 'Anderes';
    switch (abstrType) {
      case 0:
        type = 'Anderes';
        break;
      case 1:
        type = 'Aufw\u00E4rmen';
        break;
      case 2:
        type = 'Training';
        break;
      case 3:
        type = 'Dehnen';
        break;
    }
    return type;
  }
}
