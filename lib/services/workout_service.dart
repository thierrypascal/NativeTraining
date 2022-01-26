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
  List<Exercise> _currentlySelectedWarmupExercises = [];
  List<Exercise> _currentlySelectedWorkoutExercises = [];
  List<Exercise> _currentlySelectedCooldownExercises = [];

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

  /// Returns a list of all currently selected exercises in the workout edit/create workflow
  List<Exercise> getAllCurrentlySelectedWorkouts(){
    List<Exercise> allExercises = [];
    allExercises.addAll(_currentlySelectedWarmupExercises);
    allExercises.addAll(_currentlySelectedWorkoutExercises);
    allExercises.addAll(_currentlySelectedCooldownExercises);
    return allExercises;
  }

  /// Returns a list of all currently selected warmup exercises in the workout edit/create workflow
  List<Exercise> getCurrentlySelectedWarmupWorkouts(){
    return _currentlySelectedWarmupExercises;
  }

  /// Adds a element to the list of currently selected warmup exercises in the workout edit/create workflow
  void addToCurrentlySelectedWarmupWorkouts(Exercise e){
    _currentlySelectedWarmupExercises.add(e);
  }

  /// Removes a element to the list of currently selected warmup exercises in the workout edit/create workflow
  void removeFromCurrentlySelectedWarmupWorkouts(Exercise e){
    _currentlySelectedWarmupExercises.remove(e);
  }

  /// Returns a list of all currently selected workout exercises in the workout edit/create workflow
  List<Exercise> getCurrentlySelectedWorkoutWorkouts(){
    return _currentlySelectedWorkoutExercises;
  }

  /// Adds a element to the list of currently selected workout exercises in the workout edit/create workflow
  void addToCurrentlySelectedWorkoutWorkouts(Exercise e){
    _currentlySelectedWorkoutExercises.add(e);
  }

  /// Removes a element to the list of currently selected workout exercises in the workout edit/create workflow
  void removeFromCurrentlySelectedWorkoutWorkouts(Exercise e){
    _currentlySelectedWorkoutExercises.remove(e);
  }

  /// Returns a list of all currently selected workout exercises in the workout edit/create workflow
  List<Exercise> getCurrentlySelectedCooldownWorkouts(){
    return _currentlySelectedCooldownExercises;
  }

  /// Adds a element to the list of currently selected cooldown exercises in the workout edit/create workflow
  void addToCurrentlySelectedCooldownWorkouts(Exercise e){
    _currentlySelectedCooldownExercises.add(e);
  }

  /// Removes a element to the list of currently selected cooldown exercises in the workout edit/create workflow
  void removeFromCurrentlySelectedCooldownWorkouts(Exercise e){
    _currentlySelectedCooldownExercises.remove(e);
  }

  void clearAllCurrentlySelectedWorkouts(){
    _currentlySelectedWarmupExercises.clear();
    _currentlySelectedWorkoutExercises.clear();
    _currentlySelectedCooldownExercises.clear();
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

  set currentlySelectedWarmupExercises(List<Exercise> value) {
    _currentlySelectedWarmupExercises = value;
  }

  set currentlySelectedWorkoutExercises(List<Exercise> value) {
    _currentlySelectedWorkoutExercises = value;
  }

  set currentlySelectedCooldownExercises(List<Exercise> value) {
    _currentlySelectedCooldownExercises = value;
  }
}
