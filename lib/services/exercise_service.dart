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
    _streamSubscription = _storage.database
        .collection('exercises')
        .snapshots()
        .listen(_updateElements);
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

  // ///handles the routing to MyExerciseAdd, if logged in: redirects to MyExerciseAdd, if not: redirect to LoginPage
  // void handle_create_exercise(BuildContext context) {
  //   if (Provider.of<User>(context, listen: false).isLoggedIn) {
  //     Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //             builder: (context) => MyExerciseAdd()));
  //   } else {
  //     Navigator.pushReplacement(
  //         context,
  //         MaterialPageRoute(
  //             builder: (context) => WhiteRedirectPage(
  //                 'Bitte melde Dich zuerst an', LoginPage())));
  //   }
  // }

  /// Returns a list of exercises which the provided User has
  List<Exercise> getAllExercisesFromUser(User user) {
    return _exercises.where((exercise) => exercise.owner == user.userUUID).toList();
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

  ///function to delete the exercise from an user
  Future<void> deleteExercise(Exercise exercise) async {
    if (exercise.reference != null) {
      if (exercise.imageURL != null && exercise.imageURL.isNotEmpty) {
        ServiceProvider.instance.imageService
            .deleteImage(imageURL: exercise.imageURL);
      }
      _storage.database.doc(exercise.reference.path).delete();
    }
    _exercises.remove(exercise);
  }
}