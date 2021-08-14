import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:native_training/models/exercise.dart';
import 'package:native_training/models/user.dart';
import 'package:native_training/models/workout.dart';
import 'package:native_training/services/service_provider.dart';
import 'package:native_training/services/storage_provider.dart';

/// A service which loads all workouts and stores them
class WorkoutService extends ChangeNotifier {
  final List<Workout> _workouts = [];
  StreamSubscription _streamSubscription;
  StorageProvider _storage;

  /// init the service, should only be used once
  WorkoutService({StorageProvider storageProvider}) {
    _storage = storageProvider ?? StorageProvider.instance;
    _streamSubscription = _storage.database
        .collection('workouts')
        .snapshots()
        .listen(_updateElements);
  }

  @override
  void dispose() {
    _streamSubscription.cancel();
    super.dispose();
  }

  void _updateElements(QuerySnapshot snapshots) {
    _workouts.clear();
    for (final DocumentSnapshot snapshot in snapshots.docs) {
      _workouts.add(Workout.fromSnapshot(snapshot));
    }
    notifyListeners();
  }

  // ///handles the routing to MyworkoutAdd, if logged in: redirects to MyworkoutAdd, if not: redirect to LoginPage
  // void handle_create_workout(BuildContext context) {
  //   if (Provider.of<User>(context, listen: false).isLoggedIn) {
  //     Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //             builder: (context) => MyWorkoutAdd()));
  //   } else {
  //     Navigator.pushReplacement(
  //         context,
  //         MaterialPageRoute(
  //             builder: (context) => WhiteRedirectPage(
  //                 'Bitte melde Dich zuerst an', LoginPage())));
  //   }
  // }

  /// Returns a list of workouts which the provided User has
  List<Workout> getAllWorkoutsFromUser(User user) {
    return _workouts.where((workout) => workout.owner == user.userUUID).toList();
  }

  ///Delete all workouts from the user when the account is being deleted
  void deleteAllWorkoutsFromUser(User user) {
    final workouts = [];

    workouts.addAll(_workouts.where((workout) => workout.owner == user.userUUID));
    workouts.forEach((element) {
      deleteWorkout(element);
    });
  }

  /// Returns a list of all registered workouts
  List<Workout> getAllWorkout() {
    return _workouts;
  }

  ///Returns all elements inside the users active workout
  List<Exercise> getAllExercisesFromWorkout(
      Workout workout) {
    final result = <Exercise>[];
    for (final item in workout.ownedObjects.keys) {
      result.add(ServiceProvider.instance.exerciseService
          .getExerciseByTitle(item));
    }
    return result;
  }

  /// returns a single workout referenced by the provided reference
  Workout getWorkoutByReference(DocumentReference reference) {
    return _workouts.where((element) => element.reference == reference).first;
  }

  ///function to delete the workout from an user
  Future<void> deleteWorkout(Workout workout) async {
    if (workout.reference != null) {
      _storage.database.doc(workout.reference.path).delete();
    }
    _workouts.remove(workout);
  }
}